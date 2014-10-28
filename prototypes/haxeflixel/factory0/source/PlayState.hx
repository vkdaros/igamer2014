package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.ui.FlxUIState;
import flixel.addons.ui.FlxUIText;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;
import flixel.group.FlxGroup;

import flixel.system.scaleModes.FillScaleMode;
import flixel.system.scaleModes.FixedScaleMode;
import flixel.system.scaleModes.RatioScaleMode;
import flixel.system.scaleModes.RelativeScaleMode;

import ConveyorTile;
import BoxTile;
import Constants.*;

/**
 * A FlxState which can be used for the actual gameplay.
 */
class PlayState extends FlxUIState {
    private var _tileGrid:Array<Array<ConveyorTile>>;
    private var _conveyorBelt:FlxGroup;

    private var fill:FillScaleMode;
    private var ratio:RatioScaleMode;
    private var relative:RelativeScaleMode;
    private var fixed:FixedScaleMode;

    /**
     * Function that is called up when to state is created to set it up.
     */
    override public function create():Void {
        fill = new FillScaleMode();
        ratio = new RatioScaleMode();
        relative = new RelativeScaleMode(0.75, 0.75);
        fixed = new FixedScaleMode();

        FlxG.scaleMode = ratio;

        add(new FlxSprite(0, 0, "assets/images/bg_debug2.png"));

        if (Main.tongue == null) {
            Main.tongue = new FireTongueEx();
            Main.tongue.init("en-US");
            FlxUIState.static_tongue = Main.tongue;
        }

        super.create();

        _tileGrid = new Array<Array<ConveyorTile>>();
        _conveyorBelt = new FlxGroup();

        initTileGrid();
        initConveyor();

        add(_conveyorBelt);
        var box = new BoxTile(0, 1);
        _tileGrid[0][1].receiveBox(box);
        add(box);
    }

    /**
     * Function that is called when this state is destroyed - you might want to
     * consider setting all objects this state uses to null to help garbage
     * collection.
     */
    override public function destroy():Void {
        super.destroy();
    }

    /**
     * Function that is called once every frame.
     */
    override public function update():Void {
        super.update();
    }

    public function initTileGrid():Void {
        var max = 5;
        for (i in 0...max) {
            _tileGrid.push([]);
            for (j in 0...max) {
                var tile = new ConveyorTile(i, j, HIDDEN, _tileGrid);
                _tileGrid[i].push(tile);
                _conveyorBelt.add(tile);
            }
        }
    }

    public function initConveyor():Void {
        _tileGrid[0][1].setTile(SW, DOWN);
        _tileGrid[1][1].setTile(SW, DOWN);
        _tileGrid[2][1].setTile(SE, DOWN);
        _tileGrid[2][2].setTile(SE, DOWN);
        _tileGrid[2][3].setTile(SW, DOWN);
        _tileGrid[3][3].setTile(SW, DOWN);
        //_tileGrid[4][3].setTile(SW, DOWN);
    }
}
