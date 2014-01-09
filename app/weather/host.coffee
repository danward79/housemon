#Yahoo Weather Forecast Grabber
#Search by location.
#http://developer.yahoo.com/yql/console/
YQL = require('yql').exec
util = require('util')
EventEmitter = require('events').EventEmitter

class Weather  
  util.inherits(Weather, EventEmitter)
  constructor: (@location, @checkInterval) ->
    @woeid = @getWoeid @location
    start @checkInterval
    
  start = (checkInterval) ->
    @count = 0
    woeid = @woeid
    console.log woeid
    @interval = setInterval ( ->
      if woeid
        console.log 'got woeid'
        @getForecast woeid
        clearInterval @interval
      else if @count >= 10
        clearInterval @interval
        console.log woeid
      else @count < 10
        #console.log woeid
        #@count++ 
        #console.log woeid       
    ), 5000
    
  
  doQuery: (query, cb) ->
    new YQL(query, (response) ->
      if response.error
        console.log "Weather YQL Error: " + response.error.description
      else
        cb(response.query)
    )
    
  getWoeid: (location) ->
    @doQuery "select * from geo.placefinder where text='#{location}'", @setWoeid
    
  setWoeid: (res) =>
    @woeid = res.results.Result.woeid
    if not @woeid
      console.info 'Weather: Probably more than one location match, please be more specific'
    
  getForecast: (woeid) ->
    @doQuery "select * from weather.forecast where woeid=#{woeid}", @setForecast
  
  setForecast: (res) =>
    console.log util.inspect res.results.channel
    console.log res.results.channel.item.condition.temp
    
x = new Weather 'Hove, GB'

module.exports = (app, plugin) ->
  app.register 'source.weather', Weather
  app.on 'boo', ->
    console.log '******************************'
  