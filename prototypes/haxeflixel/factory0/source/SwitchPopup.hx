package;

import flixel.FlxSprite;

import Constants.*;
import Scale;
import DevicePopup;

/**
 * Popup menu used by the regular switcher.
 */
class SwitchPopup extends FlipableDevicePopup {
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

		// Switchers do not have changeable properties, so hide up and down
		// buttons and info area
		_upButton.visible = false;
		_downButton.visible = false;
		_infoArea.visible = false;
		
	}
}
