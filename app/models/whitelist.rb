# == Schema Information
#
# Table name: whitelists
#
#  id       :integer          not null, primary key
#  username :string
#

class Whitelist < ActiveRecord::Base
  validates_format_of :username,:with => /\A[a-z0-9\-_]+\z/i
  
  def self.has_username?(username)
    return !Whitelist.find_by_username(username).nil?
  end
end
