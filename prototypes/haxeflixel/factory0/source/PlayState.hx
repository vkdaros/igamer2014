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

import openfl.Assets;

import ConveyorTile;
import BoxTile;
import Constants.*;
import TiledHelper;

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
        //initConveyor();

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
        var jsonFile = Assets.getText("assets/maps/test03.json");
        var map:TiledMap = haxe.Json.parse(jsonFile);
        var dataArray:Array<Float> = null;

        for (layer in map.layers) {
            if (layer.type == "tilelayer") {
                dataArray = layer.data;
            }
        }
        if (dataArray == null) {
            trace("ERROR: couldn't find tile layer.");
            return;
        }

        var animationMap:Map<Int, Array<Int>> = getAnimationMap(map);

        for (i in 0...map.height) {
            _tileGrid.push([]);
            for (j in 0...map.width) {
                var tileType = dataArray[i * map.width + j];
                var tileDirection = SW;

                if (tileType > TILED_X_FLIP) {
                    tileType -= TILED_X_FLIP;
                    tileDirection = SE;
                }
                if (tileType > TILED_Y_FLIP) {
                    tileType -= TILED_Y_FLIP;
                }

                var tile = new ConveyorTile(i, j, Std.int(tileType), _tileGrid,
                                            tileDirection,
                                            animationMap[Std.int(tileType)]);
                _tileGrid[i].push(tile);
                _conveyorBelt.add(tile);
            }
        }
    }

    private function getAnimationMap(map:TiledMap):Map<Int, Array<Int>> {
        var dataArray:Array<Float> = null;
        for (layer in map.layers) {
            if (layer.type == "tilelayer") {
                dataArray = layer.data;
            }
        }

        var animationMap = new Map<Int, Array<Int>>();

        // First, add all tiles as they are not animated.
        for (tileID in dataArray) {
            if (tileID > TILED_X_FLIP) {
                tileID -= TILED_X_FLIP;
            }
            if (tileID > TILED_Y_FLIP) {
                tileID -= TILED_Y_FLIP;
            }
            var frames = new Array<Int>();
            frames.push(Std.int(tileID) - 1);
            animationMap[Std.int(tileID)] = frames;
        }

        for (set in map.tilesets) {
            var idOffset = set.firstgid;
            for (key in Reflect.fields(set.tiles)) {
                var floatID = Std.parseFloat(key) + idOffset;

                var tiledAnimation:TiledAnimation = Reflect.field(set.tiles,
                                                                  key);

                var frames = new Array<Int>();
                for (frame in tiledAnimation.animation) {
                    frames.push(frame.tileid + idOffset - 1);
                }

                animationMap[Std.int(floatID)] = frames;
            }
        }
        return animationMap;
    }
}
