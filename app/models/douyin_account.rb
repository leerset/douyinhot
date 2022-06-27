class DouyinAccount < ApplicationRecord
   has_many :videos

   def last_refresh_time
     last_video = self.videos.order(updated_at: :desc).first
     return last_video.updated_at if last_video
     self.updated_at
   end

   def recent_videos
     self.videos.order(release_time: :desc).last(20).map(&:number)
   end

   def string_to_count(str)
     if str =~ /^([0-9.]+)w$/
       ($1.to_f * 10000).to_i
     else
       str.to_i
     end
   end

   # video = {url: url, name: name, like: 0, comment: 0, attention: 0, release: 0}
   def update_videos(videos)
     videos.each do |data|
       video = Video.find_or_create_by_url(data.url)
       video.update(
         name: data.name,
         number: data.url.gsub(/.*\//,''),
         like: string_to_count(data.like),
         comment: string_to_count(data.comment),
         attention: string_to_count(data.attention),
         release: DateTime.parse(data.release.sub(/.*：/,'')),
       )
     end
   end
end
