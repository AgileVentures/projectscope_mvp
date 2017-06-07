class UsersController < ApplicationController
  #before_action :authenticate_user!, :validate_current_user
  load_and_authorize_resource

  def show
    @user = User.find(params[:id])
    @all_projects = Project.all
    @all_metrics = ProjectMetrics.metric_names
    @preferred_projects = @user.preferred_projects
    # debugger
    @preferred_metrics = @user.preferred_metrics
  end

  def update
    @selected_projects = Project.where(:id => params[:projects].try(:keys))
    selected_metrics = params[:metrics] || []
    @preferred_metrics = {}
    selected_metrics.try(:keys).each do |metric|
      @preferred_metrics[metric] = selected_metrics[metric].try(:keys)
    end
    current_user.preferred_projects = @selected_projects
    current_user.preferred_metrics = [@preferred_metrics]
    if current_user.save
      flash[:notice] = "Preference saved successfully."
    else
      flash[:alert] = "Failed to save preference."
    end
    redirect_to user_path(current_user)
  end

  def init_new
    @user = User.find params[:id]
    @projects = Project.all
  end

  def init_update
    @user = User.find params[:id]
    @user.project = Project.find params[:project_id].to_i
    if @user.save
      redirect_to project_path @user.project
    else
      redirect_to :back, notice: 'Error update user!'
    end
  end

  private

  def validate_current_user
    unless params[:id].to_i == current_user.id
      flash[:alert] = "You do not have access to view other user's profile."
      redirect_to root_path
    end
  end
end
