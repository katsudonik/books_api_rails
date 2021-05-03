class FavoriteBook < ApplicationRecord
  belongs_to :book
  belongs_to :user

  after_save -> { self.book.update_favorite_num }
end
