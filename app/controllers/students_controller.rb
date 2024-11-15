class StudentsController < ApplicationController

  before_action :authenticate_user!, only: %i[show index]
    
    def index
        @students = Student.all.order(:lastname)
        # puts current_user.role
        if current_user.role != "admin"
          @students = current_user.students 
        end
      end
  
      def show
        @student = Student.find(params[:id])
      end
  
      def new
        @student = Student.new()
      end
  
      def create
        @student = Student.new(create_params)
        if @student.save
          @student.users << current_user # CHECK IF THIS WORKS ONCE HAVE A PAGE FOR NEW STUDENT
          flash[:notice] = "#{@student.first} #{@student.last} added!"
          redirect_to students_path
        else
          flash[:alert] = "Cannot add student :("
          render :new, status: :unprocessable_content
        end
      end
  
      def destroy #this should probably have permissions attached to it in some way eventually
        @student = Activity.find(params[:id])
        @student.destroy
        flash[:notice] = "activity removed"
        redirect_to activities_path
      end
  
      private
      def create_params
        params.require(:activity).permit(:firstname, :lastname, :grade, :homeroom)
      end
  
  end
  