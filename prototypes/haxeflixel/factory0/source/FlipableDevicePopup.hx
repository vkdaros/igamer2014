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
        var flipButton = new FlxButton(_bbox.left - POPUP_BUTTON_WIDTH,
                        _bbox.y - POPUP_BUTTON_WIDTH + POPUP_BUTTON_HEIGHT / 3,
                        null, flipCallback);
        flipButton.loadGraphic("assets/images/button_flip.png", true,
                                POPUP_BUTTON_WIDTH, POPUP_BUTTON_HEIGHT);
        flipButton.antialiasing = true;
        add(flipButton);
    }    

    /**
     * Handler of the flip button.
     */
    private function flipCallback():Void {
        _actionPerformed = true;
    // TODO: call method flip() in a subclass of Device called FlipableDevice
    }
}