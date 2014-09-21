class @Map
  toRad: (v) ->
    v * Math.PI / 180

  constructor: (bootstrap) ->
    @data = JSON.parse(bootstrap)
    @a = null
    @b = null
    @marker = null
    options =
      center: { lat: @data[2].latitude, lng: @data[2].longitude},
      zoom: 16
    
    @map = new google.maps.Map(document.getElementById('map-canvas'), options)
    # @bootstrap()
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
  distance: (a, b) ->
    R = 6371
    φ1 = @toRad(a.B)
    φ2 = @toRad(a.k)
    Δφ = @toRad((a.k-b.k))
    Δλ = @toRad((a.B-b.B))

    aa = Math.sin(Δφ/2) * Math.sin(Δφ/2) +
            Math.cos(φ1) * Math.cos(φ2) *
            Math.sin(Δλ/2) * Math.sin(Δλ/2)
    c = 2 * Math.atan2(Math.sqrt(aa), Math.sqrt(1-aa))

    R * c * 1000

  plotRoute: (e) =>

    unless @a
      @a = e.latLng
      @marker = @plot e.latLng.k, e.latLng.B, 'Head'
    else
      @b = e.latLng
      # @markers.push @plot e.latLng.k, e.latLng.B, 'Tail'
      mid = {longitude: (@a.B + @b.B)/2, latitude: (@a.k + @b.k)/2}
      rad = Math.sqrt((@a.B - @b.B)*(@a.B - @b.B) + (@a.k - @b.k)*(@a.k - @b.k))
      d = @distance(@a,@b) * 0.75

      $.get('/locations/search', {midpoint: mid, radius: d})
      .done (data) =>
        @findPath(data)
        # @plot data.latitude, data.longitude, data.name
    

  findPath: (waypoint) ->
    wp = []
    if waypoint
      wp = [{location: new google.maps.LatLng(waypoint.latitude, waypoint.longitude), stopover: true }] 
    req = {
      origin: @a,
      destination: @b,
      waypoints: wp,
      optimizeWaypoints: true,
      travelMode: google.maps.TravelMode.WALKING
    }
    console.log @a
    display = new google.maps.DirectionsRenderer()
    display.setMap(@map)
    service = new google.maps.DirectionsService()
    service.route req, (resp, status) =>
      if status == google.maps.DirectionsStatus.OK
        @marker.setMap(null)
        display.setDirections(resp)
