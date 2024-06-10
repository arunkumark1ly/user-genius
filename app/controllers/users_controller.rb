# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :set_user, only: [:destroy]

  def index
    base_query = if params[:search]
                   User.where("name ->> 'first' ILIKE :search OR name ->> 'last' ILIKE :search
                               OR CAST(age AS TEXT) ILIKE :search
                               OR gender ILIKE :search",
                              search: "%#{params[:search]}%")
                 else
                   User.all
                 end

    @users = base_query.page(params[:page]).per(25)
    @total_users = base_query.count
  end

  def destroy
    @user.destroy
    redirect_to users_url, notice: 'User was successfully destroyed.'
  end

  def fetch_users
    FetchUsersJob.perform_async
    redirect_to users_path, notice: 'Fetch users job has been enqueued.'
  end

  private

  def set_user
    @user = User.find(params[:id])
  end
end
