package;

import flixel.FlxSprite;

import Constants.*;
import Scale;
import DevicePopup;

/**
 * Popup menu used by the ice cream cup dispenser.
 */
class DispenserPopup extends DevicePopup {
    /** 
     * Class constructor.
     * @param device Instance of a Device to be manipulated by the popup.
     */
    override public function new(device:Device) {
        super(device);
    }

    /**
     * Override the basic function to create a plain image sprite instead of a
     * field text area.
     */
    override private function createInfoArea():Void {
        _infoArea = new FlxSprite();

        _infoArea.loadGraphic("assets/images/icecream_cup_64.png", true, 64, 64);

        _infoArea.x = _bbox.right + POPUP_BUTTON_HMARGIN - 5;
        _infoArea.y = _bbox.top + _bbox.height / 2 - 10;
        _infoArea.antialiasing = true;
        _infoArea.offset.y = _infoArea.height / 2;

        add(_infoArea);
    }    

    /**
     * Override the setter of the _currentValue property to guarantee a range
     * for the counting value.
     * @param value Integer with the new value for the property. The value must
     * be in the range [MIN_DISPENSER_VALUE, MAX_DISPENSER_VALUE].
     * @return Integer with the value of the property.
     */
    override private function set__currentValue(value:Int): Int {
        if(value >= MIN_DISPENSER_VALUE && value <= MAX_DISPENSER_VALUE) {
            _currentValue = value;
            _infoArea.animation.frameIndex = _currentValue - 1;
        }
        return _currentValue;
    }
}