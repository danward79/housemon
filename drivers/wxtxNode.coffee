#struct {int light; int humidity; int temperature; int dewpoint; int cloudbase; int vcc;} payload;
module.exports =

  announcer: 17

  descriptions:
    light:
      title: 'Light intensity'
      unit: '%'
      min: 0
      max: 100
      scale: 0
    humi:
      title: 'Relative humidity'
      unit: '%'
      min: 0
      max: 100
      scale: 1
    temp:
      title: 'Temperature'
      unit: 'C'
      min: -50
      max: +50
      scale: 1
    dewpoint:
      title: 'Dewpoint'
      unit: 'C'	      
      min: -50
      max: 50
    cloudbase:
      title: 'Cloudbase'
      unit: 'Ft'	      
      min: -1000
      max: 50000
    battery:
      title: 'Battery'
      unit: 'mV'
      min: '0'
      max: '5000'

  feed: 'rf12.packet'

  decode: (raw, cb) ->
    cb
      #int light; int humidity; int temperature; int dewpoint; int cloudbase; int vcc;} payload;
      #OK 18 100 0 151 2 187 0 12 0 120 10 179 11 null
      light: raw.readUInt16LE(1)
      humi: raw.readUInt16LE(3)
      temp: raw.readUInt16LE(5)
      dewpoint: raw.readUInt16LE(7)
      cloudbase: raw.readUInt16LE(9)
      battery: raw.readUInt16LE(11)