class ActivitiesController < ApplicationController
    def index
      @activity = Activity.all.order(:title)
    end
  
    def show
      @activity = Activity.find(params[:id])
    end
  end