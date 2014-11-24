package;

import flixel.FlxSprite;

import Constants.*;
import IceCream;

class Device extends FlxSprite{
    private var _direction:Int;

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
}
