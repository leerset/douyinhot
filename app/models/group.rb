class Group < ApplicationRecord
  belongs_to :group, optional: true
  has_many   :groups
  has_many   :categories
end
