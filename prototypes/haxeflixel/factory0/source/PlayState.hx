package;

import flash.Lib;
import flash.events.Event;
import flash.events.KeyboardEvent;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.ui.FlxButton;
import flixel.addons.ui.FlxUIState;
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
import StageSelectState;
import DevicePopup;
import ConveyorTile;
import TiledHelper;

/**
 * A FlxState which can be used for the actual gameplay.
 */
class PlayState extends FlxUIState {
    // This indicates what was the last selectiom from menu.
    public static var selectedItem:Int;

    private var _tileGrid:Array<Array<ConveyorTile>>;

    // Map of <stage index, path to stage file>.
    private var _stageMap:Map<Int, String>;
    private var _stageIndex:Int;

    // Layers to be added in current state.
    private var _conveyorLayer:FlxTypedGroup<ConveyorTile>;
    private var _onConveyorLayer:FlxSpriteGroup;
    private var _overConveyorLayer:FlxSpriteGroup;
    private var _uiLayer:FlxGroup;

    // Helper groups to access different kinds of objects easier.
    private var _iceCreams:FlxSpriteGroup;
    private var _devices:FlxSpriteGroup;

    private var _playButton:FlxButton;
    private var _stopButton:FlxButton;
    private var _resetButton:FlxButton;
    private var _exitButton:FlxButton;
    private var _isPlaying:Bool;

    // Flag to resort draw order.
    private var _resort:Bool;

    // Scale modes.
    private var fill:FillScaleMode;
    private var ratio:RatioScaleMode;
    private var relative:RelativeScaleMode;
    private var fixed:FixedScaleMode;

    public function new(index:Int) {
        super();
        _stageIndex = index;
    }

    /**
     * Function that is called up when to state is created to set it up.
     */
    override public function create():Void {
        initScaleMode();
        initFireTongue();
        selectedItem = DOSER;
        _isPlaying = false;

        // Add background image.
        add(new FlxSprite(0, 0, "assets/images/bg_debug2.png"));

        super.create();

        // Plugin needed to detect when player clicks on a sprite.
        FlxG.plugins.add(new MouseEventManager());

        // Create current level from a Tiled file.
        initStageMap();
        initTileGrid();
        add(_conveyorLayer);

        // Objects created outside PlayState class.
        _iceCreams = new FlxSpriteGroup();
        _devices = new FlxSpriteGroup();
        _onConveyorLayer = new FlxSpriteGroup();
        _overConveyorLayer = new FlxSpriteGroup();
        add(_onConveyorLayer);
        add(_overConveyorLayer);

        _uiLayer= createUI();
        add(_uiLayer);

        initEventListener();
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
        // Remove listener before switch to other state.
        Lib.current.stage.removeEventListener(KeyboardEvent.KEY_UP, onUp);

        super.destroy();
    }

    /**
     * Function that is called once every frame.
     */
    override public function update():Void {
        if (_resort || _isPlaying) {
            _onConveyorLayer.sort(sortByXY);
            _resort = false;
        }
        super.update();
    }

    private function initStageMap():Void {
        _stageMap = new Map<Int, String>();
        _stageMap[0] = "assets/maps/stage00.json";
        _stageMap[1] = "assets/maps/stage01.json";
        _stageMap[2] = "assets/maps/stage02.json";
        _stageMap[3] = "assets/maps/stage03.json";
    }

    /**
     * Open Tiled file and fill tileGrid and conveyorLayer.
     */
    public function initTileGrid():Void {
        var jsonFile = Assets.getText(_stageMap[_stageIndex]);
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

        _resetButton = new FlxButton(70, 20, null, resetCallback);
        _resetButton.loadGraphic("assets/images/button_reset.png", true, 50, 50);
        _resetButton.antialiasing = true;

        _exitButton = new FlxButton(120, 20, null, exitCallback);
        _exitButton.loadGraphic("assets/images/button_exit.png", true, 50, 50);
        _exitButton.antialiasing = true;

        ui.add(_playButton);
        ui.add(_stopButton);
        ui.add(_resetButton);
        ui.add(_exitButton);
        _stopButton.kill();
        return ui;
    }

    // Callback function called when play/stop button is pressed.
    public function buttonCallback():Void {
        if (!_isPlaying) {
            // Start the factory.
            _playButton.kill();
            _resetButton.kill();
            _stopButton.revive();

            // Turn on all conveyors.
            for (conveyor in _conveyorLayer) {
                conveyor.turnOn();
            }
        } else {
            // Stop the factory.
            _playButton.revive();
            _resetButton.revive();
            _stopButton.kill();

            // Remove all ice creams and turn off all conveyors.
            for (conveyor in _conveyorLayer) {
                conveyor.releaseIceCream();
                conveyor.turnOff();
            }
            for (icecream in _iceCreams.group) {
                icecream.destroy();
                // FIXME: We have to remove all ice creams from _onConveyorLayer
            }
        }
        _isPlaying = !_isPlaying;
    }

    /**
     * Remove all devices player has put in the factory.
     */
    public function resetCallback():Void {
        openSubState(new DevicePopup());
        _devices.callAll("destroy");
        _devices.clear();

        // It is ok to clear this group because no ice cream should exist when
        // the factory is not running.
        _onConveyorLayer.clear();

        // It is ok to clear this group because only top devices should be here.
        _overConveyorLayer.clear();
    }

    /**
     * Return to menu.
     */
    public function exitCallback():Void {
        FlxG.switchState(new StageSelectState());
    }

    /**
     * Calback functions passed to other classes such as ConveyorTile.
     */
    public function addIceCream(iceCream:IceCream):Void {
        _resort = true;
        _onConveyorLayer.add(iceCream);
        _iceCreams.add(iceCream);
    }

    public function addDevice(device:Device):Void {
        _resort = true;
        _onConveyorLayer.add(device.getBodyPiece());
        _overConveyorLayer.add(device.getTopPiece());
        _devices.add(device);

        _overConveyorLayer.sort(sortByXY);
    }

    private function sortByXY(order:Int, s1:FlxSprite, s2:FlxSprite):Int {
        var result:Int = 0;
        // Sprite with smaller y is drawn first.
        if (s1.y < s2.y) {
            result = order;
        }
        else if (s1.y > s2.y) {
            result = -order;
        }
        else {
            // When both sprites has the same y, the one with greater x must be
            // drawn first.
            if (s1.x > s2.x) {
                result = order;
            }
            else if (s1.x < s2.y) {
                result = -order;
            }
        }

        return result;
    }

    /**
     * Remove existing key up listener and add a new one.
     */
    private function initEventListener():Void {
        if (Lib.current.stage.hasEventListener(KeyboardEvent.KEY_UP)) {
            Lib.current.stage.removeEventListener(KeyboardEvent.KEY_UP, onUp);
        }
        Lib.current.stage.addEventListener(KeyboardEvent.KEY_UP, onUp);
    }

    /**
     * Called whenever a key from keyboard or moble device is released.
     * If the key is ESCAPE, go back to menu state.
     */
    public function onUp(event:KeyboardEvent):Void {
        // Get ESCAPE from keyboard or BACK from android.
        if (event.keyCode == 27) {
            #if android
            event.stopImmediatePropagation();
            #end
            exitCallback();
        }
    }
}
