class ProjectsController < ApplicationController
	before_action :require_login, except: :index

	# calls the user_ownership method for the :edit and :update commands to check to see if the user actually owns the project before they can see the edit page.
	before_action :user_ownership, only: [:edit, :update]

	def index
		@projects = Project.all
	end

	def show
		@project = Project.find(params[:id])
		@rewards = @project.rewards
	end

	def edit
		@project = Project.find(params[:id])
	end

	def update
		@project = Project.find(params[:id])

		if @project.update_attributes(project_params)
			redirect_to project_path(@project)
		else
			render :edit
		end
	end

	def new
		# you must be required to logged in to create a new projects.  You will be directed into the login page.
		require_login
		@project = Project.new
		@project.rewards.build
	end

	def create
		@project = Project.new(project_params)
		# @project.owner = "1" # Temporary until we have current_user

		if @project.save
			redirect_to projects_path
		else
			render :new
		end
	end

	private
	def project_params
		params.require(:project).permit(:name, :description, :start_date, :end_date, :funding_goal, rewards_attributes: [:title, :description, :amount, :id])
	end

	# this private method checks to see if the current user owns a project
	def user_ownership
		@project = Project.find(params[:id])
		redirect_to project_path(@project) unless current_user == @project.owner
	end
end