class @Map
  constructor: (bootstrap) ->
    @data = JSON.parse(bootstrap)
    @a = null
    @b = null
    options =
      center: { lat: @data[2].latitude, lng: @data[2].longitude},
      zoom: 16
    
    @map = new google.maps.Map(document.getElementById('map-canvas'), options)
    @bootstrap()

  bootstrap: ->
    for i in @data
      m = @plot(i.latitude, i.longitude, i.name)
      google.maps.event.addListener m, 'click', @plotRoute
        
  plot: (lat, long, name) ->
    marker = new google.maps.Marker(
      position: new google.maps.LatLng(lat,long),
      map: @map,
      title: name
    )
  plotRoute: (e) =>
    unless @a
      @a = e.latLng
    else
      @b = e.latLng
      mid = {longitude: (@a.B + @b.B)/2, latitude: (@a.k + @b.k)/2}
      console.log mid
