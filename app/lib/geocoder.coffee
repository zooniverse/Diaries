$ = require 'jqueryify'
require './jstorage.js'
store = $.jStorage

YQL = require './yql'

class Geocoder
  
  localCache = false
  
  constructor: (@service = 'geonames') ->

  geocode: (placename) =>
    
    promise = new $.Deferred
    
    return promise unless placename
    
    cache = store.get placename if @localCache
    
    if cache?
      [lat, long, name]  = cache
      promise.resolve lat,long,name
    else
      promise = @call_webservice placename
    
      
    promise
    
  call_webservice: (placename) =>
    
    queries =
      geoplanet: "select * from geo.placefinder where text='#{escape placename}' and countrycode in ('BE','FR','GB') limit 1"
      geonames: "select * from xml where url='http://api.geonames.org/search?name=#{escape placename}&featureClass=P&isNameRequired=true&country=BE&country=GB&country=FR&maxRows=3&username=zooniverse'"
    
    query = queries[@service]
    
    promise = new $.Deferred
    
    process_request = (response)=>
      results = response.query.results
      
      lat = null
      long = null
      name = ''
    
      promise.resolve lat, long, name unless results?
    
      switch @service
        when 'geonames'
          places = results.geonames.geoname
          console.log places
          if places?
            place = places[0]
            lat = parseFloat place.lat
            long = parseFloat place.lng
            name = place.toponymName
        when 'geoplanet'
          places = results.Result
          if places?
            place = places[0]
            lat = parseFloat place.latitude
            long = parseFloat place.longitude
            name = if place.neighborhood? then place.neighborhood else place.city
    
      store.set placename, [lat, long, name] if @localCache
      promise.resolve lat,long,name
    
    yql = new YQL query
    yql.signed_request().done process_request
      
      
    promise
    
module.exports = Geocoder