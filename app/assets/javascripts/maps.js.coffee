class @Map
  toRad: (v) ->
    v * Math.PI / 180

  constructor: (bootstrap) ->
    @data = JSON.parse(bootstrap)
    @a = null
    @b = null
    options =
      center: { lat: @data[2].latitude, lng: @data[2].longitude},
      zoom: 16
    
    @map = new google.maps.Map(document.getElementById('map-canvas'), options)
    @bootstrap()
    google.maps.event.addListener @map, 'rightclick', @plotRoute
  bootstrap: ->
    for i in @data
      m = @plot(i.latitude, i.longitude, i.name)
        
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
      rad = Math.sqrt((@a.B - @b.B)*(@a.B - @b.B) + (@a.k - @b.k)*(@a.k - @b.k))
      R = 6371
      φ1 = @toRad(@a.B)
      φ2 = @toRad(@a.k)
      Δφ = @toRad((@a.k-@b.k))
      Δλ = @toRad((@a.B-@b.B))

      aa = Math.sin(Δφ/2) * Math.sin(Δφ/2) +
              Math.cos(φ1) * Math.cos(φ2) *
              Math.sin(Δλ/2) * Math.sin(Δλ/2)
      c = 2 * Math.atan2(Math.sqrt(aa), Math.sqrt(1-aa))

      d = R * c * 1000 * 0.75

      $.get('/locations/search', {midpoint: mid, radius: d})
      .done (data)->
        console.log(data)
      @a = null
      @b = null