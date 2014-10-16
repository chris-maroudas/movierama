class MoviesController < ApplicationController

  before_action :set_movie, only: [:show, :edit, :update, :destroy]
  before_filter :check_if_user_is_signed, only: [:new, :create, :update, :destroy]

  def index
    @movies = Movie.all.includes(:user)
    @movies = params[:sort].present? ? @movies.custom_order(params[:by]) : @movies.custom_order("created_at")
  end

  def show
    @rating = Rating.find_or_initialize_by(user: current_user, movie: @movie)
  end

  def new
    @movie = Movie.new
  end

  def edit
  end

  def create
    @movie = current_user.movies.new(movie_params)
    if @movie.save
      redirect_to root_url, notice: 'Movie was successfully created.'
    else
      render :new
    end
  end

  def update
    if @movie.update(movie_params)
      redirect_to root_url, notice: 'Movie was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @movie.destroy
    redirect_to movies_url, notice: 'Movie was successfully destroyed.'
  end

  private
    def set_movie
      @movie = Movie.find(params[:id])
    end

    def movie_params
      params.require(:movie).permit(:title, :description, :published_at)
    end

    def check_if_user_is_signed
      redirect_to signin_url, notice: "You must be logged in to do that" unless signed_in?
    end

end
