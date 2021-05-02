class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :nickname

  has_one :image
end
