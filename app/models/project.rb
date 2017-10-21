# == Schema Information
#
# Table name: projects
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :integer
#

class Project < ActiveRecord::Base
  has_many :configs
  has_many :metric_samples
  has_and_belongs_to_many :users
  has_many :ownerships
  has_many :owners, :class_name => "User", :through => :ownerships, :source => :user

  validates :name, :presence => true, :uniqueness => true

  accepts_nested_attributes_for :configs
  attr_accessible :name, :configs_attributes

  scope :order_by_metric_score, -> (metric_name, order) {
    joins(:metric_samples).where("metric_samples.metric_name = ?", metric_name)
        .group(:id)
        .having("metric_samples.created_at = MAX(metric_samples.created_at)")
        .order("metric_samples.score #{order}") if ["ASC", "DESC"].include? order }
  scope :order_by_name, -> (order) { order("name #{order}") if ["ASC", "DESC"].include? order }

  def config_for(metric)
    configs.where metric_name: metric
    # configs.where(:metric_name => metric).first || configs.build(:metric_name => metric)
  end

  # These two functions need further revisions.
  def all_metrics
    valid_configs = MetricSample.all.where(:project_id => id)
    return [] if valid_configs.nil?
    metrics_name_ary = []
    valid_configs.each do |config|
      metrics_name_ary << config.metric_name
    end
    metrics_name_ary.uniq
  end

  def report
    ProjectMetrics.hierarchies(:report).map do |r|
      latest_metric_sample r[:title]
    end
  end

  def latest_metric_sample(metric)
    metric_samples.latest_for metric
  end

  def latest_metric_samples(metrics = nil)
    metrics = ProjectMetrics.metric_names if metrics.nil?
    metrics.map do |metric_name|
      metric_samples.latest_for(metric_name)
    end
  end

  def metric_on_date(metric, date)
    metric_samples.where(created_at: (date.beginning_of_day.utc..date.end_of_day.utc), metric_name: metric)
  end

  def resample_all_metrics
    ProjectMetrics.metric_names.each { |metric_name| resample_metric metric_name }
  end

  def resample_metric(metric_name)
    credentials_hash = config_for(metric_name).inject(Hash.new) do |chash, config|
      return if config.token.empty? or config.nil?
      chash.update config.metrics_params.to_sym => config.token
    end
    unless credentials_hash.empty?
      metric = ProjectMetrics.class_for(metric_name).new(credentials_hash)
      begin
        metric.refresh
        image = metric.image
        score = metric.score
      rescue Exception => e
        logger.fatal "Metric #{metric_name} for project #{name} exception: #{e.message}"
        puts "Metric #{metric_name} for project #{name} exception: #{e.message}"
        return
      rescue Error => err
        logger.fatal "Metric #{metric_name} for project #{name} error: #{err.message}"
        puts "Metric #{metric_name} for project #{name} error: #{err.message}"
        return
      end
      self.metric_samples.create!( metric_name: metric_name,
                                   raw_data: metric.raw_data,
                                   score: score,
                                   image: image )
    end
  end

  def self.latest_metrics_on_date(projects, preferred_metrics, date)
    projects.collect do |p|
      p.metric_samples
          .where(created_at: (date.beginning_of_day..date.end_of_day), metric_name: preferred_metrics)
          .map { |m| p.attributes.merge(m.attributes) }
    end
  end

  def comments
    metric_samples.flat_map { |ms| ms.comments.where(ctype: 'general_comment') }.sort_by { |cmnt| Time.now - cmnt.created_at }
  end
end
