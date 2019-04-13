class App < ApplicationRecord
  enum status_types: ['可用', '禁用']
end
