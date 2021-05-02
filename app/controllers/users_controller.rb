class UsersController < ApplicationController
  before_action :authenticate_user!

  def index
    users = User.all
    render(
      json: users,
      root: 'users', 
      adapter: :json
    )
  end

  def show
    render json: User.find(params[:id])
  end

  def update
    ActiveRecord::Base.transaction do
      current_user.image&.destroy! if params[:destroy_image]
      current_user.update!(user_params)
    end
    render json: current_user.reload
  end

private

  def user_params
    params.permit(:name, :nickname, image_attributes: [:picture_base64])
  end
end
