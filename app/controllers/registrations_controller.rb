class RegistrationsController < ApplicationController
  include ActionView::RecordIdentifier
  before_action :set_activity

  def new
    if current_user
      @registration = Registration.new
      @students = current_user.students
    else
      redirect_to root_path, alert: "You must be signed in to register."
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
      # flash[:notice] = "Successfully registered with status: #{@registration.status}!"
    end

    if @registration.save
      # flash[:notice] = "Successfully registered with status: #{@registration.status}!"
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to activity_path(@activity) }
      end
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
      flash[:notice] = 'Registration destroyed'
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
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace(dom_id(@activity, :current_enrollment),
                                                  partial: "activities/current_enrollment", locals: { activity: @activity })
      end
      format.html { redirect_to activity_path(@activity) }
    end
  end

  private

  def set_activity
    if params[:id]
      @registration = Registration.find(params[:id])
      @activity = @registration.activity
    elsif params[:activity_id]
      @activity = Activity.find(params[:activity_id])
    end
  end
  

  def registration_params
    params.require(:registration).permit(:student_id)
  end

end