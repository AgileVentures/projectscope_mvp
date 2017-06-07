require 'json'
class ProjectsController < ApplicationController
  before_action :set_project, only: [:show, :edit, :update, :destroy, :add_owner, :show_metric, :show_report,
                                     :get_metric_data, :get_metric_series]
  before_action :init_existed_configs, only: [:show, :edit, :new]
  before_action :authenticate_user!
  load_and_authorize_resource

  # GET /projects
  # GET /projects.json
  def index
    if current_user.is_student?
      if current_user.project.nil?
        redirect_to init_user_path current_user
      else
        redirect_to project_path current_user.project
      end
    end
    @current_page = params.has_key?(:page) ? (params[:page].to_i - 1) : 0
    @display_type = params.has_key?(:type) ? (params[:type]) : 'metric'
    # @projects = current_user.preferred_projects.empty? ? Project.all : current_user.preferred_projects
    @projects = Project.all
    update_session

    metric_min_date = MetricSample.min_date || Date.today
    @num_days_from_today = (Date.today - metric_min_date).to_i
  end

  # GET /projects/1
  # GET /projects/1.json
  def show
    @owners = @project.owners
    @current_page = params.has_key?(:page) ? (params[:page].to_i - 1) : 0
    @display_type = params.has_key?(:type) ? (params[:type]) : 'metric'
    metric_min_date = MetricSample.min_date || Date.today
    @num_days_from_today = (Date.today - metric_min_date).to_i
  end

  # GET /projects/new
  def new
    @project = Project.new
    @credentials = ProjectMetrics.metric_names\
                       .flat_map { |m| ProjectMetrics.class_for(m).credentials }\
                       .uniq\
                       .group_by { |name| name.to_s.split('_')[0].to_sym }
  end

  # GET /projects/1/edit
  def edit
    @configs = {}
    all_configs = @project.configs.select(:metric_name, :metrics_params, :token).map(&:attributes)
    all_configs.each do |config|
      @configs[config["metric_name"]] ||= []
      @configs[config["metric_name"]] << {config["metrics_params"] => config["token"]}
    end
  end

  # POST /projects
  # POST /projects.json
  def create
    update_params = project_params
    config_params = update_params.delete 'configs'
    @project = Project.new(update_params)
    ProjectMetrics.metric_names.each do |m|
      ProjectMetrics.class_for(m).credentials.each do |param|
        if config_params.has_key? param.to_s
          @project.configs << Config.new(metric_name: m, metrics_params: param, token: config_params[param])
        end
      end
    end
    respond_to do |format|
      if @project.save
        current_user.preferred_projects << @project
        current_user.owned_projects << @project
        format.html { redirect_to projects_path, notice: 'Project was successfully created.' }
        format.json { render :show, status: :created, location: @project }
      else
        format.html { render :new }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /projects/1
  # PATCH/PUT /projects/1.json
  def update
    update_params = project_params
    config_params = update_params.delete 'configs'
    notice = ''
    @project.configs.each do |config|
      if config_params.has_key? config.metric_name and config_params[config.metric_name].has_key? config.metrics_params
        config.token = config_params[config.metric_name][config.metrics_params]
        notice += "Failed to update config #{config.metric_name}: #{config.metrics_params}\n" unless config.save
      end
    end
    @project.attributes = update_params
    respond_to do |format|
      if @project.save
        format.html { redirect_to projects_path, notice: 'Project was successfully updated.' + notice }
        format.json { render :show, status: :ok, location: @project }
      else
        format.html { render :edit }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /projects/1
  # DELETE /projects/1.json
  def destroy
    @project.destroy
    respond_to do |format|
      format.html { redirect_to projects_url, notice: 'Project was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  # GET /projects/:id/metrics/:metric/detail
  def show_metric
    @metric_name = params[:metric]

    @comments = @project.metric_samples.where(metric_name: @metric_name).sort_by { |elem| Time.now-elem.created_at }
    @comments = @comments.map do |metric_sample|
      [days_ago(metric_sample.created_at), metric_sample.comments.select(&:general_comment?)]
    end

    @parent_metric = @project.latest_metric_sample params[:metric]
    render template: 'projects/metric_detail'
  end

  # GET /projects/:id/metrics/:metric/report
  def show_report
    report = ProjectMetrics.hierarchies(:report).select { |m| m[:title].eql? params[:metric].to_sym }.first
    @sub_metrics = report[:contents]
    @practice_name = report[:title].to_s
    @days_from_now = 0
    @parent_metric = @project.latest_metric_sample params[:metric]
    metric_min_date = MetricSample.min_date || Date.today
    @num_days_from_today = (Date.today - metric_min_date).to_i
    render template: 'projects/metric_report'
  end

  # GET /projects/:id/metrics/:metric
  def get_metric_data
    days_from_now = params[:days_from_now] ? params[:days_from_now].to_i : 0
    date = Date.today - days_from_now.days
    metric = @project.metric_on_date params[:metric], date
    if metric.length > 0
      render json: metric.last
    else
      render :json => {:error => "not found"}, :status => 404
    end
  end

  # GET /projects/:id/metrics/:metric/series
  def get_metric_series
    metric_samples = @project.metric_samples.where(metric_name: params[:metric])
    if metric_samples.length > 0
      metric_samples = metric_samples.sort_by { |m| m.created_at }.map &:attributes
      metric_samples = metric_samples.map do |m|
        m.delete('encrypted_raw_data')
        m.delete('encrypted_raw_data_iv')
        m.update datetime: m['created_at'].strftime('%Y-%m-%dT%H:%M')
      end
      render json: metric_samples
    else
      render json: {:error => 'not found'}, status: 404
    end
  end

  def add_owner
    new_username = params[:username]
    new_owner = User.find_by_provider_username new_username
    if current_user.is_owner_of? @project and !new_owner.nil?
      begin
        @project.owners << new_owner
        flash[:notice] = "#{new_username} has become an owner of this project!"
      rescue
        flash[:alert] = "Failed to add #{new_username} as owner."
      end
    end
    redirect_to project_path(@project)
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_project
    @project = Project.includes(:configs).find(params[:id])
  end

  def init_existed_configs
    @existed_configs = {}
    ProjectMetrics.metric_names.each do |name|
      @existed_configs[name] = []
    end
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def project_params
    params[:project]
  end

  def order_by_project_name(preferred_projects)
    session[:order] = "ASC" if session[:pre_click] != "project_name"
    preferred_projects.order_by_name(session[:order])
  end

  def order_by_metric_name(preferred_projects)
    click_type = params[:type]
    session[:order] = "ASC" if session[:pre_click] != click_type
    preferred_projects.order_by_metric_score(click_type, session[:order])
  end

  def update_session
    session[:order] = session[:order] == "ASC" ? "DESC" : "ASC"
    session[:pre_click] = params[:type]
  end

  def days_ago(t)
    days = (Time.now - t).to_i / (24*3600)
  end

  # get path: projects/:id/
  # param metric_name string:"github"
  # return all data from matrics_smaple of github relate to this project
  def metrics_data(id, metric_name)
    MetricSample.latest_metric(id, metric_name)
  end

end
