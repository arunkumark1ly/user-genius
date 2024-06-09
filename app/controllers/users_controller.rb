class UsersController < ApplicationController
  before_action :set_user, only: [:destroy]

  def index
    @users = if params[:search]
               User.where('name LIKE ?', "%#{params[:search]}%")
             else
               User.all
             end
  end

  def destroy
    @user.destroy
    redirect_to users_url, notice: 'User was successfully destroyed.'
  end

  private

  def set_user
    @user = User.find(params[:id])
  end
end