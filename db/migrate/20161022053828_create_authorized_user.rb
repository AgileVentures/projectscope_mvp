class CreateAuthorizedUser < ActiveRecord::Migration
  def up
  	Whitelist.create!(username: "DrakeW")
  	Whitelist.create!(username: "armandofox")
  end
  
  def down
  	Whitelist.where(username: "DrakeW").first.destroy
  	Whitelist.where(username: "armandofox").first.destroy
  end
end
