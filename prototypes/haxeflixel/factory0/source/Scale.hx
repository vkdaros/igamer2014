package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;

import Constants.*;
import Device;
import IceCream;

class Scale extends FlipableDevice {
    // When _deviate is false, this device doesn't change parents tile behavior.
    // When it is true, the ice cream is sent to sideDirection output.
    private var _deviate:Bool;

	/** Target weight for the scale to let a product pass through it. */
	public var target(default, set):Int;
	
	/**
	 * Setter of the target property.
	 * @param value Integer value with the new target for the scale, in the
	 * range [MIN_SCALE_VALUE, MAX_SCALE_VALUE].
	 * @return Integer with the new value for the scale target.
	 */
	public function set_target(value:Int):Int {
		if (value >= MIN_SCALE_VALUE && value <= MAX_SCALE_VALUE) {
			target = value;
		}
		return target;
	}
	
    public function new(parent:ConveyorTile, X:Float, Y:Float, dir:Int = SW) {
        super(parent, X, Y, dir);

        _deviate = true;

        // loadGraphic(PATH, ANIMATED, FRAME_WIDTH, FRAME_HEIGHT)
        _bodyPiece.loadGraphic("assets/images/switch_body.png", true,
                               TILE_WIDTH, 2 * TILE_FRAME_HEIGHT);
        _topPiece.loadGraphic("assets/images/scale_top.png", true, TILE_WIDTH,
                               2 * TILE_FRAME_HEIGHT);
							   
		target = MIN_SCALE_VALUE;
    }

    override public function transformIceCream(item:IceCream):Void {
        if (item == null) {
            trace("NUL item");
            return;
        }
        _deviate = false;
        if (item.stackSize() < target) {
            _deviate = true;
        }

        if (_deviate) {
            item.direction = _sideDirection;
        }
    }

    override public function onUp(sprite:FlxSprite):Void {
        showPopup(new ScalePopup(this));
    }

    override public function destroy():Void {
        _bodyPiece.destroy();
        _topPiece.destroy();
        super.destroy();
    }
}
