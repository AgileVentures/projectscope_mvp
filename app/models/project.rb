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
    configs.where(:metric_name => metric).first || configs.build(:metric_name => metric)
  end

  def latest_metric_samples
    ProjectMetrics.metric_names.map do |metric_name|
      metric_samples.latest_for(metric_name)
    end
  end

  def resample_all_metrics
    ProjectMetrics.metric_names.each { |metric_name| resample_metric metric_name }
  end

  def resample_metric(metric_name)
    credentials_hash = config_for(metric_name).options
    unless credentials_hash.empty?
      metric = ProjectMetrics.class_for(metric_name).new(credentials_hash)
      if (metric.refresh)
        self.metric_samples.create!(metric_name: metric_name,
                                    raw_data: metric.raw_data,
                                    score: metric.score,
                                    image: metric.image
        )
      end
    end
  end

end
