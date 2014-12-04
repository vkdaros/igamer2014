package;

import flixel.FlxSprite;

import Constants.*;
import Scale;
import DevicePopup;

/**
 * Popup menu used by the ice cream doser.
 */
class DoserPopup extends DevicePopup {

    /** 
     * Class constructor.
     * @param device Instance of a Device to be manipulated by the popup.
     */
    override public function new(device:Device) {
        super(device);
    }

    /**
     * Override the setter of the _currentValue property to guarantee a range
     * for the counting value.
     * @param value Integer with the new value for the property. The value must
     * be in the range [MIN_SCALE_VALUE, MAX_SCALE_VALUE].
     * @return Integer with the value of the property.
     */
    override private function set__currentValue(value:Int): Int {
        if(value >= MIN_DOSER_VALUE && value <= MAX_DOSER_VALUE) {
            _currentValue = value;
        }
        return _currentValue;
    }
}