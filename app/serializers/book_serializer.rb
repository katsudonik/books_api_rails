class BookSerializer < ActiveModel::Serializer
  attributes :id, :title, :body
end
