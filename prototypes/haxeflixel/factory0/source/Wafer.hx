package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxObject;
import flixel.tweens.FlxTween;

import Constants.*;
import IceCream;

/**
 * Implements a wafer ice cream cup.
 */
// TODO (LCV 8 dec): I do not really see the point of having this class apart 
// from Cup, since it is really only about changing the index of the sprite that
// one want to draw!
class Wafer extends IceCream {
	/**
	 * Class constructor
	 * @param I Integer with the row position in the tiles grid.
	 * @param J Integer with the column position in the tiles grid.
	 * @param direction Integer with the direction the cup will start moving.
	 */
    override public function new(I:Int = 0, J:Int = 0, direction:Int = SW) {
        super(I, J, direction);
        stackPiece(1);
    }

	/**
	 * Load the graph and add the piece to the stack.
	 * @param index Integer with the index of the image to use in the sprite.
	 * @return Returns a FlxSprite with the piece loaded.
	 */
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
