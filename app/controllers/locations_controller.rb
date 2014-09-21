class LocationsController < ApplicationController
  respond_to :json, :html

  def index
    @locations = Location.all.shuffle.first(500)
    respond_with @locations
  end

end
