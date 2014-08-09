class RatingsController < ApplicationController
  before_filter :authenticate_user!, only: [:destroy, :update]
  before_action :set_rating, only: [:show, :update, :destroy]

  # GET /ratings
  # GET /ratings.json
  def index
    @ratings = Rating.order(created_at: :desc)
    render json: @ratings
  end

  # GET /ratings/1
  # GET /ratings/1.json
  def show
    render json: @rating
  end

  # POST /ratings
  # POST /ratings.json
  def create
    @rating = Rating.new(rating_params)
    if @rating.save
      render json: @rating, status: :created, location: @rating
    else
      render json: @rating.errors.full_messages, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /ratings/1
  # PATCH/PUT /ratings/1.json
  def update
    if @rating.update(rating_params)
      head :no_content
    else
      render json: @rating.errors, status: :unprocessable_entity
    end
  end

  # DELETE /ratings/1
  # DELETE /ratings/1.json
  def destroy
    @rating.destroy
    head :no_content
  end

  private

  def set_rating
    @rating = Rating.find(params[:id])
  end

  def rating_params
    params.require(:rating).permit(:dimension, :comment, :rater, :stars)
  end
end
