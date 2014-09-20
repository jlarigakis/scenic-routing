class LocationWorker
  include Sidekiq::Worker

  def perform(long, lat, rad)
    client = Instagram.client(client_secret: ENV['instagram_client_secret'], client_id: ENV['instagram_client_id'])
    client.location_search(long,lat, {count: 100, distance: rad}).each do |loc|
      l = Location.create(
        name: loc.name, 
        longlat: Location.rgeo_factory_for_column(:longlat).point(loc.longitude, loc.latitude),
        insta_id: loc.id)
      InstagramWorker.perform_async(l.id) if l.persisted?
    end
  end
end