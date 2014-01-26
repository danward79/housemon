exports.info =
  version: '0.0.1'
  name: 'time broadcast'
  description: 'This Briq sends a periodic time packet to update remote nodes'
  descriptionHtml: 'This Briq sends a periodic time packet to update remote nodes, that have an RTC<br/>More information about this Briq can be obtained from the [about] link above.<br/>' 
  author: 'danward79'
  authorUrl: 'https://github.com/danward79'
  briqUrl: '/docs/#timebroadcast.md'
  inputs: [
    name: 'Serial port'
    default: '/dev/ttyUSB0'
  ,
    name: 'Time Period'
    default: 120
  ]

exec = require('child_process').exec

class TimeBroadcast 
  
  constructor: (params...) ->
    @period = params[1] * 1000
    @device = params[0]
    @interval = setupInterval @device, @period
    
  destroy: ->
    clearInterval(@interval)
    
  setupInterval = (device, period) ->
    interval = setInterval ( ->
      sendTime device
      ), period
    return interval
    
  sendTime = (device) ->
    d = new Date
    h = d.getHours()
    m = d.getMinutes()
    s = d.getSeconds()
    
    exec "echo 116,#{h},#{m},#{s},s > #{device}", (err, stdout, stderr) ->
      if err
        console.log "exec child process exited with error code " + err.code
        return
        console.log stdout
  
exports.factory = TimeBroadcast
