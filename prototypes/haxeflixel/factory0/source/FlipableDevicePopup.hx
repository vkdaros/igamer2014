package;

import flixel.FlxSprite;
import flixel.ui.FlxButton;

import Constants.*;
import Scale;
import DevicePopup;

/**
 * Popup menu used by flipable devices.
 */
class FlipableDevicePopup extends DevicePopup {
	
	/** Button used to flip the device. */
	private var _flipButton:FlxButton;
	
    /**
     * Class constructor.
     * @param device Instance of a Device to be manipulated by the popup.
     */
    override public function new(device:Device) {
        super(device);
    }

    /**
     * Auxiliary method to create the popup buttons.
     */
    override private function createButtons():Void {
        super.createButtons();

        // Flip button
        _flipButton = new FlxButton(_bbox.left - POPUP_BUTTON_WIDTH,
                        _bbox.y - POPUP_BUTTON_WIDTH + POPUP_BUTTON_HEIGHT / 3,
                        null, flipCallback);
        _flipButton.loadGraphic("assets/images/button_flip.png", true,
                                POPUP_BUTTON_WIDTH, POPUP_BUTTON_HEIGHT);
        _flipButton.antialiasing = true;
        add(_flipButton);
    }

    /**
     * Handler of the flip button.
     */
    private function flipCallback():Void {
        _actionPerformed = true;
		cast(_device, FlipableDevice).flipSideDirection();
    }
}
