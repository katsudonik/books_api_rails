class FavoriteBooksController < ApplicationController
  before_action :authenticate_user!

  def index
    render json: { favorite_books: current_user.favorite_books.pluck(:book_id) }
  end

  def create
    render json: current_user.favorite_books.create!(book_id: params[:book_id]), status: :created
  end

  def destroy
    current_user.favorite_books.find_by!(book_id: params[:book_id]).destroy!
  end
end
