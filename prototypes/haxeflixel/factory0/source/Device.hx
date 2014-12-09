package;

import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.plugin.MouseEventManager;
import flixel.FlxG;

import flash.geom.Rectangle;

import Constants.*;
import DevicePopup;
import IceCream;

class Device extends FlxSpriteGroup {
    private var _parent:ConveyorTile;
	
	/** Property with the movement direction through the device. */
    public var direction(default, set):Int;
	
    private var _bodyPiece:FlxSprite;
    private var _topPiece:FlxSprite;

    /***
     * Private constructor prevents instantiation of this class.
     * It is almost abstract.
     */
    private function new(parent:ConveyorTile, X:Float, Y:Float,
                         dir:Int = SW) {
        _parent = parent;
        direction = dir;
        super(X, Y);
    }

    // Function called whenever an ice cream reaches the device.
    public function transformIceCream(item:IceCream):Void {
        if (item == null) {
            return;
        }
    }
	
	/**
	 * Setter of the property "diretion".
	 * @param value Integer value with the new direction for the device.
	 * @return Integer value with the current direction of the device.
	 */
	public function set_direction(value:Int):Int {
		direction = value;
		return direction;
	}

    /**
     * Function called when the factory starts.
     */
    public function turnOn():Void {
    }

    /**
     * Function called when the factory stops.
     */
    public function turnOff():Void {
    }

    public function getBodyPiece():FlxSprite {
        return _bodyPiece;
    }

    public function getTopPiece():FlxSprite {
        return _topPiece;
    }

    override public function destroy():Void {
        _parent.removeDevice();
        super.destroy();
    }

    /**
     * Handler of the mouse down event for the device. It handles the event for
     * both the body and the top sprites.
     * @param sprite FlxSprite with the sprite for which the mouse event
     * occurred.
     */
    public function onDown(sprite:FlxSprite):Void {
        
    }

    /**
     * Handler of the mouse up event for the device. It handles the event for
     * both the body and the top sprites. Must be overriden by subclasses in
     * order to get a specific DevicePopup.
     * @param sprite FlxSprite with the sprite for which the mouse event
     * occurred.
     */
    public function onUp(sprite:FlxSprite):Void {
		showPopup(new DevicePopup(this));
    }

    /**
     * Handler of the mouse over event for the device. It handles the event for
     * both the body and the top sprites.
     * @param sprite FlxSprite with the sprite for which the mouse event
     * occurred.
     */
    public function onOver(sprite:FlxSprite):Void {
        
    }

    /**
     * Handler of the mouse out event for the device. It handles the event for
     * both the body and the top sprites.
     * @param sprite FlxSprite with the sprite for which the mouse event
     * occurred.
     */
    public function onOut(sprite:FlxSprite):Void {
        
    }

	/**
	 * Display the given device popup when the factory is not running.
	 */
	private function showPopup(popup:DevicePopup):Void {
		// Only display the popup if the factory is not running
		if (!cast(FlxG.state, PlayState).isPlaying())
			FlxG.state.openSubState(popup);		
	}
}
