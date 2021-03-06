package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxObject;
import flixel.tweens.FlxTween;

import Constants.*;
import IceCream;

class Box extends IceCream {
    /**
     * Position i,j with respect of tile grid. The screen coordinates x,y will
     * calculated automaticaly.
     */
    override public function new(I:Int = 0, J:Int = 0, direction:Int = SW) {
        super(I, J, direction);
        var piece = stackPiece(0);

        setFacingFlip(FlxObject.LEFT, false, false);
        setFacingFlip(FlxObject.RIGHT, true, false);

        // animation.add(NAME, FRAMES, FRAME_RATE, SHOULD_LOOP)
        var frames = [0, 1, 2, 3];
        piece.animation.add("shake", frames, 10, true);
        piece.animation.add("idle", [0], 1, false);
        piece.animation.play("idle");

        facing = FlxObject.LEFT;
        if (direction == SE || direction == NE) {
            facing = FlxObject.RIGHT;
        }
    }

    override public function update():Void {
        super.update();
    }

    override public function stackPiece(index:Int):FlxSprite {
        var piece:FlxSprite = null;

        if (index == 0) {
            piece = new FlxSprite();

            // loadGraphic(PATH, ANIMATED, FRAME_WIDTH, FRAME_HEIGHT)
            piece.loadGraphic("assets/images/box.png", true, TILE_FRAME_WIDTH,
                              TILE_FRAME_HEIGHT);
            piece.antialiasing = true;

            // TODO: this moves the hitbox. It sholud be the new origin
            //       (position) of the sprite. But origin in Flixel is used only
            //       for rotation.
            //       Best approach would be create MySprite which extends
            //       FlXSprite and handle offset the way it is needed.
            piece.offset.set(TILE_WIDTH / 2, 45);

            addToStack(piece);
        }
        return piece;
    }

    override public function setShaking(isShaking:Bool):Void {
        if (isShaking == _shaking) {
            return;
        }

        _shaking = isShaking;
        if (_shaking) {
            _stack[0].animation.play("shake");
        }
        else {
            _stack[0].animation.play("idle");
        }
    }
}
