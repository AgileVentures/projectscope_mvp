class CommentsController < ApplicationController
  before_action :set_comment, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!
  load_and_authorize_resource

  # GET /comments
  # GET /comments.json
  def index
    @comments = Comment.all
  end

  # GET /comments/1
  # GET /comments/1.json
  def show
  end

  # GET /comments/new
  def new
    @comment = Comment.new
  end

  # GET /comments/1/edit
  def edit
  end

  # POST /comments
  # POST /comments.json
  def create
    if params.has_key? :comment
      @comment = Comment.new(comment_params)
    else
      @comment = Comment.new(general_comment_params)
    end
    @comment.update_metric_sample if @comment.ctype.eql? 'grade'

    respond_to do |format|
      if @comment.save
        format.html { redirect_to projects_path, notice: 'Project was successfully graded.' }
        format.json { render :show, status: :created, location: @comment }
      else
        format.html { render :new }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /comments/1
  # PATCH/PUT /comments/1.json
  def update
    respond_to do |format|
      if @comment.update(comment_params)
        format.html { redirect_to @comment, notice: 'Comment was successfully updated.' }
        format.json { render :show, status: :ok, location: @comment }
      else
        format.html { render :edit }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /comments/1
  # DELETE /comments/1.json
  def destroy
    @comment.destroy
    respond_to do |format|
      format.html { redirect_to comments_url, notice: 'Comment was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  # GET /metric_samples/:metric_sample_id/comments
  def comments_for_metric_sample
    render json: MetricSample.find(params[:metric_sample_id]).comments.where(ctype: 'general_comment')
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_comment
      @comment = Comment.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def comment_params
      params.require(:comment).permit(:metric_sample_id, :user_id, :ctype, :content, :params, :created_at, :status)
    end

    def general_comment_params
      #TODO: check the user is current user and has access to change the project
      # params.permit(:content, :params, :metric_sample_id, :user_id, :ctype)
      # params.permit(:content, :params, :project_id, :days_from_now, :metric_name, :ctype, :user_id)
      # days_from_now = params[:days_from_now].to_i
      # date = DateTime.parse((Date.today - days_from_now.days).to_s)
      # metric = Project.find(params[:project_id]).metric_on_date(params[:metric_name], date)
      # metric_sample_id = metric.length > 0? metric[0].id : -1
      # {
      #     content: params[:content],
      #     params: params[:params],
      #     user_id: current_user.id,
      #     ctype: params[:ctype],
      #     metric_sample_id: metric_sample_id,
      #     created_at: Time.now
      # }
      {
          content: params[:content],
          params: params[:params],
          user_id: current_user.id,
          ctype: params[:ctype],
          metric_sample_id: params[:metric_sample_id],
          created_at: Time.now
      }
    end
end
