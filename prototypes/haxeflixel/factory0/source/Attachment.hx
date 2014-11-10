package;

import flixel.FlxSprite;

import Constants.*;

class Attachment extends FlxSprite{
    private var _direction:Int;

    /***
     * Private constructor prevents instantiation of this class.
     * It is almost abstract.
     */
    private function new(X:Float, Y:Float, direction:Int = SW) {
        super(X, Y);
        _direction = direction;
    }
}
