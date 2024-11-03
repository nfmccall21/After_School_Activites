class ActivitiesController < ApplicationController
    def index
      @activities = Activity.all.order(:title)
      if params[:query].present? && params[:query].length > 2
        @activities = @activities.by_search_string(params[:query])
      end
      if params[:days].present? && params[:days] != nil
        @activities = @activities.filter_by_day
      end
    end

    def show
      @activity = Activity.find(params[:id])
    end
end
