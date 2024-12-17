class ActivitiesController < ApplicationController
  
  before_action :authenticate_user!, only: %i[index show register]
  before_action :set_activity, only: [:register, :accept, :decline]

  def index
    if_clicked = false
    @activities = Activity.all.order(:title)
    if params[:query].present? && params[:query].length > 2
      @activities = @activities.by_search_string(params[:query])
    end
    selected_days = Activity.days.keys.select { |day| params[day] == '1' }
    if selected_days.any?
      @activities = @activities.where(day: selected_days)
    end

    # I'm not sure if there is a less repeditive way to do this but I'm following the way we did it in lab
    if params[:Monday].present? && params[:Monday] == '1'
     @filtermonday = true
    end
    if params[:Tuesday].present? && params[:Tuesday] == '1'
      @filtertuesday = true
    end
    if params[:Wednesday].present? && params[:Wednesday] == '1'
      @filterwednesday = true
    end
    if params[:Thursday].present? && params[:Thursday] == '1'
      @filterthursday = true
    end
    if params[:Friday].present? && params[:Friday] == '1'
      @filterfriday = true
    end



  end

  def show
    @activity = Activity.find(params[:id]) 
    @students = Student.all
    @registrations = @activity.registrations.includes(:student)
  end

  def new
    @activity = Activity.new()
  end

  def create
    @activity = Activity.new(create_params)
    @activity.approval_status = 1
    if @activity.save
      flash[:notice] = "Activity #{@activity.title} proposed!"
      redirect_to activities_path
    else
      flash[:alert] = "Cannot propose activity :("
      render :new, status: :unprocessable_content
    end
  end

  def destroy #this should probably have permissions attached to it in some way eventually
    @activity = Activity.find(params[:id])
    @activity.destroy
    flash[:notice] = "activity removed"
    redirect_to activities_path
  end

  def edit
    @activity  = Activity.find(params[:id])
  end

  def update
    @activity = Activity.find(params[:id])
    if @activity.update(create_params)
      redirect_to activity_path(@activity), notice: 'activity details updated successfully'
    else
      flash[:alert] = 'Activity could not be edited'
      render :edit, status: :unprocessable_content
    end
  end

  def unapproved
    @unapproved_activities = Activity.where(approval_status: 'Pending') #enum query is 0, 1, 2 for a, p, d
  end

  def accept
    @activity = Activity.find(params[:id])
    if @activity.approval_status == 'Pending'
      @activity.update(approval_status: 'Approved')
      redirect_to activities_path, notice: 'Activity was successfully approved.'
    else
      redirect_to activities_path, alert: 'Activity cannot be approved.'
    end
  end

  def decline
    @activity = Activity.find(params[:id])
    if @activity.approval_status == 'Pending'
      @activity.update(approval_status: 'Denied')
      redirect_to activities_path, notice: 'Activity was successfully denied.'
    else
      redirect_to activities_path, alert: 'Activity cannot be denied.'
    end
  end

  def register
    @student = Student.find(params[:student_id])

    existing_registration = @activity.registrations.find_by(student: @student)
    if existing_registration
      flash[:alert] = "#{@student.firstname} #{@student.lastname} is already registered for this activity."
      redirect_to activity_path(@activity) and return
    end

    @registration = @activity.registrations.new(student: @student, status: :Waitlist)

    if @registration.save
      flash[:notice] = "#{@student.firstname} #{@student.lastname} has been successfully registered for #{@activity.title}. Registration status is 'Pending'."
    else
      flash[:alert] = "There was an issue with registering #{@student.firstname} #{@student.lastname} for this activity."
    end

    redirect_to activity_path(@activity)
  end

  private
  def create_params
    params.require(:activity).permit(:title, :description, :spots, :chaperone, :approval_status, :day, :time_start, :time_end)
  end

  def set_activity
    @activity = Activity.find(params[:id])
  end

end
