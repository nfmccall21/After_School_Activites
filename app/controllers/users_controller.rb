class UsersController < ApplicationController
  before_action :verify_admin, only: %i[moderate make_admin make_teacher make_parent]

  def moderate
    @users = User.all
  end

  def make_admin
    @user = User.find(params[:id])
    @user.update(role: :admin)
  end

  def make_teacher
    @user = User.find(params[:id])
    @user.update(role: :teacher)
  end

  def make_parent
    @user = User.find(params[:id])
    @user.update(role: :parent)
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
