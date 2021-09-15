class TasksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_task, only: %i[ show edit update destroy ]
  before_action :set_project

  # GET /tasks or /tasks.json
  def index
    @tasks = Task.all
  end

  # GET /tasks/1 or /tasks/1.json
  def show
  end

  # GET /tasks/new
  def new
    @task = Task.new
  end

  # GET /tasks/1/edit
  def edit
  end

  # POST /tasks or /tasks.json
  def create
    @task = @project.tasks.new(task_params)

    respond_to do |format|
      if @task.save
        (@project.users.uniq).each do |user|
          TaskMailer.with(task: @task, user: user, author: current_user).task_created.deliver_later
        end

        format.html { redirect_to project_path(@project), notice: "Task was successfully created." }
      else
        format.html { redirect_to project_path(@project) }
      end
    end
  end

  # PATCH/PUT /tasks/1 or /tasks/1.json
  def update
    
    @task = @project.tasks.find(params[:task][:id])

    respond_to do |format|
      if params[:task][:complete] == "true" 
        @task.update(complete: true)
        
        ## add the three lines below
        (@project.users.uniq).each do |user| #- [current_user]
          TaskMailer.with(task: @task, user: user, author: current_user).task_completed.deliver_later
        end

      end

      if @task.update(task_params)
        format.json { render :show, status: :ok, location: project_path(@project) }
      else
        format.html { render_to project_path(@project) }
      end
    end
  end

  # DELETE /tasks/1 or /tasks/1.json
  def destroy
    @task.destroy
    respond_to do |format|
      format.html { redirect_to tasks_url, notice: "Task was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_task
      @task = Task.find(params[:id])
    end

    def set_project
      @project = Project.find(params[:project_id])
    end

    # Only allow a list of trusted parameters through.
    def task_params
      params.require(:task).permit(:id, :body, :project_id, :complete)
    end
end
