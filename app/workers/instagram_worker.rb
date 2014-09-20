class InstagramWorker
	include Sidekiq::Worker

	def perform(loc_id, iter_count = 3)
    client = Instagram.client(client_secret: ENV['instagram_client_secret'], client_id: ENV['instagram_client_id'])
    loc = Location.find(loc_id)
    created_time = Time.now
    iter_count.times do
      client.location_recent_media(loc.insta_id, {count: 100,max_timestamp: created_time}).each do |media|
        loc.grams.create(
          body: media.caption ? media.caption.text : '',
          likes: media.likes.count,
          insta_id: media.id
          )
        created_time = media.created_time
      end
    end
  end
end
