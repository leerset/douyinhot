class CategorySerializer < ActiveModel::Serializer
  attributes :category_number, :category_name, :group_name, :image_url, :reference_standard

  def group_name
    object.group.group_name
  end

  def image_url
    Qiniu::Public.download_url(object.image_url) if object.image_url.present?
  end

  def reference_standard
    object.standard
  end
end
