package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.tweens.FlxTween;

import Constants.*;

class IceCream extends FlxSpriteGroup {
    // Coordinates in tile matrix.
    public var i:Int;
    public var j:Int;
    public var direction:Int;

    private var _shaking:Bool;
    private var _tween:FlxTween;

    // Stack of ice cream pieces. The first element is at the bottom of stack.
    // The type of each piece is stored in sprite's id.
    private var _stack:Array<FlxSprite>;

    override public function new(I:Int = 0, J:Int = 0, Direction:Int = SW) {
        i = I;
        j = J;
        direction = Direction;
        _shaking = false;
        _stack = new Array<FlxSprite>();

        var xOffset = FlxG.width / 2;
        var yOffset = TILE_HEIGHT / 2;
        var x = (TILE_WIDTH / 2) * (j - i) + xOffset;
        var y = (i + j) * (TILE_HEIGHT / 2) + yOffset;

        super(x, y);
    }

    public function setGridPosition(I:Int, J:Int):Void {
        i = I;
        j = J;
    }

    public function setTarget(target:ConveyorTile):Void {
        target.receiveIceCream(this);

        var callback:FlxTween->Void = function(tween:FlxTween) {
            target.deliverIceCream();
        }

        var options = {
            type: FlxTween.ONESHOT,
            startDelay: null,
            loopDelay: null,
            ease: null,
            complete: callback
        }

        _tween = FlxTween.linearMotion(this, x, y, target.x, target.y,
                                       BOX_MOVEMENT_DURATION, true, options);
    }

    public function setShaking(isShaking:Bool):Void {
        if (isShaking == _shaking) {
            return;
        }
        _shaking = isShaking;
    }

    public function addToStack(sprite:FlxSprite):Void {
        add(sprite);
        _stack.push(sprite);
    }

    /**
     * Create a new piece of type 'index' and put it on the stack.
     * This function should be overriden.
     */
    public function stackPiece(index:Int):FlxSprite {
        return null;
    }

    public function stackSize():Int {
        return _stack.length;
    }
}
