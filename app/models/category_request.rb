class CategoryRequest < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :app, primary_key: :app_id, foreign_key: :app_id, optional: true

  before_save { self.request_time = Time.now }

end
