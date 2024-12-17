class RegistrationsController < ApplicationController
  before_action :set_activity

  def new
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

  def destroy
    @registration = Registration.find(params[:id])
    @registration.destroy
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.remove(@registration) }
      format.html do
        redirect_to student_path(@registration.student_id)
      end
    end
  end

  def decline
    @registration = Registration.find(params[:id])
    @activity = @registration.activity
  
    @registration.status = 'Denied'
    
    if @registration.save
      flash[:notice] = "Registration has been declined."
    else
      @registration.destroy
      flash[:notice] = 'This activity is full'
    end
  
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.remove(@registration) }
      format.html do
        redirect_to student_path(@registration.student_id)

      end
    end
  end  

  def approve
    @registration = Registration.find(params[:id])
    @activity = @registration.activity
  
    existing_enrollment = @activity.registrations.find_by(student_id: @registration.student.id, status: :Enrolled)
  
    if existing_enrollment
      flash[:notice] = 'Student is already enrolled in this activity.'
    elsif @activity.enrolled_students.count >= @activity.spots
      flash[:notice] = 'This activity is full'
    else
      @registration.update!(status: :Enrolled)
      flash[:notice] = 'Registration approved successfully.'
    end 
  
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.remove(@registration) }
      format.html { redirect_to activity_path(@activity) }
    end
  end

  private

  def set_activity
    @registration = Registration.find(params[:id])
    @activity = @registration.activity
  end

  def registration_params
    params.require(:registration).permit(:student_id)
  end

end