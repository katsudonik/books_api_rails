class Image < ApplicationRecord
  MAX_PICTURE_SIZE = 1_048_576 # NOTE; 1MB

  attr_accessor :picture_base64

  belongs_to :user, optional: true
  belongs_to :book, optional: true

  has_one_attached :picture
  # NOTE eager_load用に'picture_attachement'で関連付けを宣言
  has_one :attachment, class_name: "ActiveStorage::Attachment", foreign_key: "record_id", dependent: :destroy # rubocop:disable Rails/InverseOf
  has_one :picture_attachement, through: :attachment, class_name: "ActiveStorage::Blob", foreign_key: "blob_id", dependent: :destroy, source: :blob

  validate :validate_picture, if: -> { self.picture_base64.present? }
  after_validation :update_picture

private

  def validate_picture
    errors.add(:base, "picture_base64 must be less than or equal to 1 MiB.") unless (0..MAX_PICTURE_SIZE).cover?(picture_image.filesize)
  rescue Magick::ImageMagickError
    errors.add(:base, "picture_base64 is invalid")
  end

  # NOTE
  # picture_base64:nil|"" => not change image (picture_base64 not specified in params)
  # picture_base64:"[image data]" => upload image (insert or replace)
  def update_picture
    return if self.picture_base64.blank?
    self.picture.detach
    if self.picture_base64.present?
      self.picture.attach(ImageUploader.upload(picture_image))
    end
  rescue Magick::ImageMagickError
    errors.add(:base, "picture_base64 is invalid")
  end

  def picture_image
    @picture_image ||= ImageUploader.create_image_from_base64!(self.picture_base64)
  end
end
