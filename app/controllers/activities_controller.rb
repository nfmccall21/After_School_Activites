class ActivitiesController < ApplicationController
    def index
      @activities = Activity.all.order(:title)
      if params[:query].present? && params[:query].length > 2
        @activities = @activities.by_search_string(params[:query])
      end
      if params[:opennow].present? && params[:opennow].to_i == 1
        @activities = @activities.open_now
      end
    end

    def show
      @activity = Activity.find(params[:id])
    end
end
