class UsersController < ApplicationController
  before_action :set_user, only: [:destroy]

  def index
    @users =  if params[:search]
                User.where("name ->> 'first' ILIKE :search OR name ->> 'last' ILIKE :search 
                            OR CAST(age AS TEXT) ILIKE :search 
                            OR gender ILIKE :search", 
                            search: "%#{params[:search]}%")
              else
                User.all
              end
    @total_users = User.count
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