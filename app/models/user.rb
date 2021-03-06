# frozen_string_literal: true

class User < ActiveRecord::Base
  acts_as_paranoid
  
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  include DeviseTokenAuth::Concerns::User

  has_one :image, dependent: :destroy
  accepts_nested_attributes_for :image
  validates_associated :image  
  has_many :books
  has_many :favorite_books
end
