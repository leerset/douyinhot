class CategoryRequest < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :app, primary_key: :app_id, foreign_key: :app_id, optional: true

  before_save { self.request_time = Time.now }

  enum release_types: ['不用下发', '需要下发', '下发完成']
  enum exceptions: %w{
    正常，下发更新品类数据
    接口关闭
    用户停止服务
    用户无效
    时间戳相同
    未知5
    未知6
    设备无效
    未知8
    未知9}

end
