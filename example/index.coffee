"use strict"

{Phaser} = this

window.GAME = new (Phaser.Game)
  # antialias: yes
  # height: 600
  # renderer: Phaser.AUTO
  # resolution: 1
  # scaleMode: Phaser.ScaleManager.NO_SCALE
  # transparent: no
  # width: 800
  state:

    init: ->
      return

    preload: ->
      @load.baseURL = "http://examples.phaser.io/assets/"
      @load.crossOrigin = "anonymous"
      @load.image "backdrop", "pics/remember-me.jpg"
      @load.image "hotdog", "sprites/hotdog.png"
      return

    create: ->
      @world.setBounds 0, 0, 1920, 1200

      @camera.focusOnXY @world.centerX, 0

      unless @gameGuiPlugin
        @gameGuiPlugin = @game.plugins.add Phaser.Plugin.GameGui, {width: 400}

      @add.image 0, 0, "backdrop"

      @hotdogs = @add.physicsGroup()
      for hotdog in @hotdogs.createMultiple(10, "hotdog", 0, yes)
        hotdog.position.set @world.randomX, @world.randomY
        scale = @rnd.realInRange 0.25, 0.75
        hotdog.scale.set scale
        hotdog.body.velocity.x = scale * -100

      return

    update: ->
      @world.wrap hotdog, 230 for hotdog in @hotdogs.children
      return

    render: ->
      return

    shutdown: ->
      return
