class Category < ApplicationRecord
  belongs_to :group
  has_one :category_formula, primary_key: :category_number, foreign_key: :category_number
  has_many :resolution_requests, primary_key: :category_number, foreign_key: :category_number

  before_create :set_group_index

  def self.last_updated_at
    all.map(&:updated_at).max
  end

  def set_group_index
    last_category = group.categories.order(group_index: :asc).last
    self.group_index = last_category.present? ? last_category.group_index + 1 : 1
  end

  def index_up
    previous_index = self.group_index
    up_category = group.categories.where(" `group_index` < ? ", self.group_index).order(group_index: :asc).last
    if up_category
      up_index = up_category.group_index
      up_category.update(group_index: previous_index)
      self.update(group_index: up_index)
    end
    self.group_index_previously_changed?
  end

  def index_down
    previous_index = self.group_index
    down_category = group.categories.where(" `group_index` > ? ", self.group_index).order(group_index: :asc).first
    if down_category
      down_index = down_category.group_index
      down_category.update(group_index: previous_index)
      self.update(group_index: down_index)
    end
    self.group_index_previously_changed?
  end

  def upload_picture(picture_filepath)
    picture_qnkey = generate_picture_qnkey
    Qiniu::Public.upload(picture_qnkey, picture_filepath)
    self.update(image_url: picture_qnkey)
  end

  def generate_picture_qnkey
    begin
      picture_qnkey = "CT#{SecureRandom.hex(12)}"
    end while Category.where(image_url: picture_qnkey).present?
    picture_qnkey
  end

  def category_picture_filepath
    nil
  end

end
