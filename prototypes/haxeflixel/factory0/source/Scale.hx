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

    public function new(parent:ConveyorTile, X:Float, Y:Float, dir:Int = SW) {
        super(parent, X, Y, dir);

        _deviate = true;

        // loadGraphic(PATH, ANIMATED, FRAME_WIDTH, FRAME_HEIGHT)
        _bodyPiece.loadGraphic("assets/images/switch_body.png", true,
                               TILE_WIDTH, 2 * TILE_FRAME_HEIGHT);
        _topPiece.loadGraphic("assets/images/scale_top.png", true, TILE_WIDTH,
                               2 * TILE_FRAME_HEIGHT);
    }

    override public function transformIceCream(item:IceCream):Void {
        if (item == null) {
            trace("NUL item");
            return;
        }
        _deviate = false;
        if (item.stackSize() < 2) {
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
