package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.util.FlxTimer;

import Constants.*;
import Device;
import IceCream;

class Dispenser extends Device {
    private var _type:Int;
    private var _coolDown:FlxTimer;
    private var _retryDrop:Bool;

    public function new(parent:ConveyorTile, X:Float, Y:Float,
                        dir:Int = SW, type:Int = CUP) {
        super(parent, X, Y - 15, dir);
        _type = type;
        _coolDown = new FlxTimer();
        _retryDrop = false;

        var xOffset = TILE_WIDTH / 2;
        var yOffset = TILE_HEIGHT * 1.5;

        // TODO: this moves the hitbox. It sholud be the new origin (position)
        //       of the sprite. But origin in Flixel is used only for rotation.
        //       Best approach would be create MySprite which extends FlXSprite
        //       and handle offset the way it is needed.
        offset.set(xOffset, yOffset);

        _bodyPiece = new FlxSprite(X - xOffset, Y - yOffset - 15);
        _topPiece = new FlxSprite(X - xOffset, Y - yOffset - 15);

        // loadGraphic(PATH, ANIMATED, FRAME_WIDTH, FRAME_HEIGHT)
        _bodyPiece.loadGraphic("assets/images/device_support.png", true,
                               TILE_WIDTH, 2 * TILE_FRAME_HEIGHT);
        _topPiece.loadGraphic("assets/images/dispenser_top.png", true,
                              TILE_WIDTH, 2 * TILE_FRAME_HEIGHT);

        _bodyPiece.antialiasing = true;
        _topPiece.antialiasing = true;

        _bodyPiece.setFacingFlip(FlxObject.LEFT, false, false);
        _bodyPiece.setFacingFlip(FlxObject.RIGHT, true, false);
        _topPiece.setFacingFlip(FlxObject.LEFT, false, false);
        _topPiece.setFacingFlip(FlxObject.RIGHT, true, false);

        if (direction == SW || direction == NE) {
            _bodyPiece.facing = FlxObject.LEFT;
            _topPiece.facing = FlxObject.LEFT;
        }
        else {
            _bodyPiece.facing = FlxObject.RIGHT;
            _topPiece.facing = FlxObject.RIGHT;

        }
    }

	/**
	 * Get the type of the ice cream cup dispensed by this device.
	 * @return Integer with the type code.
	 */
	public function getType():Int {
		return _type;
	}
	
    public function setType(type:Int):Void {
        _type = type;
    }

    override public function turnOn():Void {
        _coolDown.start(BOX_MOVEMENT_DURATION, dropContainer);
    }

    override public function turnOff():Void {
        _coolDown.cancel();
    }

    /**
     * Try to add an ice cream container to the conveyor. If the tile is empty,
     * drop immediately and reset cooldown. If the tile is not empty, keep drop
     * as soon as it is possible.
     */
    private function dropContainer(timer:FlxTimer = null):Void {
        if (_parent.isEmpty()) {
            _parent.addIceCream(_type);
            _coolDown.start(2 * BOX_MOVEMENT_DURATION, dropContainer);
            _retryDrop = false;
        }
        else {
            _retryDrop = true;
        }
    }

    override public function update():Void {
        if (_retryDrop) {
            dropContainer();
        }
        super.update();
    }

    override public function destroy():Void {
        _coolDown.destroy();
        _bodyPiece.destroy();
        _topPiece.destroy();
        super.destroy();
    }

    /**
     * Handler of the mouse up event for the device. It handles the event for
     * both the body and the top sprites.
     * @param sprite FlxSprite with the sprite for which the mouse event
     * occurred.
     */
    override public function onUp(sprite:FlxSprite):Void {
        showPopup(new DispenserPopup(this));
    }
}
