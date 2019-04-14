class ResolutionRequest < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :app, primary_key: :app_id, foreign_key: :app_id, optional: true
  belongs_to :category, primary_key: :category_number, foreign_key: :category_number, optional: true

  before_save { self.sample_time = Time.now }
end
