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
    private var _direction:Int;

    private var _bodyPiece:FlxSprite;
    private var _topPiece:FlxSprite;

    /***
     * Private constructor prevents instantiation of this class.
     * It is almost abstract.
     */
    private function new(parent:ConveyorTile, X:Float, Y:Float,
                         direction:Int = SW) {
        _parent = parent;
        _direction = direction;
        super(X, Y);
    }

    // Function called whenever an ice cream reaches the device.
    public function transformIceCream(item:IceCream):Void {
        if (item == null) {
            return;
        }
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
        FlxG.state.openSubState(new DevicePopup(this));
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

}
