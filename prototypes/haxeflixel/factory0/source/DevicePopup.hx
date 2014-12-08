package;

import flixel.effects.FlxSpriteFilter;
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
import flash.filters.GlowFilter;
import flash.filters.BitmapFilterQuality;

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
     * Sprite used for presenting the device data (counting, flavours, etc).
     * Even though the attribute is a FlxSprite, in this class it is
     * instantiated as a BitmapTextField (a child of FlxSprite), since by
     * default only text is presented.
     */
    private var _infoArea:FlxSprite;

    /**
     * Indication if an action has just been performed (to avoid forwarding
     * click events to the fake background and close the menu when buttons are
     * clicked).
     */
    private var _actionPerformed:Bool;

    /** The current value of the main device configuration. */
    public var _currentValue(default, set):Int;

    /** The coordinates of the device's bounding box. */
    private var _bbox:Rectangle;

	/** Glowed filter for the top of the device. */
	private var _bodyGlowed:FlxSpriteFilter;
	
	/** Glowed filter for the body of the device. */
	private var _topGlowed:FlxSpriteFilter;
	
    /**
     * Setter and getter of _currentValue.
     * @param value Integer with the new value for the property.
     * @return Integer with the value of the property.
     */
    private function set__currentValue(value:Int): Int {
        _currentValue = value;
        if (_infoArea != null) {
            cast(_infoArea, BitmapTextField).text = "" + _currentValue;
        }
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

        var font = getFont();

        // Rectangle with the bounding box of the device
        _bbox = new Rectangle(_device.x - _device.offset.x,
                                 _device.y - _device.offset.y,
                                 TILE_WIDTH, 2 * TILE_HEIGHT);

        // Adding external sprites just to make them appear 'bright'.
        add(_device.getBodyPiece());
        add(_device.getTopPiece());

		// Add a greenish glow to the device by using a glow filter
		var glowFilter = new GlowFilter(0xA6FD9C, 0.8, 20, 20, 10,
		                               BitmapFilterQuality.LOW, false, false);
		_bodyGlowed = new FlxSpriteFilter(_device.getBodyPiece(), 20, 20);
		_topGlowed = new FlxSpriteFilter(_device.getTopPiece(), 20, 20);
		_bodyGlowed.addFilter(glowFilter);
		_topGlowed.addFilter(glowFilter);
		
        createButtons();
        createInfoArea();
        _currentValue = 0;
    }

    /**
     * Auxiliary method to create the popup buttons.
     */
    private function createButtons():Void {
        // Up and down buttons (to change basic configuration like flavour,
        // number of scoops, etc)
        var upButton = new FlxButton(_bbox.right + POPUP_BUTTON_HMARGIN,
                        _bbox.y - POPUP_BUTTON_WIDTH + POPUP_BUTTON_HEIGHT / 3,
                        null, upCallback);
        upButton.loadGraphic("assets/images/button_arrow.png", true,
                             POPUP_BUTTON_WIDTH, POPUP_BUTTON_HEIGHT);
        upButton.antialiasing = true;
        add(upButton);

        // Down arrow button.
        var downButton = new FlxButton(_bbox.right + POPUP_BUTTON_HMARGIN,
                                       _bbox.bottom - POPUP_BUTTON_HEIGHT / 3,
                                       null, downCallback);
        downButton.loadGraphic("assets/images/button_arrow.png", true,
                               POPUP_BUTTON_WIDTH, POPUP_BUTTON_HEIGHT);
        downButton.antialiasing = true;
        downButton.setFacingFlip(FlxObject.DOWN, false, true);
        downButton.facing = FlxObject.DOWN;
        add(downButton);

        // Remove button
        var removeButton = new FlxButton(_bbox.left - POPUP_BUTTON_WIDTH,
                                         _bbox.bottom - POPUP_BUTTON_HEIGHT / 3,
                                        null, removeCallback);
        removeButton.loadGraphic("assets/images/button_remove.png", true,
                                POPUP_BUTTON_WIDTH, POPUP_BUTTON_HEIGHT);
        removeButton.antialiasing = true;
        add(removeButton);
    }

    /**
     * Create the basic display area (that, in this class, displays texts).
     */
    private function createInfoArea():Void {
        var font = getFont();
        _infoArea = new BitmapTextField(font);

        cast(_infoArea, BitmapTextField).useTextColor = false;
        cast(_infoArea, BitmapTextField).fontScale = 0.5;
        cast(_infoArea, BitmapTextField).alignment = PxTextAlign.CENTER;

        _infoArea.x = _bbox.right + 2.5 * POPUP_BUTTON_HMARGIN;
        _infoArea.y = _bbox.top + _bbox.height / 2 + 2;
        _infoArea.antialiasing = true;
        _infoArea.offset.y = font.getFontHeight() *
                              cast(_infoArea, BitmapTextField).fontScale / 2;

        add(_infoArea);
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
     * Handler of the remove button.
     */
    private function removeCallback():Void {
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
        else {
			// This is not done in the destroy method to avoid double deletion
			// (internal to the filter class) in case of the remove action.
			_topGlowed.removeAllFilters();
			_bodyGlowed.removeAllFilters();
			_topGlowed.destroy();
			_bodyGlowed.destroy();
			
            close();			
		}
    }

    private function getFont():PxBitmapFont {
        var font:PxBitmapFont = null;
        font = PxBitmapFont.fetch("Courgette");
        if (font == null) {
            // This is a fallback "just in case". Never is called because
            // MenuState already has used that font.
            var textBytes = Assets.getText("assets/fonts/Courgette.fnt");
            var XMLData = Xml.parse(textBytes);
            font = new PxBitmapFont().loadAngelCode(
                   Assets.getBitmapData("assets/fonts/Courgette.png"), XMLData);
            PxBitmapFont.store("Courgette", font);
        }

        return font;
    }

    /**
     * Class destructor.
     */
    override public function destroy():Void {
        // Removing external sprites from this state in order to avoid them to
        // be destroyed.
        remove(_device.getBodyPiece());
        remove(_device.getTopPiece());

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
