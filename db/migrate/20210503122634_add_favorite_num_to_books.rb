class AddFavoriteNumToBooks < ActiveRecord::Migration[5.2]
  def change
    add_column :books, :favorite_num, :integer, null: false, default: 0
  end
end
