require 'json'
class ProjectsController < ApplicationController
  before_action :set_project, only: [:show, :edit, :update, :destroy, :add_owner, :show_metric]
  before_action :init_existed_configs, only: [:show, :edit, :new]
  before_action :authenticate_user!


  # GET /projects
  # GET /projects.json

  def new_index
    @metric_names = current_user.preferred_metrics
    # preferred_projects = current_user.preferred_projects.empty? ? Project.all : current_user.preferred_projects
    preferred_projects = Project.all
    if params[:type].nil? or params[:type] == "project_name"
      @projects = order_by_project_name preferred_projects
    else
      @projects = order_by_metric_name preferred_projects
    end
    update_session

    metric_min_date = MetricSample.min_date || Date.today
    @num_days_from_today = (Date.today - metric_min_date).to_i
  end

  def index
    @metric_names = current_user.preferred_metrics
    preferred_projects = current_user.preferred_projects.empty? ? Project.all : current_user.preferred_projects
    if params[:type].nil? or params[:type] == "project_name"
      @projects = order_by_project_name preferred_projects
    else
      @projects = order_by_metric_name preferred_projects
    end
    update_session

    metric_min_date = MetricSample.min_date || Date.today
    @num_days_from_today = (Date.today - metric_min_date).to_i
  end

  # GET /projects/1
  # GET /projects/1.json
  def show
    # debugger
    @readonly = true
    @owners = @project.owners
    render :template => 'projects/edit'
  end

  # GET /projects/new
  def new
    @project = Project.new
  end

  # GET /projects/1/edit
  def edit
    @owners = @project.owners
    @project.configs.each do |config|
      name = config.metric_name
      if config.klass.respond_to?(:credentials)
        config.options.each_pair do |key,_val|
            @existed_configs[name] << key.to_sym
        end
      end
    end
  end

  # POST /projects
  # POST /projects.json
  def create
    @project = Project.new(project_params)
    respond_to do |format|
      if @project.save
        current_user.preferred_projects << @project
        current_user.owned_projects << @project
        format.html { redirect_to @project, notice: 'Project was successfully created.' }
        format.json { render :show, status: :created, location: @project }
      else
        format.html { render :new }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  def get_metric_data
    #from @project to get metric
    @data = MetricSample.find_by(project_id:params[:id], metric_name:params[:metric])[:image]
    render json: @data
  end


  # PATCH/PUT /projects/1
  # PATCH/PUT /projects/1.json
  def update
    @project.attributes = project_params
    respond_to do |format|
      if @project.save
        format.html { redirect_to projects_path, notice: 'Project was successfully updated.' }
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

  def metrics_on_date
    days_from_now = params[:days_from_now].to_i
    date = DateTime.parse((Date.today - days_from_now.days).to_s)
    # debugger
    if params[:id].nil?
      # debugger
      preferred_projects = current_user.preferred_projects.empty? ? Project.all : current_user.preferred_projects
      metrics = current_user.preferred_metrics
      @metrics = Project.latest_metrics_on_date preferred_projects, metrics, date
      # debugger
      respond_to do |format|
        format.json { render json: { data: @metrics, date: date} }
      end
    else
      # debugger
      preferred_projects = Project.where(:id => params[:id])
      metrics = params[:metric]
      @metrics = Project.latest_metrics_on_date preferred_projects, metrics, date
      if (@metrics == [[]])
        respond_to do |format|
          format.json { render json: { score: "", image: "Project Information Needs to be Updated." } }
        end
      else
        respond_to do |format|
          format.json { render json: { score: @metrics[0][0]['score'], image: @metrics[0][0]['image'] } }
        end
      end
      # debugger

    end
  end

  # def show_metric
  #   # debugger
  #   # id = params[:id] # retrieve movie ID from URI route
  #   days_from_now = params[:days_from_now].to_i
  #   date = DateTime.parse((Date.today - days_from_now.days).to_s)
  #   metric = [params[:metric]]
  #   project = Project.find(params[:id])
  #   @metrics = Project.latest_metrics_on_date project, metric, date
  #   @metric = params[:metric]
  #   respond_to do |format|
  #     format.json{render json: {@metrics, date: date} }
  #   end
  #   # @days_from_now = params[:days_from_now]
  #   # debugger
  #   # respond_to do |format|
  #   #   format.html { render(:partial => 'hello_world') }
  #   # end
  # end

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
    # Grab new option keys/vals from params, and incorporate them into
    #  the configs existing keys/vals.
    # Example: given params['config']['code_climate']
    #  BEFORE: {"options"=>{"token"=>"xyz", "user"=>"fox"}, "new"=>["a", "2", "b", "3"]}
    #  AFTER:  {"options"=>{"token"=>"xyz", "user"=>"fox", "a" => "2", "b" => "3"}
    params['project']['configs_attributes'].each_pair do |index, v|
      v['options'] ||= {}
      # ingest new options from new[] array
      v['options'].merge!(Hash[*(v.delete('new'))])
      # delete options with blank values
      v['options'].delete_if { |k,v| v.blank? }
    end
    params['project']
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


  # get path: projects/:id/
  # param metric_name string:"github"
  # return all data from matrics_smaple of github relate to this project
  def metrics_data(id, metric_name)
    MetricSample.latest_metric(id, metric_name)
  end

end
