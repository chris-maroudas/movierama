class RatingsController < ApplicationController

  before_filter :check_if_user_is_signed

  def create
    if current_user
      @rating = current_user.ratings.new(rating_params)
      if @rating.save
        redirect_to :back, notice: "Thank you for voting!"
      else
        redirect_to movies_url, notice: "There was an error!"
      end
    end
  end

  def update
    if current_user
      @rating = Rating.find(params[:id])
      if @rating.update_attributes(rating_params)
        redirect_to :back, notice: "Thank you for voting!"
      else
        redirect_to movies_url, notice: "There was an error!"
      end
    end
  end

  def destroy
    if current_user
      @rating = Rating.find(params[:id])
      if @rating.destroy
        redirect_to :back, notice: "Unvoted!"
      end
    end
  end

  private

    def rating_params
      params.require(:rating).permit(:movie_id, :positive)
    end

    def check_if_user_is_signed
      redirect_to signin_url, notice: "You must be logged in to do that" unless signed_in?
    end

end
