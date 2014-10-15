class UsersController < ApplicationController

  before_action :set_user, only: [:show, :edit, :movies]
  before_filter :check_if_user_is_signed, only: [:edit]

  def new
    @user = User.new
  end

  def show
    @user = User.find(params[:id])
  end

  def edit
    @user = User.find(params[:id])
  end

  def create
    @user = User.new(user_params)
    if @user.save
      sign_in @user # No email confirmation, therefore signin upon registration
      redirect_to root_url, notice: "User successfuly created."
    else
      render :new
    end
  end

  def movies
    @movies = @user.movies
    @movies = params[:sort].present? ? @movies.custom_order(params[:by]) : @movies.custom_order("created_at")
    render 'movies/index'
  end

  private

    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end

    def check_if_user_is_signed
      redirect_to signin_url, notice: "You must be logged in to do that" unless signed_in?
    end

end
