class ActivitiesController < ApplicationController
    def index
      @activities = Activity.all.order(:title)
      if params[:query].present? && params[:query].length > 2
        @activities = @activities.by_search_string(params[:query])
      end
      Activity.days.keys.each do |key_str|
        sym_day = key_str
        if params[sym_day] != nil && params[sym_day] != "0"
          debugger
          @activities = @activities.filter_by_day(sym_day)
        end
      end
    end

    def show
      @activity = Activity.find(params[:id])
    end
end
