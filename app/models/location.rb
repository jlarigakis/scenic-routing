class Location < ActiveRecord::Base
  has_many :grams

  validates :insta_id, uniqueness: true
  
  set_rgeo_factory_for_column(:longlat, RGeo::Geographic.spherical_factory(:srid => 4326))
end
