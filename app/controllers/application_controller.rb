class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def passthru
    user_id = params[:id]
    sign_in_and_redirect User.find_by(uid: user_id)
  end


  def update_all_projects
    Project.all.each{|ele| ele.resample_all_metrics}
    redirect_to projects_path
  end

end
