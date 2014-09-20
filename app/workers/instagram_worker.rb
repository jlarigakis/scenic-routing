class InstagramWorker
	include Sidekiq::Worker

	def perform(lat, long, min, max)
	  client = Instagram.client(client_secret: ENV['instagram_client_secret'], client_id: ENV['instagram_client_id'])
    client.media_search(lat, long, {min_timestamp: min, max_timestamp: max}).each do |media|
      pos = media.location
    	Gram.create(
    		lonlat: Gram.rgeo_factory_for_column(:lonlat).point(pos.longitude, pos.latitude),
    		body: 	media.caption ? media.caption.text : '',
    		likes: 	media.likes.size
      )
    end
	end
end
