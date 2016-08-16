class Config < ActiveRecord::Base
  belongs_to :project
  scope :for, ->(metric_name) { where(:metric_name => metric_name).first }
  validates_uniqueness_of :metric_name, :scope => :project_id

  attr_encrypted :options, :key => Figaro.env.attr_encrypted_key!, :marshal => true
  after_initialize { self.options ||= {} }

  attr_accessible :options, :metric_name

end

