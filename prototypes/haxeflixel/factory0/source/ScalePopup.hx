package;

import flixel.FlxSprite;

import Constants.*;
import Scale;
import DevicePopup;

/**
 * Popup menu used by the Scale switcher.
 */
class ScalePopup extends FlipableDevicePopup {

    /**
     * Class constructor.
     * @param device Instance of a Device to be manipulated by the popup.
     */
    override public function new(device:Device) {
        super(device);
    }

	/**
     * Initialization method for the class.
     */
    override public function create():Void {
		super.create();
		// Initialize the property with the correct value
		_currentValue = MIN_SCALE_VALUE;
	}
	
    /**
     * Override the setter of the _currentValue property to guarantee a range
     * for the counting value.
     * @param value Integer with the new value for the property. The value must
     * be in the range [MIN_SCALE_VALUE, MAX_SCALE_VALUE].
     * @return Integer with the value of the property.
     */
    override private function set__currentValue(value:Int): Int {
        if(value >= MIN_SCALE_VALUE && value <= MAX_SCALE_VALUE) {
            super.set__currentValue(value);
        }
        return _currentValue;
    }
}
