class KaoguProduction < ApplicationRecord
  def set_sales
    return unless sss.videSales && sss.nowPrice && sss.nowPrice =~ /^¥\d+/
    nowPrice = sss.nowPrice.sub('¥','').to_f
    videSales = if sss.videSales =~ /w$/
      sss.videSales.sub('w','').to_f * 10000
    else
      sss.videSales.to_f
    end
    sss.update(sales: nowPrice * videSales)
  end
end
