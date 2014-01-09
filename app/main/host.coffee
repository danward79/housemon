module.exports = (app, plugin) ->
  
  app.register 'nodemap.rf12-868,42,2', 'testnode'
  
  app.register 'nodemap.rf12-2', 'roomnode'
  app.register 'nodemap.rf12-3', 'radioblip'
  app.register 'nodemap.rf12-4', 'roomnode'
  app.register 'nodemap.rf12-5', 'roomnode'
  app.register 'nodemap.rf12-6', 'roomnode'
  app.register 'nodemap.rf12-9', 'homepower'
  app.register 'nodemap.rf12-10', 'roomnode'
  app.register 'nodemap.rf12-11', 'roomnode'
  app.register 'nodemap.rf12-12', 'roomnode'
  app.register 'nodemap.rf12-13', 'roomnode'
  app.register 'nodemap.rf12-15', 'smarelay'
  app.register 'nodemap.rf12-18', 'p1scanner'
  app.register 'nodemap.rf12-19', 'ookrelay'
  app.register 'nodemap.rf12-23', 'roomnode'
  app.register 'nodemap.rf12-24', 'roomnode'
  
  app.register 'nodemap.rf12-868,212,5', 'emontxNode'
  app.register 'nodemap.rf12-868,212,11', 'emonLCD'
  app.register 'nodemap.rf12-868,212,17', 'barotxNode'
  app.register 'nodemap.rf12-868,212,16', 'indoorClimateNode'
  app.register 'nodemap.rf12-868,212,18', 'wxtxNode'

  app.on 'running', ->
    Logger = @registry.sink.logger
    Replayer = @registry.pipe.replayer
    Serial = @registry.interface.serial
    Parser = @registry.pipe.parser
    Dispatcher = @registry.pipe.dispatcher
    ReadingLog = @registry.sink.readinglog
    StatusTable = @registry.sink.statustable
    createLogStream = @registry.source.logstream
    TimeBroadcast = @registry.source.timebroadcast

    # app.db.on 'put', (key, val) ->
    #   console.log 'db:', key, '=', val
    # app.db.on 'batch', (array) ->
    #   console.log 'db#', array.length
    #   for x in array
    #     console.log ' ', x.key, '=', x.value
    ###
    readings = createLogStream('app/replay/20121130.txt.gz')
      .pipe(new Replayer)
      .pipe(new Parser)
      .pipe(new Dispatcher)

    readings
      .pipe(new ReadingLog app.db)

    readings
      .pipe(new StatusTable app.db)
    ###
    jeelink = new Serial('usb-A1014KGL').on 'open', ->

      jeelink # log raw data to file, as timestamped lines of text
          .pipe(new Logger) # sink, can't chain this further

      jeelink # log decoded readings as entries in the database
          .pipe(new Parser)
          .pipe(new Dispatcher)
          .pipe(new ReadingLog app.db)
          
      jeelink
          .pipe(new StatusTable app.db)
          
    timebroadcast = new TimeBroadcast 'usbserial-A1014KGL'
