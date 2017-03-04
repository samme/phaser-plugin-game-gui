"use strict"

{dat, Phaser} = this

{isArray} = Array

if Phaser.ScaleManager
  {EXACT_FIT, NO_SCALE, RESIZE, SHOW_ALL, USER_SCALE} = Phaser.ScaleManager
  scaleModes =
    EXACT_FIT:  EXACT_FIT
    NO_SCALE:   NO_SCALE
    RESIZE:     RESIZE
    SHOW_ALL:   SHOW_ALL
    USER_SCALE: USER_SCALE

addScaleMode = (cn, scale, name) ->
  controller = cn.add scale, name, scaleModes
  controller.__onChange = onChangeScaleMode
  controller

onChangeScaleMode = (newValue) ->
  @object[@property] = Number newValue
  return

PROPS = Object.freeze
  game:
    clearBeforeRender: yes
    forceSingleUpdate: yes
    lockRender: yes
    paused: yes
    step: yes
    stepping: yes
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
    scale:
      fullScreenScaleMode: addScaleMode
      parentIsWindow: yes
      refresh: yes
      scaleMode: addScaleMode
      startFullScreen: yes
      stopFullScreen: yes
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
      desiredFps: [10, 60, 5]
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
