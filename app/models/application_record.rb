class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def encode(string)
    num = rand(0x00..0xFF)
    arr = string.split('')
    num_1 = (num + 0x32) & 0xFF
    num_arr = arr.map{ |a| (a.ord ^ num) & 0xFF}
    num_arr.unshift(num_1)
    checksum = ~(num_arr.sum & 0xFF) & 0xFF
    num_arr.push(checksum)
    Base64.encode64(num_arr.map(&:chr).join)
  end

  def decode(string = nil)
    string ||= self.id_code
    return if string.nil?
    arr = Base64.decode64(string).split('').map(&:ord)
    checksum = arr.pop
    return '校验错误' if ~(arr.sum & 0xFF) & 0xFF != checksum
    num = (arr.shift - 0x32) & 0xFF
    arr.map{ |a| ((a ^ num) & 0xFF).chr }.join
  end
end
