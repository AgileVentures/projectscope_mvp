class MetricSample < ActiveRecord::Base
  belongs_to :project

  attr_encrypted :raw_data, :key => Figaro.env.attr_encrypted_key!
end
