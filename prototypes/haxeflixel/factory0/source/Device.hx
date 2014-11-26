package;

import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;

import Constants.*;
import IceCream;

class Device extends FlxSpriteGroup {
    private var _direction:Int;

    private var _bodyPiece:FlxSprite;
    private var _topPiece:FlxSprite;

    /***
     * Private constructor prevents instantiation of this class.
     * It is almost abstract.
     */
    private function new(X:Float, Y:Float, direction:Int = SW) {
        super(X, Y);
        _direction = direction;
    }

    // Function called whenever an ice cream reaches the device.
    public function transformIceCream(item:IceCream):Void {
        if (item == null) {
            return;
        }
    }

    public function getBodyPiece():FlxSprite {
        return _bodyPiece;
    }

    public function getTopPiece():FlxSprite {
        return _topPiece;
    }
}
