package;

import flixel.FlxG;
import flixel.ui.FlxButton;
import flixel.addons.ui.FlxUIPopup;
import flixel.plugin.MouseEventManager;
import flixel.FlxSprite;
import flixel.FlxObject;
import flixel.util.FlxColor;
import flixel.text.pxText.PxTextAlign;
import flixel.text.pxText.PxBitmapFont;
import openfl.Assets;

import flash.geom.Rectangle;

import Constants.*;

/**
 * This class handles the exhibition of context menus for devices upon
 * interaction by the player. It is the base class, including the common actions
 * to all devices (remove, roll up and roll down).
 * Devices that require additional actions shall use a popup class inherited
 * from this one.
 */
class DevicePopup extends FlxUIPopup {

    /** Instance of the device for which the popup is being used. */
    private var _device:Device;

    /**
     * Transparent background sprite used to prevent the mouse events from
     * forwarding to the back ui and to capture the click used to close the
     * device popup.
     */
    private var _background:FlxSprite;

    /** Text field for presenting counting data for the device. */
    private var _infoArea:BitmapTextField;

    /**
     * Indication if an action has just been performed (to avoid forwarding
     * click events to the fake background and close the menu when buttons are
     * clicked).
     */
    private var _actionPerformed:Bool;

    /** The current value of the main device configuration. */
    public var _currentValue(default, set):Int;

    /**
     * Setter and getter of _currentValue.
     * @param value Integer with the new value for the property.
     * @return Integer with the value of the property.
     */
    private function set__currentValue(value:Int): Int {
        _currentValue = value;
        _infoArea.text = "" + _currentValue;
        return _currentValue;
    }

    /**
     * Class constructor.
     * @param device Instance of a Device to be manipulated by the popup.
     */
    public function new(device:Device) {
        super();
        _device = device;
        _actionPerformed = false;
    }

    /**
     * Initialization method for the class.
     */
    override public function create():Void {
        // Set an empty xml file just to avoid FlxUIPopup default layout.
        _xml_id = "empty";
        super.create();

        _background = new flixel.FlxSprite(0, 0);
        _background.makeGraphic(GAME_WIDTH, GAME_HEIGHT,
                                POPUP_BACKGROUND_COLOR);
        add(_background);
        MouseEventManager.add(_background, null, quitCallback);

        // Rectangle with the bounding box of the device
        var bbox = new Rectangle(_device.x - _device.offset.x,
                                 _device.y - _device.offset.y,
                                 TILE_WIDTH, 2 * TILE_HEIGHT);

        // Up and down buttons (to change basic configuration like flavour,
        // number of scoops, etc)
        var upButton = new FlxButton(bbox.right + POPUP_BUTTON_HMARGIN, bbox.y,
                                     null, upCallback);
        upButton.loadGraphic("assets/images/button_arrow.png", true,
                             POPUP_BUTTON_WIDTH, POPUP_BUTTON_HEIGHT);
        upButton.antialiasing = true;
        add(upButton);

        var downButton = new FlxButton(bbox.right + POPUP_BUTTON_HMARGIN,
                                       bbox.bottom - POPUP_BUTTON_WIDTH, null,
                                       downCallback);
        downButton.loadGraphic("assets/images/button_arrow.png", true,
                               POPUP_BUTTON_WIDTH, POPUP_BUTTON_HEIGHT);
        downButton.antialiasing = true;
        downButton.setFacingFlip(FlxObject.DOWN, false, true);
        downButton.facing = FlxObject.DOWN;
        add(downButton);

        var textBytes = Assets.getText("assets/fonts/Courgette.fnt");
        var XMLData = Xml.parse(textBytes);
        var font:PxBitmapFont = new PxBitmapFont().loadAngelCode(
                Assets.getBitmapData("assets/fonts/Courgette.png"), XMLData);

        _infoArea = new BitmapTextField(font);
        _infoArea.x = bbox.right + POPUP_BUTTON_WIDTH + 2 * POPUP_BUTTON_HMARGIN;
        _infoArea.y = bbox.y + bbox.height / 2;
        _infoArea.useTextColor = false;
        _infoArea.fontScale = 0.5;
        _infoArea.alignment = PxTextAlign.CENTER;
        _infoArea.offset.y = font.getFontHeight() * _infoArea.fontScale / 2;
        _infoArea.antialiasing = true;
        add(_infoArea);
        _currentValue = 1;

		var teste = new FancyLabel(10, 10, 100, 100, "1", font, 0.5, FlxColor.RED, FlxColor.WHITE, 5, 5, 5);
		add(teste);
		
        // Reset button
        var clearButton = new FlxButton(bbox.x + (bbox.width / 2) -
                                                 (POPUP_BUTTON_WIDTH / 2),
                                        bbox.bottom + POPUP_BUTTON_VMARGIN,
                                        null, clearCallback);
        clearButton.loadGraphic("assets/images/button_reset.png", true,
                                POPUP_BUTTON_WIDTH, POPUP_BUTTON_HEIGHT);
        clearButton.antialiasing = true;
        add(clearButton);
    }

    /**
     * Handler of the up button.
     */
    private function upCallback():Void {
        _actionPerformed = true;
        _currentValue++;
    }

    /**
     * Handler of the down button.
     */
    private function downCallback():Void {
        _actionPerformed = true;
        _currentValue--;
    }

    /**
     * Handler of the clear button.
     */
    private function clearCallback():Void {
        _actionPerformed = true;
        cast(FlxG.state, PlayState).removeDevice(_device);
        close();
    }

    /**
     * Handler of the outside click (to close the popup).
     * @param sprite Instance of the FlxSprite clicked.
     */
    private function quitCallback(sprite:FlxSprite):Void {
        if(_actionPerformed)
            _actionPerformed = false;
        else
            close();
    }

    /**
     * Class destructor.
     */
    override public function destroy():Void {
        MouseEventManager.remove(_background);
        _background.destroy();
        super.destroy();
    }

    /**
     * This function is called by substate right after substate will be closed.
     */
    public static function onSubstateClose():Void {
        FlxG.cameras.fade();
    } 
}
