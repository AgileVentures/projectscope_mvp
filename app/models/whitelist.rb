# == Schema Information
#
# Table name: whitelists
#
#  id    :integer          not null, primary key
#  email :string
#

class Whitelist < ActiveRecord::Base
  validates_format_of :email,:with => Devise::email_regexp
  def self.has_email?(email)
    if Whitelist.find_by_email(email).nil?
      return false
    else
      return true
    end
  end
end
