class InstagramWorker
	include Sidekiq::Worker

	def perform(min, max, lat, long, access_token)
	  client = Instagram.client(client_secret: ENV['instagram_client_secret'], client_id: ENV['instagram_client_id'])
    client.media_search(min, max, lat, long).each do |media|
    	Gram.create(
    		lonlat: media_item.location,
    		body: 	media_item.caption,
    		likes: 	media_item.likes
      )
    end
	end
end
