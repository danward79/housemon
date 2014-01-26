#typedef struct { int power; int voltage; int battery } PayloadTX;

module.exports =

  announcer: 5

  descriptions:
    power:
      title: 'Power'
      unit: 'W'
      min: '0'
      max: '30000'
      #scale: 2
    voltage:
      title: 'Volts'
      unit: 'V'
      min: '0'
      max: '260'
    current:
      title: 'Current'
      unit: 'A'
      min: 0
      max: 100
    battery:
      title: 'Battery'
      unit: 'mV'	      
      min: 0
      max: 6000
    

  feed: 'rf12.packet'

  decode: (raw, cb) ->
    #OK 5 29 8 240 0 192 12 null
    p = raw.readUInt16LE(1)
    v = raw.readUInt16LE(3)
    c = (p / v).toFixed(2)
    cb
      power: p
      voltage: v
      battery: raw.readUInt16LE(5)
      current: c      