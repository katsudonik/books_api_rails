class Book < ApplicationRecord
  acts_as_paranoid
  
  belongs_to :user
  has_many :favorite_books
  has_one :image, dependent: :destroy
  accepts_nested_attributes_for :image
  validates_associated :image

  validates :title, presence: true, length: { maximum: 100 } 
  validates :body, presence: true, length: { maximum: 255 }

  def update_favorite_num
    self.favorite_num = self.favorite_books.count
    self.save!
  end
end
