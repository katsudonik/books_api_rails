module ImageUploader
  GIF_REQEXP = /\AGIF8[79]a
               .*?
               \x3b\Z
               /mnx

  PNG_REGEXP = /
               \A\x89PNG\r\n\x1A\n
               \x00\x00\x00\x0D IHDR .{13} .{4}
               .*?
               \x00\x00\x00\x00 IEND \xAE\x42\x60\x82\Z
               /mnx

  JPEG_REGEXP = /\A\xFF\xD8\xFF
               .*?
               \xFF\xD9\Z
               /mnx

  class << self
    def create_image_from_base64!(base64)
      return nil if base64.blank?
      image = Base64.decode64(base64)
      raise Magick::ImageMagickError unless (image.match(GIF_REQEXP) || image.match(PNG_REGEXP) || image.match(JPEG_REGEXP))
      Magick::Image.from_blob(image).first
    end

    def upload(img)
      blob = ActiveStorage::Blob.new.tap do |blob|
        blob.filename = SecureRandom.hex(64)
        blob.content_type = img.mime_type
        blob.byte_size = img.filesize
      end
      Tempfile.create do |f|
        f.binmode
        f.write img.to_blob
        # NOTE: ActiveStorage 側でチェックサムを生成時、filereadの情報を扱う。
        # その時、先頭に巻き戻して置かないと正常にチェックサムが生成されないための処理。
        f.rewind
        blob&.upload f
      end
      blob
    end
  end
end
