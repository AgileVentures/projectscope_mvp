# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string           default(""), not null
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
#  role                   :string           default("coach"), not null
#

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable, :omniauth_providers => [:github]

  ADMIN = "admin"
  COACH = "coach"

  def self.from_omniauth(auth)
    email = auth.info.email.nil? ? auth.extra.raw_info.email : auth.info.email
    if !email.nil? and Whitelist.has_email? email
    	User.where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
    		user.provider = auth.provider
    		user.uid = auth.uid
    		user.email = email
    		user.password = Devise.friendly_token[0,20]
    	end
    end
  end

  def is_admin?
  	self.role == ADMIN
  end
end
