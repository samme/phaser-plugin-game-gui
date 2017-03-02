![Screenshot](https://samme.github.io/phaser-plugin-game-gui/screenshot.png)

[Demo](https://samme.github.io/phaser-plugin-game-gui/)

Quick access to some common game settings and commands:

  - pause, frame step
  - restart
  - camera effects, position, and lerp
  - scaleMode
  - fullScreen
  - sound mute/volume
  - slow motion …

Install
-------

If not using `bower` or `npm`, include [dat.gui](https://github.com/dataarts/dat.gui) and [index.js](./index.js) before your game scripts.

Use
---

```javascript
// @init or @create:
// (If you've resized `world` or `camera`, add at the end of @create.)
game.plugins.add(Phaser.Plugin.GameGui);
```

You can also pass options and access the GUI itself:

```javascript
var gameGuiPlugin = game.plugins.add(Phaser.Plugin.GameGui, {
  // Default options:
  autoPlace: true,
  width: 245,
});

gameGuiPlugin.gui.width = 400;
gameGuiPlugin.gui.closed = true;
gameGuiPlugin.gui.destroy();
```

Issues
------

- [dataarts/dat.gui/issues/124](https://github.com/dataarts/dat.gui/issues/124) (dat.gui@0.6.1)

  A workaround:

  ```css
  .dg .slider { width: 60% !important }
  ```
