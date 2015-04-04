class LocationsController < ApplicationController
  respond_to :json, :html

  require 'uri'
  require 'net/http'
  require 'json'

  def index
    @locations = Location.all.shuffle.first(500)
    respond_with @locations
  end

  def search
    api_params = {}
    api_params[:latitude] = params[:midpoint][:latitude]
    api_params[:longitude] = params[:midpoint][:longitude]
    api_params[:radius] = params[:radius]

    uri = URI.parse('http://localhost:5000')
    uri.query = URI.encode_www_form(api_params)
    res = Net::HTTP.get_response(uri)
    res_parsed = JSON.parse(res.body)

    top_loc = res_parsed[0]

    @loc = Location.find_by(id:top_loc["insta_id"])
    respond_with @loc
  end
end
