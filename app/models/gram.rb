class Gram < ActiveRecord::Base
  set_rgeo_factory_for_column(:lonlat, RGeo::Geographic.spherical_factory(:srid => 4326))
end
