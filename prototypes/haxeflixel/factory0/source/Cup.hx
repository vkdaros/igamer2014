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

        // TODO: this moves the hitbox. It sholud be the new origin (position)
        //       of the sprite. But origin in Flixel is used only for rotation.
        //       Best approach would be create MySprite which extends FlXSprite
        //       and handle offset the way it is needed.
        offset.set(ICE_CREAM_FRAME_WIDTH / 2, 24);

        // loadGraphic(PATH, ANIMATED, FRAME_WIDTH, FRAME_HEIGHT)
        loadGraphic("assets/images/icecream_cup.png", false,
                    ICE_CREAM_FRAME_WIDTH, ICE_CREAM_FRAME_HEIGHT);
        antialiasing = true;
    }

    override public function update():Void {
        super.update();
    }
}
