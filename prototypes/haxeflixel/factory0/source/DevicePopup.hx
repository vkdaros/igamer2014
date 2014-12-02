package;

import flixel.FlxG;
import flixel.ui.FlxButton;
import flixel.addons.ui.FlxUIPopup;
import flixel.plugin.MouseEventManager;
import flixel.FlxSprite;

import Constants.*;

/**
 * This class handles the exhibition of context menus for devices upon interaction by the player.
 * It is the base class, including the common actions to all devices (remove, roll up and roll down).
 * Devices that require additional actions shall use a popup class inherited from this one.
 */
class DevicePopup extends FlxUIPopup {

    private var _device:Device;

    /** Stores the background used to prevent the mouse events to forward to the back ui. */
    private var _background:FlxSprite;

    public function new(device:Device) {
        super();
        _device = device;
    }

    override public function create():Void {
        // Set an empty xml file just to avoid FlxUIPopup default layout.
        _xml_id = "empty";
        super.create();

        var closeFunction = function():Void {
            close();
        }

        _background = new flixel.FlxSprite(0, 0);
        _background.makeGraphic(GAME_WIDTH, GAME_HEIGHT, POPUP_BACKGROUND_COLOR);
        add(_background);
        MouseEventManager.add(_background);

        var closerButton = new FlxButton(_device.x, _device.y, "Close", closeFunction);
        add(closerButton);
    }

    /**
     * Class destructor.
     */
    override public function destroy():Void {
        MouseEventManager.remove(_background);
        _background.destroy();
        super.destroy();
    }

    // This function is called by substate right after substate will be closed.
    public static function onSubstateClose():Void {
        FlxG.cameras.fade();
    }
}
