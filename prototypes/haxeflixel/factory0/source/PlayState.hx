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

// WIP: verificar se mudando o offset, a caixa de colisao nao estraga;
//      Mover o offset para o ponto "base" do tile
//      Colocar uma caixa na esteira.

        if (Main.tongue == null) {
            Main.tongue = new FireTongueEx();
            Main.tongue.init("en-US");
            FlxUIState.static_tongue = Main.tongue;
        }
        super.create();
        add(new FlxText(50, 50, 100, "Play Scene"));

        _tileGrid = new Array<Array<ConveyorTile>>();
        _conveyorBelt = new FlxGroup();
        for (i in 0...4) {
            _tileGrid.push([]);
            for (j in 0...4) {
                var tile = new ConveyorTile(i, j, DOWN);
                _tileGrid[i].push(tile);
                _conveyorBelt.add(tile);
            }
        }
        add(_conveyorBelt);
        add(new BoxTile(0, 1));
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
}
