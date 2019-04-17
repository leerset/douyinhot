class ResolutionRequest < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :app, primary_key: :app_id, foreign_key: :app_id, optional: true
  belongs_to :category, primary_key: :category_number, foreign_key: :category_number, optional: true

  before_save { self.sample_time = Time.now }

  enum exceptions: %w{
    解析值
    接口关闭
    用户停止服务
    用户无效
    品类无效
    GPS无效
    硬件编号无效
    设备无效
    采集值无效
    采集值为零
    检测公式异常
    采集值长度不对}

  def sample_x
    return '格式错误' unless sample_value.to_s =~ /^[0-9A-F]{8}$/i
    hex_string = sample_value.scan(/[0-9A-F]{2}/i).reverse.join
    hex_string.to_i(16)
  end

end
