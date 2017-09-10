![Screenshot](https://samme.github.io/phaser-plugin-game-gui/screenshot.png)

[Demo](https://samme.github.io/phaser-plugin-game-gui/)

Quick access to some common game settings and commands:

  - Pause and frame-stepping
  - Restart current state
  - Camera flash, shake, position, and lerp
  - Input (keyboard, mouse, touch) toggles
  - Scale mode, start/stop fullscreen
  - Sound mute and volume
  - Slow motion

Install
-------

If not using `bower` or `npm`, include [dat.gui](https://github.com/dataarts/dat.gui) and [index.js](./index.js) before your game scripts.

Use
---

```javascript
// In init() or create():
// (If you've resized `world` or `camera`, add the plugin **after** those changes.)
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

Thanks
------

[Demo](https://samme.github.io/phaser-plugin-game-gui/) sound effects by Eric Matyas [www.soundimage.org](http://www.soundimage.org)
