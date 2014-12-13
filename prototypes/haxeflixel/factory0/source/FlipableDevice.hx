package ;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;

import Constants.*;
import Device;

/**
 * Implements a device that can be flipped.
 */
class FlipableDevice extends Device
{
	/**
	 * Sideways direction of the device (the one that is flipable).
	 */
	private var _sideDirection:Int;


    /**
     * Indicates when device has been flipped.
     */
    private var _flipped:Bool;
	
	/**
	 * Class constructor
	 * @param parent Instance of a ConveyorTile that is the parent of this
	 * device.
	 * @param X Float number with the coordinate in the x axis for positioning
	 * the device.
	 * @param Y Float number with the coordinate in the y axis for positioning
	 * the device.
	 * @param dir Integer with the facing direction of the device.
	 */
	public function new(parent:ConveyorTile, X:Float, Y:Float, dir:Int=SW) 
	{
		super(parent, X, Y - 15, dir);
        _flipped = false;
		
		var xOffset = TILE_WIDTH / 2;
        var yOffset = TILE_HEIGHT * 1.5;

        // TODO: this moves the hitbox. It sholud be the new origin (position)
        //       of the sprite. But origin in Flixel is used only for rotation.
        //       Best approach would be create MySprite which extends FlXSprite
        //       and handle offset the way it is needed.
        offset.set(xOffset, yOffset);

        _bodyPiece = new FlxSprite(X - xOffset, Y - yOffset - 15);
        _topPiece = new FlxSprite(X - xOffset, Y - yOffset - 15);
		
		// --------------------------------------------------------------------
		// Attention! The loading of the graph is done at the children classes!
		// --------------------------------------------------------------------

        _bodyPiece.antialiasing = true;
        _topPiece.antialiasing = true;

        _bodyPiece.setFacingFlip(FlxObject.LEFT, false, false);
        _bodyPiece.setFacingFlip(FlxObject.RIGHT, true, false);
        _topPiece.setFacingFlip(FlxObject.LEFT, false, false);
        _topPiece.setFacingFlip(FlxObject.RIGHT, true, false);

		// Set the default facing of the device based on its direction
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
	 * Setter of the property "diretion".
	 * @param value Integer value with the new direction for the device.
	 * @return Integer value with the current direction of the device.
	 */
	override public function set_direction(value:Int):Int {
		super.set_direction(value);
		
		// Set the default sidways direction based on the device direction
		switch (direction) {
            case NE:
                _sideDirection = NW;
            case NW:
                _sideDirection = NE;
            case SW:
                _sideDirection = SE;
            case SE:
                _sideDirection = SW;
            default:
                Log.critical("ERROR: invalid direction (" + direction + ") in FlipableDevice.hx");
        }
		
		return direction;
	}

	/**
	 * Flip the device by changing its sideways direction.
	 */
	public function flipSideDirection():Void {
		//_sideDirection += ((_sideDirection % 2) == 0) ? 1 : -1;
		_sideDirection = (_sideDirection + 2) % 4;

        if (!_flipped) {
            _topPiece.animation.frameIndex++;
        }
        else {
            _topPiece.animation.frameIndex--;
        }
        _flipped = !_flipped;
	}
	
}
