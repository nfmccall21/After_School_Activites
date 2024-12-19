class StudentsController < ApplicationController
  before_action :authenticate_user!, only: %i[show index]


    def index
      @students = Student.all.order(:lastname)
      if current_user.role == "parent"
        @students = current_user.students
      end
      if params[:query].present? && params[:query].length > 2
        @students = @students.by_search_string(params[:query])
      end
      if params[:query].present?
        @querystr = "Current search: #{params[:query]}"
      else
        @querystr = "Search Students"
      end
    end

    def show
      @student = Student.find(params[:id])
      if (current_user.role == "parent" && !current_user.students.include?(@student))
        flash[:alert] = "You do not have permission to view this student"
        redirect_to activities_path
      end
      @registrations = Registration.where(student_id: @student.id)
    end

    def new
      @student = Student.new()
    end

    def create
      @student = Student.new(create_params)
      if @student.save
        @student.users << current_user # CHECK IF THIS WORKS ONCE HAVE A PAGE FOR NEW STUDENT
        flash[:notice] = "#{@student.firstname} #{@student.lastname} added!"
        redirect_to students_path
      else
        flash[:alert] = "Cannot add student :("
        render :new, status: :unprocessable_content
      end
    end

    def destroy # this should probably have permissions attached to it in some way eventually
      @student = Student.find(params[:id])
      @student.registrations.each do |reg|
        reg.destroy
      end
      @student.destroy
      flash[:notice] = "Student removed"
      redirect_to students_path
    end

    private
    def create_params
      params.require(:student).permit(:firstname, :lastname, :grade, :homeroom)
    end
end
