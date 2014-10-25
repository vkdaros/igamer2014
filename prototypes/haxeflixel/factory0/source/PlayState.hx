package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.ui.FlxUIState;
import flixel.addons.ui.FlxUIText;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;
import flixel.group.FlxGroup;

import ConveyorTile;
import BoxTile;
import Constants.*;

/**
 * A FlxState which can be used for the actual gameplay.
 */
class PlayState extends FlxUIState {
    private var _tileGrid:Array<Array<ConveyorTile>>;
    private var _conveyorBelt:FlxGroup;

    /**
     * Function that is called up when to state is created to set it up.
     */
    override public function create():Void {
        FlxG.debugger.visible = true;
        FlxG.debugger.drawDebug = true;

        if (Main.tongue == null) {
            Main.tongue = new FireTongueEx();
            Main.tongue.init("en-US");
            FlxUIState.static_tongue = Main.tongue;
        }
        super.create();
        add(new FlxText(50, 50, 100, "Play Scene"));

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
                var tile = new ConveyorTile(i, j, GROUND, _tileGrid);
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
        _tileGrid[4][3].setTile(SW, DOWN);
    }
}
