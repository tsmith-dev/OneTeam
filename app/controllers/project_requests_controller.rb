class ProjectRequestsController < ApplicationController
  before_action :logged_in_employee, only: [:new, :edit]
  
  def index
    if params.include?(:employee_id)
      @project_requests = ProjectRequest.where(employee_id: params[:employee_id])
    else
      @project_requests = ProjectRequest.current.open
    end
  end

  def new
    @projects = Project.all
    @project_request = ProjectRequest.new(flash[:params])
    @skills = Skill.all
  end

  def edit
   @project_request = ProjectRequest.find(params[:id])
   @employees = Employee.all
   @groups = Group.all
   @projects = Project.all
   @skills = Skill.all
  end

  def create
    @project_request = current_employee.project_requests.new(project_request_params)
    params[:project_request][:skill_ids] ||=[]
    if @project_request.save
      flash.now[:success] = 'Project request created.'
      redirect_to my_project_requests_url(current_employee)
    else
      flash[:params] = project_request_params
      redirect_to new_project_request_url(@project_request), alert: 'Please complete entire form.'
    end
  end

  def update
    @project_request = ProjectRequest.find(params[:id])
    params[:project_request][:skill_ids] ||=[]
    if @project_request.update(project_request_params)
      redirect_to my_project_requests_url(current_employee), notice: 'Project request was successfully updated.'
    else
      flash[:params] = project_request_params
      redirect_to edit_project_request_url(@project_request), alert: 'Please complete entire form.'
    end
  end

  def destroy
    @project_request = ProjectRequest.find(params[:id])
    @project_request.destroy
    redirect_to my_project_requests_url(current_employee), notice: 'Project request was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
  
    # Confirms a logged-in employee.
    def logged_in_employee
      unless logged_in?
        store_location
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def project_request_params
      params.require(:project_request).permit(:project_id, :description, :employee_id, :start_date, :end_date, :filled, :skill_ids => [])
    end
end
