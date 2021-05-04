class AddIndexToFavoriteBook < ActiveRecord::Migration[5.2]
  def change
    add_index  :favorite_books, [:book_id, :user_id, :deleted_at], unique: true
  end
end
