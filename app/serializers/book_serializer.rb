class BookSerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :favorite_num

  has_one :image
end
