class ActivitiesController < ApplicationController
    def index
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
          debugger
          multi_day.append(@activities.filter_by_day(sym_day))
        end
      end
      @activities = multi_day.flatten if if_clicked == true
    end

    def show
      @activity = Activity.find(params[:id])
    end
end
