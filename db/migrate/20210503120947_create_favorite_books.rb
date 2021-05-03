class CreateFavoriteBooks < ActiveRecord::Migration[5.2]
  def change
    create_table :favorite_books do |t|
      t.references :book, foreign_key: true
      t.references :user, foreign_key: true
      t.datetime :deleted_at

      t.timestamps
    end
    add_index :favorite_books, :deleted_at
  end
end
