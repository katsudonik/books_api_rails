class BooksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_book, only: [:update, :destroy]

  def index
    render json: Book.all
  end

  def show
    render json: Book.find(params[:id])
  end

  def create
    render json: current_user.books.create!(book_params), status: :created
  end

  def update
    @book.update!(book_params)
    render json: @book
  end

  def destroy
    @book.destroy!
  end

  private
    def set_book
      @book = current_user.books.find(params[:id])
    end

    def book_params
      params.permit(:title, :body)
    end
end
