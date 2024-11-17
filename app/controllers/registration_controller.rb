class RegistrationsController < ApplicationController
    before_action :set_activity
  
    def new
      @registration = Registration.new
      @students = Student.all # Adjust based on logged-in parent or user role
    end
  
    def create
      @registration = @activity.registrations.build(registration_params)
  
      # Logic for determining status
      if @activity.enrolled_students.count < @activity.spots
        @registration.status = :Enrolled
      elsif @activity.waitlist_students.count < 10 # Optional cap for waitlist
        @registration.status = :Waitlist
      else
        @registration.status = :Denied
      end
  
      if @registration.save
        flash[:notice] = "Successfully registered with status: #{@registration.status}!"
        redirect_to activity_path(@activity)
      else
        flash[:alert] = @registration.errors.full_messages.to_sentence
        render :new
      end
    end
  
    private
  
    def set_activity
      @activity = Activity.find(params[:activity_id])
    end
  
    def registration_params
      params.require(:registration).permit(:student_id)
    end
  end
  