package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;

import Constants.*;
import Device;

class Doser extends Device {
    public function new(X:Float, Y:Float, direction:Int = SW) {
        super(X, Y - 15, direction);

        var xOffset = TILE_WIDTH / 2;
        var yOffset = TILE_HEIGHT * 1.5;

        // TODO: this moves the hitbox. It sholud be the new origin (position)
        //       of the sprite. But origin in Flixel is used only for rotation.
        //       Best approach would be create MySprite which extends FlXSprite
        //       and handle offset the way it is needed.
        offset.set(xOffset, yOffset);

        // loadGraphic(PATH, ANIMATED, FRAME_WIDTH, FRAME_HEIGHT)
        loadGraphic("assets/images/doser.png", true, TILE_FRAME_WIDTH,
                    2 * TILE_FRAME_HEIGHT);
        antialiasing = true;

        setFacingFlip(FlxObject.LEFT, false, false);
        setFacingFlip(FlxObject.RIGHT, true, false);
        facing = FlxObject.LEFT;
        initAnimations();
    }

    private function initAnimations():Void {
        animation.destroyAnimations();

        var firstFrame = 0;
        if (_direction == SE || _direction == NE) {
            //facing = FlxObject.RIGHT;
            firstFrame = 4;
        }

        // animation.add(NAME, FRAMES, FRAME_RATE, SHOULD_LOOP)
        animation.add("idle", [firstFrame], 1, false);
        animation.play("idle");
    }
}
