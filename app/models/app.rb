class App < ApplicationRecord
  has_many :category_requests, primary_key: :app_id, foreign_key: :app_id
  has_many :resolution_requests, primary_key: :app_id, foreign_key: :app_id

  enum status_types: ['可用', '禁用']
end
