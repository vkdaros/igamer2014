package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.ui.FlxButton;
import flixel.addons.ui.FlxUIState;
import flixel.addons.ui.FlxUIText;
import flixel.text.FlxText;
import flixel.util.FlxMath;
import flixel.util.FlxSort;
import flixel.group.FlxGroup;
import flixel.group.FlxTypedGroup;
import flixel.group.FlxSpriteGroup;
import flixel.plugin.MouseEventManager;

import flixel.system.scaleModes.FillScaleMode;
import flixel.system.scaleModes.FixedScaleMode;
import flixel.system.scaleModes.RatioScaleMode;
import flixel.system.scaleModes.RelativeScaleMode;

import openfl.Assets;

import Constants.*;
import ConveyorTile;
import TiledHelper;
import Box;

/**
 * A FlxState which can be used for the actual gameplay.
 */
class PlayState extends FlxUIState {
    private var _tileGrid:Array<Array<ConveyorTile>>;

    // Layers to be added in current state.
    private var _conveyorLayer:FlxTypedGroup<ConveyorTile>;
    private var _onConveyorLayer:FlxSpriteGroup;
    private var _uiLayer:FlxGroup;

    // Helper groups to access different kinds of objects easier.
    private var _iceCreams:FlxSpriteGroup;
    private var _devices:FlxSpriteGroup;

    private var _playButton:FlxButton;
    private var _stopButton:FlxButton;
    private var _isPlaying:Bool;

    // Flag to resort draw order.
    private var _resort:Bool;

    // Scale modes.
    private var fill:FillScaleMode;
    private var ratio:RatioScaleMode;
    private var relative:RelativeScaleMode;
    private var fixed:FixedScaleMode;

    public static var mode:Int;

    /**
     * Function that is called up when to state is created to set it up.
     */
    override public function create():Void {
        initScaleMode();
        initFireTongue();
        mode = 0;
        _isPlaying = false;

        // Add background image.
        add(new FlxSprite(0, 0, "assets/images/bg_debug2.png"));

        super.create();

        // Plugin needed to detect when player clicks on a sprite.
        FlxG.plugins.add(new MouseEventManager());

        // Create current level from a Tiled file.
        initTileGrid();
        add(_conveyorLayer);

        // Objects created outside PlayState class.
        _iceCreams = new FlxSpriteGroup();
        _devices = new FlxSpriteGroup();
        _onConveyorLayer = new FlxSpriteGroup();
        add(_onConveyorLayer);

        _uiLayer= createUI();
        add(_uiLayer);
    }

    private function initScaleMode():Void {
        fill = new FillScaleMode();
        ratio = new RatioScaleMode();
        relative = new RelativeScaleMode(0.75, 0.75);
        fixed = new FixedScaleMode();

        FlxG.scaleMode = ratio;
    }

    /**
     * Get text labels from external files. This avoids hard coded text and
     * allows multi-language support.
     */
    private function initFireTongue():Void {
        if (Main.tongue == null) {
            Main.tongue = new FireTongueEx();
            Main.tongue.init("en-US");
            FlxUIState.static_tongue = Main.tongue;
        }
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
        if (_resort) {
            var sortByXY = function(order:Int, obj1:FlxSprite,
                                    obj2:FlxSprite):Int {
                var xy1 = obj1.y - (2 * obj1.x);
                var xy2 = obj2.y - (2 * obj2.x);

                return FlxSort.byValues(-order, xy1, xy2);
            };
            // FIXME:
            // The sort function should follow (i,j).
            _onConveyorLayer.sort(sortByXY, FlxSort.ASCENDING);
            _resort = false;
        }
        super.update();
    }

    /**
     * Open Tiled file and fill tileGrid and conveyorLayer.
     */
    public function initTileGrid():Void {
        var jsonFile = Assets.getText("assets/maps/test03.json");
        var map:TiledMap = haxe.Json.parse(jsonFile);
        var dataArray:Array<Float> = null;

        _tileGrid = new Array<Array<ConveyorTile>>();
        _conveyorLayer = new FlxTypedGroup<ConveyorTile>();

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
                                            animationMap[Std.int(tileType)],
                                            addIceCream, addDevice);
                _tileGrid[i].push(tile);
                _conveyorLayer.add(tile);
            }
        }
    }

    /**
     * Create a map with animations created in Tiled.
     */
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

    private function createUI():FlxGroup {
        var ui = new FlxGroup();
        ui.add(new SlideMenu());

        _playButton = new FlxButton(20, 20, null, buttonCallback);
        _playButton.loadGraphic("assets/images/button_play.png", true, 50, 50);
        _playButton.antialiasing = true;

        _stopButton = new FlxButton(20, 20, null, buttonCallback);
        _stopButton.loadGraphic("assets/images/button_stop.png", true, 50, 50);
        _stopButton.antialiasing = true;

        ui.add(_playButton);
        ui.add(_stopButton);
        _stopButton.kill();
        return ui;
    }

    // Callback function called when play/stop button is pressed.
    public function buttonCallback():Void {
        if (!_isPlaying) {
            // Start the factory.
            _playButton.kill();
            _stopButton.revive();

            // Turn on all conveyors.
            for (conveyor in _conveyorLayer) {
                conveyor.turnOn();
            }
        } else {
            // Stop the factory.
            _playButton.revive();
            _stopButton.kill();

            // Remove all ice creams and turn off all conveyors.
            for (conveyor in _conveyorLayer) {
                conveyor.releseIceCream();
                conveyor.turnOff();
            }
            for (icecream in _iceCreams.group) {
                icecream.destroy();
            }
        }
        _isPlaying = !_isPlaying;
    }

    /**
     * Calback functions passed to other classes such as ConveyorTile.
     */
    public function addIceCream(sprite:FlxSprite):Void {
        _resort = true;
        _onConveyorLayer.add(sprite);
        _iceCreams.add(sprite);
    }

    public function addDevice(sprite:FlxSprite):Void {
        _resort = true;
        _onConveyorLayer.add(sprite);
        _devices.add(sprite);
    }
}
