package;

import flixel.FlxG;
import flixel.ui.FlxButton;
import flixel.addons.ui.FlxUIPopup;

class DevicePopup extends FlxUIPopup {
    override public function create():Void {
        // Set an empty xml file just to avoid FlxUIPopup default layout.
        _xml_id = "empty";
        super.create();

        var closeFunction = function():Void {
            close();
        }
        var closerButton = new FlxButton(30, 15, "Close", closeFunction);
        add(closerButton);
    }

    // This function is called by substate right after substate will be closed.
    public static function onSubstateClose():Void {
        FlxG.cameras.fade();
    }
}
