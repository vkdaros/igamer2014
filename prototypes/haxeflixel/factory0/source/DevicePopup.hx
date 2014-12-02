package;

import flixel.FlxG;
import flixel.ui.FlxButton;
import flixel.addons.ui.FlxUIPopup;
import flixel.plugin.MouseEventManager;
import flixel.FlxSprite;
import flixel.FlxObject;
import flixel.text.FlxBitmapTextField;
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

    /**
     * Class constructor.
     * @param device Instance of a Device to be manipulated by the popup.
     */
    public function new(device:Device) {
        super();
        _device = device;
    }

    /**
     * Initialization method for the class.
     */
    override public function create():Void {
        // Set an empty xml file just to avoid FlxUIPopup default layout.
        _xml_id = "empty";
        super.create();

        /**
         * Handler of the up button.
         */
        var upFunction = function():Void {
            Log.info("Up Clicked!");
        }

        /**
         * Handler of the down button.
         */
        var downFunction = function():Void {
            Log.info("Down Clicked!");
        }

        /**
         * Handler of the reset button.
         */
        var resetFunction = function():Void {
            Log.info("Reset Clicked!");
        }

        /**
         * Handler of the outside click (to close the popup).
         * @param sprite Instance of the FlxSprite clicked.
         */
        var closeFunction = function(sprite:FlxSprite):Void {
            close();
        }

        _background = new flixel.FlxSprite(0, 0);
        _background.makeGraphic(GAME_WIDTH, GAME_HEIGHT,
                                POPUP_BACKGROUND_COLOR);
        add(_background);
        MouseEventManager.add(_background, null, closeFunction);

        // Rectangle with the bounding box of the device
        var bbox = new Rectangle(_device.x - _device.offset.x,
                                 _device.y - _device.offset.y,
                                 TILE_WIDTH, 2 * TILE_HEIGHT);

        // Up and down buttons (to change basic configuration like flavour,
        // number of scoops, etc)
        var upButton = new FlxButton(bbox.right + POPUP_BUTTON_HMARGIN, bbox.y,
                                     null, upFunction);
        upButton.loadGraphic("assets/images/button_arrow.png", true,
                             POPUP_BUTTON_WIDTH, POPUP_BUTTON_HEIGHT);
        upButton.antialiasing = true;
        add(upButton);

        var downButton = new FlxButton(bbox.right + POPUP_BUTTON_HMARGIN,
                                       bbox.bottom - POPUP_BUTTON_WIDTH, null,
                                       downFunction);
        downButton.loadGraphic("assets/images/button_arrow.png", true,
                               POPUP_BUTTON_WIDTH, POPUP_BUTTON_HEIGHT);
        downButton.antialiasing = true;
        downButton.setFacingFlip(FlxObject.DOWN, false, true);
        downButton.facing = FlxObject.DOWN;
        add(downButton);

        var textBytes = Assets.getText("assets/fonts/Courgette.fnt");
        var XMLData = Xml.parse(textBytes);
        var font:PxBitmapFont = new PxBitmapFont().loadAngelCode(Assets.getBitmapData("assets/fonts/Courgette.png"), XMLData);

        var infoArea = new FlxBitmapTextField(font);
        //infoArea.x = bbox.right + 2 * POPUP_BUTTON_HMARGIN;
        //infoArea.y = bbox.y + bbox.height / 2;
        infoArea.text = _tongue.get("$STAGE_SELECT", "ui");
        infoArea.x = 10;
        infoArea.y = 10;
        infoArea.useTextColor = false;
        //infoArea.fixedWidth = false;
        //infoArea.lineSpacing = 5;
        //infoArea.padding = 5;
        infoArea.fontScale = 0.5;
        //infoArea.width = 300;
        //infoArea.height = 200;
        //infoArea.background = true;
        //infoArea.backgroundColor = POPUP_INFOAREA_BGCOLOR;
        //infoArea.color = POPUP_INFOAREA_FGCOLOR;
        infoArea.alignment = PxTextAlign.CENTER;
        //infoArea.shadow = true;
        add(infoArea);

        // Reset button
        var resetButton = new FlxButton(bbox.x + (bbox.width / 2) -
                                                 (POPUP_BUTTON_WIDTH / 2),
                                        bbox.bottom + POPUP_BUTTON_VMARGIN,
                                        null, resetFunction);
        resetButton.loadGraphic("assets/images/button_reset.png", true,
                                POPUP_BUTTON_WIDTH, POPUP_BUTTON_HEIGHT);
        resetButton.antialiasing = true;
        add(resetButton);
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
