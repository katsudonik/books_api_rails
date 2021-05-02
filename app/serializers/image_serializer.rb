class ImageSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attributes :picture_url
  
  def picture_url
    if object.picture.attached?
      Rails.application.config.active_storage.service == :local ? url_for(object.picture) : "#{ Rails.application.config.app[:aws][:return_url] }/#{ object.picture.attachment.blob.key }"
    end
  rescue ArgumentError => e
    # NOTE: URL形式で文字列が生成出来なかった時、通知を送る。
    Rails.logger.warn(e)
    ""
  end
end
