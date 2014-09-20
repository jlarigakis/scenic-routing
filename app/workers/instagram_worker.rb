class InstagramWorker
	include Sidekiq::Worker

	def perform(min, max, lat, long, access_token)
	  client = Instagram.client(access_token: access_token)
    client.media_search(min, max, lat, long).each do |media|
    	Instagram.new 
    		lonlat: media_item.location,
    		body: 	media_item.caption,
    		likes: 	media_item.likes
    end
	end
end