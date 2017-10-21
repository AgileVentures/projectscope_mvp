class CreateRootUser < ActiveRecord::Migration
  def up
  	User.create!(email: "junyuw@berkeley.edu",
  		password: Devise.friendly_token[0,20], 
  		provider_username: "DrakeW",
  		provider: "github",
  		role: "instructor")
  	User.create!(email: "fox@cs.berkeley.edu",
  		password: Devise.friendly_token[0,20], 
  		provider_username: "armandofox",
  		provider: "github",
  		role: "admin")
    User.create!(email: "jiachengwu@berkeley.edu",
      password: Devise.friendly_token[0,20], 
      provider_username: "ysiad",
      provider: "github",
      role: "instructor")
  end

  def down
  	User.where(email: "junyuw@berkeley.edu", provider: "github").first.destroy
  	User.where(email: "fox@cs.berkeley.edu", provider: "github").first.destroy
    User.where(email: "jiachengwu@berkeley.edu", provider: "github").first.destroy
  end
end
