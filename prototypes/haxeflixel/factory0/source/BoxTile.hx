package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxObject;
import flixel.tweens.FlxTween;

import ConveyorTile;
import Constants.*;

class BoxTile extends FlxSprite {
    private var _direction:Int;

    // Coordinates in tile matrix.
    public var i:Int;
    public var j:Int;

    public var moving:Bool;

    private var _tween:FlxTween;

    /**
     * Position i,j with respect of tile grid. The screen coordinates x,y will
     * calculated automaticaly.
     */
    public function new(I:Int, J:Int, direction:Int = SW) {
        i = I;
        j = J;
        moving = false;

        var xOffset = FlxG.width / 2;
        var yOffset = TILE_HEIGHT / 2;
        var x = (TILE_WIDTH / 2) * (j - i) + xOffset;
        var y = (i + j) * (TILE_HEIGHT / 2) + yOffset;

        super(x, y);
        offset.set(TILE_WIDTH / 2, 45);

        // loadGraphic(PATH, ANIMATED, FRAME_WIDTH, FRAME_HEIGHT)
        loadGraphic("assets/images/box.png", true, TILE_FRAME_WIDTH,
                    TILE_FRAME_HEIGHT);

        setFacingFlip(FlxObject.LEFT, false, false);
        setFacingFlip(FlxObject.RIGHT, true, false);

        // animation.add(NAME, FRAMES, FRAME_RATE, SHOULD_LOOP)
        var frames = [0, 1, 2, 3];
        animation.add("shake", frames, 4, true);
        animation.add("idle", [0], 1, false);
        animation.play("idle");

        facing = FlxObject.LEFT;
        if (direction == SE || direction == NE) {
            facing = FlxObject.RIGHT;
        }
    }

    override public function update():Void {
        super.update();
    }

    public function setGridPosition(I:Int, J:Int):Void {
        i = I;
        j = J;
    }

    public function setTarget(targetTile:ConveyorTile):Void {
        var me = this;
        var callback:FlxTween->Void = function(tween:FlxTween) {
            targetTile.receiveBox(me);
        }

        var options = {
            type: FlxTween.ONESHOT,
            startDelay: null,
            loopDelay: null,
            ease: null,
            complete: callback
        }

        _tween = FlxTween.linearMotion(this, x, y, targetTile.x, targetTile.y,
                                       BOX_MOVEMENT_DURATION, true, options);
    }
}
