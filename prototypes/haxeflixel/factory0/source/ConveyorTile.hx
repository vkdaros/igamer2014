package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxObject;

import Constants.*;

class ConveyorTile extends FlxSprite {
    private var _direction: Int;

    /**
     * Position i,j with respect of tile grid. The screen coordinates x,y will
     * calculated automaticaly.
     */
    public function new(i:Int, j:Int, type:Int, direction:Int = SW) {
        var xOffset = FlxG.width / 2;
        var yOffset = TILE_HEIGHT / 2;
        var x = (TILE_WIDTH / 2) * (j - i) + xOffset;
        var y = (i + j) * (TILE_HEIGHT / 2) + yOffset;

        super(x, y);
        offset.set(TILE_WIDTH / 2, TILE_HEIGHT / 2);

        // loadGraphic(PATH, ANIMATED, FRAME_WIDTH, FRAME_HEIGHT)
        loadGraphic("assets/images/conveyor.png", true, TILE_FRAME_WIDTH,
                    TILE_FRAME_HEIGHT);

        setFacingFlip(FlxObject.LEFT, false, false);
        setFacingFlip(FlxObject.RIGHT, true, false);

        // animation.add(NAME, FRAMES, FRAME_RATE, SHOULD_LOOP)
        var frames = [for (f in 0...4) f + type * 4];
        animation.add("roll", frames, 4, true);
        animation.play("roll");

        facing = FlxObject.LEFT;
        if (direction == SE || direction == NE) {
            facing = FlxObject.RIGHT;
        }
    }

    override public function update():Void {
        super.update();
    }
}
