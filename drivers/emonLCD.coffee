#struct {int16_t temperature;} payload;
module.exports =

  announcer: 11

  descriptions:
    temp:
      title: 'Temperature'
      unit: 'C'
      min: -50
      max: 50
      scale: 2

  feed: 'rf12.packet'

  decode: (raw, cb) ->
    t = raw[2] * 256
    t = t + raw[1]
    cb
      #OK 11 108 8 null
      temp: t