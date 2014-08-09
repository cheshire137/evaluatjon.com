class RepliesController < ApplicationController
  before_filter :authenticate_user_from_token!
  before_filter :authenticate_user!
  before_action :set_rating
  before_action :set_reply, only: [:show, :update, :destroy]

  # GET /ratings/1/replies
  # GET /ratings/1/replies.json
  def index
    @replies = Reply.order(created_at: :desc)
    render json: @replies.to_json(include: :user)
  end

  # GET /ratings/1/replies/1
  # GET /ratings/1/replies/1.json
  def show
    render json: @reply.to_json(include: :user)
  end

  # POST /ratings/1/replies
  # POST /ratings/1/replies.json
  def create
    @reply = @rating.replies.new(reply_params)
    @reply.user = current_user
    if @reply.save
      render json: @reply.to_json(include: :user), status: :created,
             location: [@rating, @reply]
    else
      render json: @reply.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /ratings/1/replies/1
  # PATCH/PUT /ratings/1/replies/1.json
  def update
    if @reply.update(reply_params)
      head :no_content
    else
      render json: @reply.errors, status: :unprocessable_entity
    end
  end

  # DELETE /ratings/1/replies/1
  # DELETE /ratings/1/replies/1.json
  def destroy
    @reply.destroy
    head :no_content
  end

  private

  def reply_params
    params.require(:reply).permit(:message)
  end

  def set_rating
    @rating = Rating.find(params[:rating_id])
  end

  def set_reply
    @reply = @rating.replies.find(params[:id])
  end
end
