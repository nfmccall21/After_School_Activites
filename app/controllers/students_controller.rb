class StudentsController < ApplicationController
    
      def index
        @students = Student.all.order(:lastname)
        if params[:query].present? && params[:query].length > 2
          @students = @students.by_search_string(params[:query])
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
  