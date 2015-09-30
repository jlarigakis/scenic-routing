class LocationsController < ApplicationController
  respond_to :json, :html

  def index
    @locations = Location.all.shuffle.first(500)
    respond_with @locations
  end

  def search
    puts "python app/classifier/getPred.py #{params[:midpoint][:latitude]} #{params[:midpoint][:longitude]} #{params[:radius]}"
    id = `python app/classifier/getPred.py #{params[:midpoint][:latitude]} #{params[:midpoint][:longitude]} #{params[:radius]}`
    @loc = Location.find_by(id:id)
    respond_with @loc
  end
end
