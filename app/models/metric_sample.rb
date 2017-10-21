# == Schema Information
#
# Table name: metric_samples
#
#  id                    :integer          not null, primary key
#  project_id            :integer
#  metric_name           :string
#  encrypted_raw_data    :text
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  encrypted_raw_data_iv :string
#  score                 :float
#  image                 :text
#

class MetricSample < ActiveRecord::Base
  belongs_to :project
  has_many :comments
  attr_encrypted :raw_data, :key => Figaro.env.attr_encrypted_key!

  def self.latest_for metric_name
    where(:metric_name => metric_name).last
  end

  def self.min_date
	earliest_metric = MetricSample.order(:created_at).first
	earliest_metric.created_at.to_date unless earliest_metric.nil?
  end

  def days_ago
    (Date.today - created_at.to_date).to_i
  end

end
