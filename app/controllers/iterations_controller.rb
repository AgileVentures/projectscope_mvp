require 'faraday'

class IterationsController < ApplicationController
  before_action :set_iteration, only: [:show, :edit, :update, :destroy]

  # GET /iterations
  # GET /iterations.json
  def index
    @iterations = Iteration.all
    if current_user.is_student?
      redirect_to init_user_path current_user
    end
    @current_page = params.has_key?(:page) ? (params[:page].to_i - 1) : 0
    @display_type = params.has_key?(:type) ? (params[:type]) : 'metric'
    # @projects = current_user.preferred_projects.empty? ? Project.all : current_user.preferred_projects
    @projects = Project.all
    @template_iterations = Iteration.where(template:true)
    # metric_min_date = MetricSample.min_date || Date.today
    # @num_days_from_today = (Date.today - metric_min_date).to_i
  end

  # GET /iterations/1
  # GET /iterations/1.json
  def show
    @tasks = Task.where(iteration: @iteration.id)
    @preliminaryTasks = @tasks.select{|task| task.updater_type == 'preliminary'}
    @devTasks = @tasks.select{|task| task.updater_type == 'development'}
    @postTasks = @tasks.select{|task| task.updater_type == 'post'}
    @editable = !(current_user.is_student?)
    @prepercent, @devpercent, @postpercent, @predan, @devdan, @postdan =
        Iteration.percentage_progress @preliminaryTasks, @devTasks, @postTasks
    @devtaskTitles = ['Lo-fi Mockup', 'Pair programming', 'Code Review',
                     'Finish Story', 'TDD and BDD', 'Points Estimation',
                     'Pull Request'].freeze
    @pretaskTitles = ['Customer Meeting', 'Iteration Planning', 'GSI Meeting',
                     'Scrum meeting', 'Configuration Setup', 'Test Title'].freeze
    @postaskTitles = ['Deploy', 'Cross Group Review', 'Customer Feedback'].freeze
  end

  # GET /iterations/new
  def new
    if current_user.is_student?
      if current_user.project.nil?
        redirect_to init_user_path current_user
      else
        redirect_to project_path current_user.project
      end
    end
    @devtaskTitles = ['Lo-fi Mockup', 'Pair programming', 'Code Review',
                      'Finish Story', 'TDD and BDD', 'Points Estimation',
                      'Pull Request'].freeze
    @pretaskTitles = ['Customer Meeting', 'Iteration Planning', 'GSI Meeting',
                      'Scrum meeting', 'Configuration Setup', 'Test Title'].freeze
    @postaskTitles = ['Deploy', 'Cross Group Review', 'Customer Feedback'].freeze
    @iteration = Iteration.new
    @projects = Project.all
  end

  # GET /iterations/1/edit
  def edit
  end

  # POST /iterations
  # POST /iterations.json
  def create
    @iteration = Iteration.new
    @iteration.name = params[:template]
    @iteration.template = true
    @iteration.save
    redirect_to '/iterations'
  end

  def update_all
    @iteration = Iteration.find(params[:iteration_id])
    redirect_to @iteration
    # the following are temporarily commented as events is not deployed
    # response = Events::update_all
    # response_hash = JSON.parse(response)
    # Iteration.task_graph_update response_hash
  end

  def iteration_task
    task = Task.find(params[:task_id])
    @iteration = Iteration.find(params[:iteration_id])
    if Task.no_update? task
      redirect_to @iteration, notice: 'Uable to update as parent not fiinished.'
    else
      Task.update_status task
      redirect_to @iteration
    end
  end

  def iteration_task_reset
    task = Task.find(params[:task_id])
    @iteration = Iteration.find(params[:iteration_id])
    task.reset_status
    redirect_to @iteration
  end

  def delete_task
    task = Task.find(params[:task_id])
    @iteration = Iteration.find(params[:iteration_id])
    task.destroy
    redirect_to @iteration
  end

  def create_task
    @iteration = Iteration.find params[:iteration_id]
    newtask = Task.new
    newtask.updater_type = params[:updater_type]
    newtask.title = params[:title]
    newtask.task_status = "unstarted"
    newtask.iteration_id = params[:iteration_id]
    newtask.description = params[:description]
    newtask.save
    redirect_to @iteration
  end

  def aggregate_tasks_graph
    if current_user.is_student?
      if current_user.project.nil?
        redirect_to init_user_path current_user
      else
        redirect_to project_path current_user.project
      end
    end
    @projects = Project.all
    @progress = Iteration.task_progress
    @tasks_iter = {}
    @progress_hash = {}
    @projects.each do |proj|
      @progress_hash[proj.id] = Iteration.count_graph_status proj.id
      iter = Iteration.where(project_id:proj.id)
      tasks = Task.where(iteration_id: iter[0].id)
      @tasks_iter[proj.id] = tasks
    end
  end

  def apply_to
    project = Project.find params[:project_id]
    iteration = Iteration.find(params[:id])
    newiter = Iteration.copy_assignment iteration, project.id
    newiter.set_timestamp params[:start_time], params[:end_time]
    redirect_to '/iterations'
  end

  def dashboard
    @projects = Project.all
    @progress = Iteration.task_progress
    # temp value that will be class attribute when there are more than one class
    @iteration_num = 4
  end

  def show_template
    @iteration = Iteration.find(params[:id])
    @tasks = Task.where(iteration: @iteration.id)
    @preliminaryTasks = @tasks.select{|task| task.updater_type == 'preliminary'}
    @devTasks = @tasks.select{|task| task.updater_type == 'development'}
    @postTasks = @tasks.select{|task| task.updater_type == 'post'}
    @editable = !(current_user.is_student?)
    @prepercent, @devpercent, @postpercent, @predan, @devdan, @postdan =
        Iteration.percentage_progress @preliminaryTasks, @devTasks, @postTasks
    @devtaskTitles = ['Lo-fi Mockup', 'Pair programming', 'Code Review',
                      'Finish Story', 'TDD and BDD', 'Points Estimation',
                      'Pull Request'].freeze
    @pretaskTitles = ['Customer Meeting', 'Iteration Planning', 'GSI Meeting',
                      'Scrum meeting', 'Configuration Setup', 'Test Title'].freeze
    @postaskTitles = ['Deploy', 'Cross Group Review', 'Customer Feedback'].freeze
  end

  def select_projects
    @iteration = Iteration.find(params[:id])
    @projects = Project.all
  end

  def create_template_task
    @iteration = Iteration.find params[:iteration_id]
    newtask = Task.new
    newtask.updater_type = params[:updater_type]
    newtask.title = params[:title]
    newtask.task_status = "unstarted"
    newtask.iteration_id = params[:iteration_id]
    newtask.description = params[:description]
    newtask.save
    redirect_to show_iter_temp_path(@iteration.id)
  end

  def confirm_assignment
    project_ids = params[:project_ids].collect {|id| id.to_i} if params[:project_ids]
    @iteration = Iteration.find(params[:id])
    @projects = project_ids.map{|proj| Project.find(proj)}
  end

  def delete_iteration
    @iteration = Iteration.find(params[:id])
    @iteration.destroy
    redirect_to iterations_path
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_iteration
      @iteration = Iteration.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def iteration_params
      params.fetch(:iteration, {})
    end
end
