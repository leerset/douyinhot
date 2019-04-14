class ApiManage < ApplicationRecord
  enum manage_types: ['正常使用', '关闭接口']
end
