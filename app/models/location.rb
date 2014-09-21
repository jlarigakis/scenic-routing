class Location < ActiveRecord::Base
  has_many :grams

  validates :insta_id, uniqueness: true
  
  set_rgeo_factory_for_column(:longlat, RGeo::Geographic.spherical_factory(:srid => 4326))

  def as_json(opts={})
    {latitude: longlat.latitude, longitude: longlat.longitude, name: name}
  end
end
