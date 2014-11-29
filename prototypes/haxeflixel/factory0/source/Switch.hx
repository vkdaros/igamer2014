package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;

import Constants.*;
import Device;
import IceCream;

class Switch extends Device {
    // When _deviate is false, this device doesn't change parents tile behavior.
    // When it is true, the ice cream is sent to sideDirection output.
    private var _deviate:Bool;
    private var _sideDirection:Int;

    // TODO
    private var _flipped:Bool;

    public function new(parent:ConveyorTile, X:Float, Y:Float,
                        direction:Int = SW) {
        super(parent, X, Y - 15, direction);

        _deviate = true;
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

        // loadGraphic(PATH, ANIMATED, FRAME_WIDTH, FRAME_HEIGHT)
        _bodyPiece.loadGraphic("assets/images/switch_body.png", true,
                               TILE_WIDTH, 2 * TILE_FRAME_HEIGHT);
        _topPiece.loadGraphic("assets/images/switch_top.png", true, TILE_WIDTH,
                               2 * TILE_FRAME_HEIGHT);

        _bodyPiece.antialiasing = true;
        _topPiece.antialiasing = true;

        _bodyPiece.setFacingFlip(FlxObject.LEFT, false, false);
        _bodyPiece.setFacingFlip(FlxObject.RIGHT, true, false);
        _topPiece.setFacingFlip(FlxObject.LEFT, false, false);
        _topPiece.setFacingFlip(FlxObject.RIGHT, true, false);

        if (_direction == SW || _direction == NE) {
            _bodyPiece.facing = FlxObject.LEFT;
            _topPiece.facing = FlxObject.LEFT;
        }
        else {
            _bodyPiece.facing = FlxObject.RIGHT;
            _topPiece.facing = FlxObject.RIGHT;

        }

        switch (_direction) {
            case NE:
                _sideDirection = NW;
            case NW:
                _sideDirection = NE;
            case SW:
                _sideDirection = SE;
            case SE:
                _sideDirection = SW;
            default:
                trace("ERROR: invalid direction in Switch.hx");
        }
    }

    override public function transformIceCream(item:IceCream):Void {
        if (item == null) {
            return;
        }

        // Add a new ball to the ice cream stack.
        if (_deviate) {
            _parent.setDirectionTarget(_sideDirection);
        }
        else {
            _parent.setDirectionTarget(_direction);
        }
        _deviate = !_deviate;
    }

    override public function destroy():Void {
        _bodyPiece.destroy();
        _topPiece.destroy();
        super.destroy();
    }
}
