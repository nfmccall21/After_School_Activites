class RegistrationsController < ApplicationController
    before_action :set_activity
    #before_action :ensure_parent, only: [:new, :create]
  
    def new
      Rails.logger.debug "Current User: #{current_user.inspect}"
      
      if current_user && current_user.role == "parent"
        @registration = Registration.new
        @students = current_user.students
      else
        redirect_to root_path, alert: "You are not authorized to register students."
      end
    end
  
    def create
      @registration = @activity.registrations.build(registration_params)

      if @activity.enrolled_students.count < @activity.spots
        @registration.status = :Enrolled
      elsif @activity.waitlist_students.count < 35 # I can't rmember what the cap actually is
        @registration.status = :Waitlist
      else
        @registration.status = :Denied
      end
  
      if @registration.save
        flash[:notice] = "Successfully registered with status: #{@registration.status}!"
        redirect_to activity_path(@activity)
      else
        flash[:alert] = "There was an error with your registration."
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

    def ensure_parent
      unless current_user&.role == 'parent'
        flash[:alert] = "You are not authorized to register for activities."
        redirect_to root_path # Or another appropriate path
      end
    end

  end
  