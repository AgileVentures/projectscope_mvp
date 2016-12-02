class Ownership < ActiveRecord::Base
  belongs_to :project
  belongs_to :user

  attr_accessible #none

  validates_uniqueness_of :user_id, :scope => :project_id
end
