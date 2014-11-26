package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxObject;
import flixel.tweens.FlxTween;

import Constants.*;
import IceCream;

class Cup extends IceCream {
    /**
     * Position i,j with respect of tile grid. The screen coordinates x,y will
     * calculated automaticaly.
     */
    override public function new(I:Int = 0, J:Int = 0, direction:Int = SW) {
        super(I, J, direction);
        stackPiece(0);
    }

    override public function update():Void {
        super.update();
    }

    override public function stackPiece(index:Int):FlxSprite {
        var piece = new FlxSprite();

        // loadGraphic(PATH, ANIMATED, FRAME_WIDTH, FRAME_HEIGHT)
        piece.loadGraphic("assets/images/icecream_cup.png", true,
                          ICE_CREAM_FRAME_WIDTH, ICE_CREAM_FRAME_HEIGHT);
        piece.antialiasing = true;
        piece.animation.frameIndex = index;

        // TODO: this moves the hitbox. It sholud be the new origin (position)
        //       of the sprite. But origin in Flixel is used only for rotation.
        //       Best approach would be create MySprite which extends FlXSprite
        //       and handle offset the way it is needed.
        piece.offset.set(ICE_CREAM_FRAME_WIDTH / 2, 24);

        // Each new piece is set a bit higher than last one (visual stack).
        if (_stack.length > 0) {
            piece.y -= (_stack.length - 1) * 10;
        }

        addToStack(piece);

        return piece;
    }
}
