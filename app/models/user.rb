# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  provider_username      :string           default(""), not null
#  email                  :string           default("")
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string
#  last_sign_in_ip        :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  provider               :string
#  uid                    :string
#  role                   :string           default("student"), not null
#  preferred_metrics      :text
#

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :recoverable, 
    :rememberable, :trackable, :validatable, :omniauthable, :omniauth_providers => [:github]

  serialize :preferred_metrics, Array

  has_and_belongs_to_many :selected_projects, :foreign_key => "user_id", :class_name => "Project"
  has_many :ownerships
  has_many :owned_projects, :class_name => "Project", :through => :ownerships, :source => :project


  after_initialize :set_default_preferred_metrics

  ADMIN = "admin"
  INSTRUCTOR = "instructor"
  STUDENT = "student"

  def self.from_omniauth(auth)
    email = auth.info.email.nil? ? auth.extra.raw_info.email : auth.info.email
    login = auth.extra.raw_info.login
    unless login.nil?
    	User.where(provider: auth.provider, provider_username: login).first_or_create do |user|
    		user.provider = auth.provider
    		user.uid = auth.uid
    		user.email = email
        user.provider_username = login
    		user.password = Devise.friendly_token[0,20]
    	end
    end
  end
  
  def email_required?
    false
  end

  def is_admin?
  	self.role == ADMIN
  end

  def is_student?
    self.role == STUDENT
  end

  def is_instructor?
    self.role == INSTRUCTOR
  end
  
  def change_role(role)
    self.role = role
    self.save!
  end

  def preferred_projects
    self.selected_projects = Project.all if self.selected_projects.empty?
    self.selected_projects
  end

  def preferred_projects= projects
    self.selected_projects = projects
  end

  def is_owner_of? project
    self.owned_projects.include? project
  end

  private

  def set_default_preferred_metrics
    unless self.try(:preferred_metrics).nil? || self.preferred_metrics.length > 0
      self.preferred_metrics = ProjectMetrics.metric_names 
    end
  end
end
