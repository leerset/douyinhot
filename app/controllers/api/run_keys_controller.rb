require 'cgi'

class Api::RunKeysController < Api::Base
  protect_from_forgery :except => :update_kaogu_status

  def run_key
    rk = DouyinAccount.all.sort{|a,b| a.last_refresh_time <=> b.last_refresh_time}.last
    if rk
      render json: {id: rk.id, url: rk.url, videos: rk.recent_videos}
    else
      render json: {err: 'no valid run keys for crawling'}
    end
  end

  def kaogu_run_key
    render json: {id: 1, url: "https://www.kaogujia.com/help", videos: []}
  end

  def update_runkey_status
    run_key = DouyinAccount.find(params[:run_key_id])
    run_key.update_attributes updated_at: DateTime.now
    run_key.update_videos(params[:videos])
    render json: { success: 'ok' }
  end

  def zh_unicode_utf8(string)
    string.gsub('%u','\u').gsub(/\\u\w{4}/) do |s|
      str = s.sub(/\\u/, "").hex.to_s(2)
      if str.length < 8
        CGI.unescape(str.to_i(2).to_s(16).insert(0, "%"))
      else
        arr = str.reverse.scan(/\w{0,6}/).reverse.select{|a| a != ""}.map{|b| b.reverse}
        hex = lambda do |s|
          (arr.first == s ? "1" * arr.length + "0" * (8 - arr.length - s.length) + s : "10" + s).to_i(2).to_s(16).insert(0, "%")
        end
        CGI.unescape(arr.map(&hex).join)
      end
    end
  end

  def update_kaogu_status
    KaoguProduction.update_all(rank: nil)
    productions = params[:productions].map do |prod|
      kaogu_production = KaoguProduction.find_or_create_by(link: prod["link"])
      kaogu_production.update(
        rank: prod["rank"],
        name: zh_unicode_utf8(prod["name"]),
        imageUrl: prod["imageUrl"],
        nowPrice: prod["nowPrice"],
        oldPrice: prod["oldPrice"],
        commissionRate: prod["commissionRate"],
        videSales: prod["videSales"],
        views: prod["views"],
        videoCount: prod["videoCount"],
      )
      kaogu_production.set_sales
    end
    render json: { success: 'ok' }
  end

end
