class InstagramWorker
	include Sidekiq::Worker

	def perform(loc_id)
	  client = Instagram.client(client_secret: ENV['instagram_client_secret'], client_id: ENV['instagram_client_id'])
    loc = Location.find(loc_id)
    client.location_recent_media(loc.insta_id, {count: 100}).each do |media|
      loc.grams.create(
        body: media.caption ? media.caption.text : '',
        likes: media.likes.count,
        insta_id: media.id
      )
    end
	end
end
