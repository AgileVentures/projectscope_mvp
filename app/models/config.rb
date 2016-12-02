# == Schema Information
#
# Table name: configs
#
#  id                   :integer          not null, primary key
#  project_id           :integer
#  metric_name          :string
#  encrypted_options    :text
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  encrypted_options_iv :string
#

class Config < ActiveRecord::Base
  belongs_to :project
  scope :for, ->(metric_name) { where(:metric_name => metric_name).first }
  validates_uniqueness_of :metric_name, :scope => :project_id

  attr_encrypted :options, :key => Figaro.env.attr_encrypted_key!, :marshal => true
  after_initialize { self.options ||= {} }

  attr_accessible :options, :metric_name

  def klass
  	ProjectMetrics.class_for self.metric_name
  end
end

