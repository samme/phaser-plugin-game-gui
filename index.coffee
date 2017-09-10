"use strict"

{dat, Phaser} = this

{ScaleManager} = Phaser

{Arcade} = Phaser.Physics

{isArray} = Array

clickTrampolineChoices = ["", "when-not-mouse"]

windowConstraintChoices = ["", "layout", "visual"]

if ScaleManager
  scaleModes =
    "exact fit":  ScaleManager.EXACT_FIT
    "no scale":   ScaleManager.NO_SCALE
    "resize":     ScaleManager.RESIZE
    "show all":   ScaleManager.SHOW_ALL
    "user scale": ScaleManager.USER_SCALE

addArcadeSortDirection = (cn, arcade, name) ->
  controller = cn.add arcade, name,
    "bottom top": Arcade.BOTTOM_TOP
    "left right": Arcade.LEFT_RIGHT
    "right left": Arcade.RIGHT_LEFT
    "top bottom": Arcade.TOP_BOTTOM
    "sort none":  Arcade.SORT_NONE
  controller.onChange saveNumericValue
  controller

addScaleMode = (cn, scaleManager, name) ->
  controller = cn.add scaleManager, name, scaleModes
  controller.onChange saveNumericValue
  controller

saveNumericValue = (newValue) ->
  @object[@property] = Number newValue
  return

PROPS = Object.freeze
  game:
    clearBeforeRender: yes
    disableStep: yes
    enableStep: yes
    forceSingleUpdate: yes
    lockRender: yes
    paused: yes
    step: yes
    camera:
      fade: yes
      flash: yes
      reset: yes
      resetFX: yes
      roundPx: yes
      shake: yes
      unfollow: yes
      x: (cn, camera) -> [camera.bounds.left, camera.bounds.right  - camera.view.width , 10]
      y: (cn, camera) -> [camera.bounds.top , camera.bounds.bottom - camera.view.height, 10]
      lerp:
        x: [0, 1, 0.05]
        y: [0, 1, 0.05]
    debug:
      sprite:
        visible: yes
    input:
      enabled: yes
      maxPointers: [-1, 10, 1]
      keyboard:
        enabled: yes
      mouse:
        enabled: yes
      touch:
        enabled: yes
    physics:
      arcade:
        checkCollision:
          down: yes
          left: yes
          right: yes
          up: yes
        forceX: yes
        gravity:
          x: [-1000, 1000, 10]
          y: [-1000, 1000, 10]
        isPaused: yes
        OVERLAP_BIAS: [-16, 16, 1]
        skipQuadTree: yes
        sortDirection: addArcadeSortDirection
    scale:
      compatibility:
        canExpandParent: yes
        clickTrampoline: [clickTrampolineChoices]
        forceMinimumDocumentHeight: yes
        noMargins: yes
        orientationFallback: yes
        # TODO scrollTo
        supportsFullScreen: yes
      fullScreenScaleMode: addScaleMode
      pageAlignHorizontally: yes
      pageAlignVertically: yes
      parentIsWindow: yes
      refresh: yes
      scaleMode: addScaleMode
      startFullScreen: yes
      stopFullScreen: yes
      windowConstraints:
        bottom: [windowConstraintChoices]
        right: [windowConstraintChoices]
    sound:
      mute: yes
      volume: [0, 1, 0.1]
    stage:
      backgroundColor: (cn, stage, name) -> cn.addColor stage, name
      disableVisibilityChange: yes
      smoothed: yes
    state:
      restart: yes
    time:
      desiredFps: [10, 120, 5]
      slowMotion: [0.1, 10, 0.1]
    tweens:
      frameBased: yes
      pauseAll: yes
      resumeAll: yes
    world:
      alpha: [0, 1, 0.1]
      visible: yes

class Phaser.Plugin.GameGui extends Phaser.Plugin

  gui: null

  init: (options) ->
    @createGui options
    return

  destroy: ->
    @gui.destroy()
    return

  add: (guiContainer, obj, props) ->
    for name, args of props
      @addProp guiContainer, obj, name, args
    guiContainer

  addProp: (guiContainer, obj, name, args) ->
    val = obj[name]
    unless val?
      console.warn "Skipped '#{name}' (#{val})"
      return
    if typeof args is "function"
      result = args.call null, guiContainer, obj, name
      args = if isArray result then result else no
    switch
      when args is no
        return
      when args is yes
        field = guiContainer.add(obj, name)
        unless typeof val is "function"
          field.listen()
      when isArray args
        addArgs = [obj, name].concat args
        guiContainer.add.apply(guiContainer, addArgs).listen()
      when typeof args is "object"
        @add guiContainer.addFolder(name), obj[name], args
      else
        console.warn "Nothing to do: #{args}"
    guiContainer

  createGui: (options) ->
    @gui = new dat.GUI options
    @add @gui, @game, PROPS.game
    @gui
