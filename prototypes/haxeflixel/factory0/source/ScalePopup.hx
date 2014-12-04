package;

import flixel.FlxSprite;

import Constants.*;
import Scale;
import DevicePopup;

class ScalePopup extends DevicePopup {
    override public function new(device:Device) {
        super(device);
    }

    /**
     * Setter and getter of _currentValue property.
     * @param value Integer with the new value for the property. The value must
     * be in the range [MIN_SCALE_VALUE, MAX_SCALE_VALUE].
     * @return Integer with the value of the property.
     */
    override private function set__currentValue(value:Int): Int {
        if(value >= MIN_SCALE_VALUE && value <= MAX_SCALE_VALUE) {
            _currentValue = value;
            if (_infoArea != null) {
                _infoArea.text = "" + _currentValue;
            }
        }
        return _currentValue;
    }

    override function upCallback():Void {
        super.upCallback();
    }

    override function downCallback():Void {
        super.downCallback();
    }

    override function clearCallback():Void {
        super.clearCallback();
    }

    override function quitCallback(sprite:FlxSprite):Void {
        super.quitCallback(sprite);
    }
}
