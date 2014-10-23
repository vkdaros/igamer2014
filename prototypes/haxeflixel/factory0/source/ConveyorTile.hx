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
        // TODO: calculate the right position.
        super(100, 100);

        // loadGraphic(PATH, ANIMATED, FRAME_WIDTH, FRAME_HEIGHT)
        loadGraphic("assets/images/conveyor.png", true, Constants.TILE_WIDTH,
                                                        Constants.TILE_HEIGHT);

        // animation.add(NAME, FRAMES, FRAME_RATE, SHOULD_LOOP)
        animation.add("roll", [0, 1, 2, 3], 4, true);
        animation.play("roll");
    }

    override public function update():Void {
        super.update();
    }
}
