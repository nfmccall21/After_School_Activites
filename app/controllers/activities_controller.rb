class ActivitiesController < ApplicationController
    def index
      @activities = Activity.all.order(:title)
    end

    def show
      @activity = Activity.find(params[:id])
    end
end
