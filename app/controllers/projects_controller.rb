class ProjectsController < ApplicationController
  before_action :set_project, only: [:show, :edit, :update, :destroy]

  before_action :init_existed_configs, only: [:show, :edit, :new]
  before_action :authenticate_user!

  # GET /projects
  # GET /projects.json

  def index
    @metric_names = current_user.preferred_metrics
    preferred_projects = current_user.preferred_projects.empty? ? Project.all : current_user.preferred_projects
    if params[:type].nil? or params[:type] == "project_name"
      @projects = order_by_project_name preferred_projects
    else
      @projects = order_by_metric_name preferred_projects
    end
    update_session
  end

  # GET /projects/1
  # GET /projects/1.json
  def show
    @readonly = true
    render :template => 'projects/edit'
  end

  # GET /projects/new
  def new
    @project = Project.new
  end

  # GET /projects/1/edit
  def edit
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
        format.html { redirect_to @project, notice: 'Project was successfully created.' }
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
  
  private
  def order_by_project_name preferred_projects
    session[:order] = "ASC" if session[:pre_click] != "project_name"
    preferred_projects.order_by_name(session[:order])
  end
  
  def order_by_metric_name preferred_projects
    click_type = params[:type]
    session[:order] = "ASC" if session[:pre_click] != click_type 
    preferred_projects.order_by_metric_score(click_type, session[:order])
  end
  
  def update_session
    session[:order] = session[:order] == "ASC" ? "DESC" : "ASC"
    session[:pre_click] = params[:type]
  end
end
