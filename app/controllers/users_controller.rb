class UsersController < ApplicationController
  before_action :verify_admin, only: %i[moderate make_admin make_teacher make_parent]

  def moderate
    @users = User.all.order(:email)
    @current_user = current_user
    if params[:query].present? && params[:query].length > 2
      @users = @users.by_search_string(params[:query])
    end
    if params[:query].present?
      @querystr = "Current search: #{params[:query]}"
    else
      @querystr = "Search Users"
    end
  end

  def make_admin
    @user = User.find(params[:id])
    @user.update(role: :admin)
    respond_to do |format|
      format.turbo_stream
    end
  end

  def make_teacher
    @user = User.find(params[:id])
    @user.update(role: :teacher)
    respond_to do |format|
      format.turbo_stream
    end
  end

  def make_parent
    @user = User.find(params[:id])
    @user.update(role: :parent)
    respond_to do |format|
      format.turbo_stream
    end
  end


  private
  def verify_admin
    if !current_user
      authenticate_user!
    elsif !current_user.admin?
      flash[:alert] = "Only administrators allowed"
      redirect_to activities_path
    end
  end
end
