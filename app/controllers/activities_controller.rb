class ActivitiesController < ApplicationController
    
  def index
      @unapproved_activities = Activity.where(approval_status: 1)
      if_clicked = false
      @activities = Activity.all.order(:title)
      if params[:query].present? && params[:query].length > 2
        @activities = @activities.by_search_string(params[:query])
      end
      multi_day = Array.new
      i=0
      Activity.days.keys.each do |key_str|
        sym_day = key_str
        if params[sym_day] != nil && params[sym_day] != "0"
          if_clicked = true
          multi_day.append(@activities.filter_by_day(sym_day))
        end
      end
      @activities = multi_day.flatten if if_clicked == true
    end

    def unapproved
      @activities = Activity.where(approval_status: 1)
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

    def destroy #this should probably have permissions attached to it in some way eventually
      @activity = Activity.find(params[:id])
      @activity.destroy
      flash[:notice] = "activity removed"
      redirect_to activities_path
    end

    private
    def create_params
      params.require(:activity).permit(:title, :description, :spots, :chaperone, :approval_status, :day, :time_start, :time_end)
    end

end
