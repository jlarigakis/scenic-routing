class LocationWorker
  include Sidekiq::Worker

  def perform(long, lat, depth = 3)
    client = Instagram.client(client_secret: ENV['instagram_client_secret'], client_id: ENV['instagram_client_id'])
    client.location_search(lat,long, {count: 100, distance: 5000}).each do |loc|
      l = Location.create(
        name: loc.name, 
        longlat: Location.rgeo_factory_for_column(:longlat).point(loc.longitude, loc.latitude),
        insta_id: loc.id)
      InstagramWorker.perform_async(l.id) if l.persisted?
      LocationWorker.perform_async(loc.longitude, loc.latitude, depth - 1) if depth > 0 && l.persisted?
    end
  end
end