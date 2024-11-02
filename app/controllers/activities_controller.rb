class ActivitiesController < ApplicationController
    def index
      @activities = Activity.all.order(:title)
    end

    def show
      @activity = Activity.find(params[:id])
    end

    def destroy #this should probably have permissions attached to it in some way eventually
      @activity = Activity.find(params[:id])
      @activity.destroy
      flash[:notice] = "activity removed"
      redirect_to activities_path
    end
end
