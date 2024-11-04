class ActivitiesController < ApplicationController
    def index
      @activities = Activity.all.order(:title)
      @activities = @activities.where(:approval_status = false) # Put this in and set to false...may be incorrect
    end

    def show
      @activity = Activity.find(params[:id])
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

    private
    def create_params
      params.require(:activity).permit(:title, :description, :spots, :chaperone, :approval_status, :day, :time_start, :time_end)
    end

    def destroy #this should probably have permissions attached to it in some way eventually
      @activity = Activity.find(params[:id])
      @activity.destroy
      flash[:notice] = "activity removed"
      redirect_to activities_path
    end
    
    def unapproved
      @unapproved_activites = Activity.where(approved: false)
    end

end
