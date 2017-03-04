"use strict"

{Phaser} = this

window.GAME = new (Phaser.Game)
  # antialias: yes
  # height: 600
  # renderer: Phaser.AUTO
  # resolution: 1
  scaleMode: Phaser.ScaleManager.RESIZE
  # transparent: no
  # width: 800
  state:

    init: ->
      @scale.fullScreenScaleMode = Phaser.ScaleManager.RESIZE
      return

    preload: ->
      @load.path = "example/assets/"
      @load.audio "loop", ["loop.mp3", "loop.ogg"]
      @load.image "backdrop", "backdrop.jpg"
      @load.image "hotdog"
      @load.image "cloud"
      @bar = @add.text 0, 0, "..........", {fill: "white", font: "32px monospace"}
        .alignIn @camera.view, Phaser.CENTER
      @load.setPreloadSprite @bar
      return

    create: ->
      @bar.destroy()

      @world.setBounds 0, 0, 1920, 1200

      @camera.focusOnXY @world.centerX, 0

      unless @gameGuiPlugin
        @gameGuiPlugin = @game.plugins.add Phaser.Plugin.GameGui, {width: 400}

      @add.image 0, 0, "backdrop"

      {bounds} = @world

      @hotdogs = @add.physicsGroup()
      for hotdog in @hotdogs.createMultiple(20, "hotdog", 0, yes)
        hotdog.position.set @world.randomX + bounds.width, @world.randomY
        scale = Math.pow @rnd.realInRange(0.25, 1), 2
        hotdog.scale.set scale
        hotdog.body.velocity.x = scale * -100
        hotdog.tint = ~~(15 * (0.5 + scale / 2)) * 0x111111
      @hotdogs.customSort (a, b) -> a.scale.x - b.scale.x

      @clouds = @add.group()
      @clouds.x = bounds.halfWidth
      for cloud in @clouds.createMultiple(20, "cloud", 0, yes)
        cloud.anchor.set 0.5
        cloud.scale.set @rnd.realInRange 2, 8
        cloud.x = @world.randomX - bounds.halfWidth
        cloud.y = @world.randomY / 2 + bounds.halfHeight

      @add.tween @clouds.scale
        .to
          x: 2
          y: 2
        , 30000, "Linear", yes

      @caption = @add.text 0, 0, "Sound Effects by Eric Matyas www.soundimage.org",
        fill: "white", font: "bold 14px sans-serif"
      .alignIn @world.bounds, Phaser.BOTTOM_LEFT, -10, -30

      @loop = @add.audio "loop"
      @loop.onDecoded.add @startLoop, this

      return

    update: ->
      {left, right} = @world.bounds
      for hotdog in @hotdogs.children
        if hotdog.right < left
          hotdog.left = right
          hotdog.y = @world.randomY
      return

    render: ->
      return

    shutdown: ->
      return

    startLoop: ->
      @loop.fadeIn 5000
      @loop.loopFull()
      return
