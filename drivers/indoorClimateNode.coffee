#struct {byte light; int humidity; int temperature; byte vcc; } payload;
module.exports =

  announcer: 16

  descriptions:
    light:
      title: 'Light level'
      unit: '%'
      min: 0
      max: 255
      factor: 100 / 255
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
    battery:
      title: 'Battery'
      unit: 'mV'
      min: '0'
      max: '5000'

  feed: 'rf12.packet'

  decode: (raw, cb) ->
    cb
      #OK 16 235 55 2 200 0 117 null
      light: raw[1]
      humi: raw.readUInt16LE(2)
      temp: raw.readUInt16LE(4)
      battery: (raw[6] * 20) + 1000