package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.text.FlxText;

import Constants;

class ConveyorTile extends FlxSprite {
    /**
     * Position i,j with respect of tile grid. The screen coordinates x,y will
     * calculated automaticaly.
     */
    public function new(i:Int, j:Int, type:Int) {
        var xOffset = (FlxG.width / 2) - (Constants.TILE_WIDTH / 2);
        var x = (Constants.TILE_WIDTH / 2) * (j - i) + xOffset;
        var y = (i + j) * (Constants.TILE_HEIGHT / 2);

        super(x, y);

        // loadGraphic(PATH, ANIMATED, FRAME_WIDTH, FRAME_HEIGHT)
        loadGraphic("assets/images/conveyor.png", true,
                     Constants.TILE_FRAME_WIDTH, Constants.TILE_FRAME_HEIGHT);

        // animation.add(NAME, FRAMES, FRAME_RATE, SHOULD_LOOP)
        var frames = [for (f in 0...4) f + type * 4];
        animation.add("roll", frames, 4, true);
        animation.play("roll");
    }

    override public function update():Void {
        super.update();
    }
}
