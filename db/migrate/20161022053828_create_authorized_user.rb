class CreateAuthorizedUser < ActiveRecord::Migration
  def up
  	Whitelist.create!(email: Figaro.env.root_user_email)
  end
  
  def down
  	user = Whitelist.find_by_email(Figaro.env.root_user_email)
  	user.destroy
  end
end
