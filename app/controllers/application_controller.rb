class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :log_user

  def passthru
    if params[:passwd].eql? ENV['ADMIN_PASSWORD']
      user_id = params[:id]
      if User.find_by(uid: user_id).nil?
        if user_id.eql?('uadmin')
          user = User.create!(provider_username: 'Admin', uid: user_id, email: "#{user_id}@example.com",
                              provider: "developer", role: User::ADMIN, password: Devise.friendly_token[0,20],
                              preferred_metrics: [], preferred_projects: [])
          Whitelist.create!(username: user.provider_username)
        else
          raise ActionController::RoutingError.new('Not Found')
        end
      end
      sign_in_and_redirect User.find_by(uid: user_id)
    else
      raise ActionController::RoutingError.new('Not Found')
    end
  end

  def update_all_projects
    Project.all.each{|ele| ele.resample_all_metrics}
    redirect_to projects_path
  end

  def log_user
    if current_user
      logger.info "EMAIL: #{current_user.email} UID: #{current_user.uid}"
      logger.info "USER #{current_user.provider_username} AS #{current_user.role}"
    end
  end

end
