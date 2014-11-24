package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxObject;
import flixel.util.FlxColor;
import flixel.plugin.MouseEventManager;

import Constants.*;
import PlayState;
import IceCream;
import Box;
import Cup;
import Device;
import Doser;

class ConveyorTile extends FlxSprite {
    private var _direction:Int;
    private var _rolling:Bool;
    private var _type:Int;

    // When fail to deliver ice cream to next tile, this flag is set to true.
    private var _retryDeliver:Bool;

    // Tile grid used to communicate to neighbor tiles.
    private var _grid:Array<Array<ConveyorTile>>;

    // Coordenates to next tile following _direction.
    private var _targetI:Int;
    private var _targetJ:Int;

    // Coordinates in tile matrix.
    public var i:Int;
    public var j:Int;

    // Callback function to add objects to Playstate.
    private var _addIceCream:FlxSprite->Void;
    private var _addDevice:FlxSprite->Void;

    private var _device:Device;
    private var _item:IceCream;

    /**
     * Position i,j with respect of tile grid. The screen coordinates x,y will
     * be calculated automaticaly latter in init();
     */
    public function new(I:Int, J:Int, type:Int, grid:Array<Array<ConveyorTile>>,
                        direction:Int = SW, animationFrames:Array<Int> = null,
                        addIceCreamCallback:FlxSprite->Void = null,
                        addDeviceCallback:FlxSprite->Void = null) {

        super(0, 0);
        init(I, J, type, grid, direction, animationFrames, addIceCreamCallback,
             addDeviceCallback);
    }

    public function init(I:Int, J:Int, type:Int,
                         grid:Array<Array<ConveyorTile>>, direction:Int = SW,
                         animationFrames:Array<Int> = null,
                         addIceCreamCallback:FlxSprite->Void = null,
                         addDeviceCallback:FlxSprite->Void = null) {
        i = I;
        j = J;
        _grid = grid;
        _direction = direction;
        _type = type;
        _retryDeliver = false;
        _addIceCream = addIceCreamCallback;
        _addDevice = addDeviceCallback;

        var xOffset = FlxG.width / 2;
        var yOffset = TILE_HEIGHT / 2;
        x = (TILE_WIDTH / 2) * (j - i) + xOffset;
        y = (i + j) * (TILE_HEIGHT / 2) + yOffset;

        // TODO: this moves the hitbox. It sholud be the new origin (position)
        //       of the sprite. But origin in Flixel is used only for rotation.
        //       Best approach would be create MySprite which extends FlXSprite
        //       and handle offset the way it is needed.
        offset.set(TILE_WIDTH / 2, TILE_HEIGHT / 2);

        // loadGraphic(PATH, ANIMATED, FRAME_WIDTH, FRAME_HEIGHT)
        loadGraphic("assets/images/conveyor.png", true, TILE_FRAME_WIDTH,
                    TILE_FRAME_HEIGHT);
        antialiasing = true;

        setFacingFlip(FlxObject.LEFT, false, false);
        setFacingFlip(FlxObject.RIGHT, true, false);
        facing = FlxObject.LEFT;

        _rolling = false;
        setTile(direction, _type);
        initAnimations(_type, animationFrames);

        // Setup the mouse events
        // add(SPRITE, ON_MOUSE_DOWN, ON_MOUSE_UP, ON_MOUSE_OVER, ON_MOUSE_OUT)
        MouseEventManager.add(this, null, onUp, onOver, onOut);
    }

    public function setTile(direction:Int, type:Int):Void {
        if (type == HIDDEN) {
            active = visible = false;
        }
        else {
            active = visible = true;
        }

        if (_direction == SE || _direction == NE) {
            facing = FlxObject.RIGHT;
        }

        _targetI = i;
        _targetJ = j;
        if (_type == GROUND) {
            return;
        }

        switch (_direction) {
            case NE:
                _targetI--;
            case NW:
                _targetJ--;
            case SW:
                _targetI++;
            case SE:
                _targetJ++;
        }
    }

    private function initAnimations(type:Int, animationFrames:Array<Int>):Void {
        animation.destroyAnimations();

        if (animationFrames != null) {
            // animation.add(NAME, FRAMES, FRAME_RATE, SHOULD_LOOP)
            animation.add("idle", [animationFrames[0]], 1, false);
            animation.play("idle");

            if (type != HIDDEN && type != GROUND) {
                animation.add("roll", animationFrames, 4, true);
            }
        }
    }

    override public function update():Void {
        if (_retryDeliver) {
            deliverIceCream();
        }
        super.update();
    }

    public function turnOn():Void {
        if (!_rolling) {
            _rolling = true;
            if (animation.paused) {
                animation.resume();
            } else {
                animation.play("roll");
            }
        }
    }

    public function turnOff():Void {
        if (_rolling) {
            _rolling = false;
            animation.pause();
        }
    }

    public function receiveIceCream(item:IceCream):Void {
        if (item == null) {
            trace("Received null ice cream.");
        }
        else if (_item != null) {
            // Should not accept other ice cream.
            item.setShaking(true);
        }
        else {
            // Every thing is fine. Accepting ice cream.
            _item = item;
            _item.setGridPosition(i, j);

            // If there is a device in this tile, it transforms the ice cream.
            if (_device != null) {
                _device.transformIceCream(_item);
            }
        }
    }

    public function deliverIceCream():Void {
        if (_item == null) {
            // No ice cream to deliver.
            _retryDeliver = false;
        }
        else if (isValidPosition(_targetI, _targetJ) &&
                 _grid[_targetI][_targetJ].active &&
                 (_targetI != i || _targetJ != j)) {

            if (_grid[_targetI][_targetJ].isEmpty()) {
                _item.setShaking(false);
                _item.setTarget(_grid[_targetI][_targetJ], this);
                _retryDeliver = false;
            }
            else {
                _item.setShaking(true);
                _retryDeliver = true;
            }
        }
        else {
            //Ice cream reached a dead end. Should go to truck
            //_item.setShaking(true);
        }
    }

    public function releseIceCream():Void {
        _item = null;
    }

    private function isValidPosition(I:Int, J:Int):Bool {
        if (I < 0 || J < 0 || I >= _grid.length || J >= _grid[0].length) {
            return false;
        }
        return true;
    }

    private function onUp(sprite:FlxSprite):Void {
        // FIXME: Draw order of device top piece is wrong.
        //        One way to fix that is to draw top pieces after the others.
        switch (PlayState.mode) {
            case 0:
                // Only accept a new device when conveyor doesn't have one and
                // the factory is stopped.
                if (_device == null && !_rolling) {
                    var newObject = new Doser(x, y, _direction);
                    _addDevice(newObject);
                    _device = newObject;
                }
            case 1:
                // Only accept a new ice cream when conveyor is empty and the
                // factory is running.
                if (isEmpty() && _rolling) {
                    var newObject = new Box(i, j);
                    receiveIceCream(newObject);
                    deliverIceCream();
                    _addIceCream(newObject);
                }
            case 2:
                // Only accept a new ice cream when conveyor is empty and the
                // factory is running.
                if (isEmpty() && _rolling) {
                    var newObject = new Cup(i, j);
                    receiveIceCream(newObject);
                    deliverIceCream();
                    _addIceCream(newObject);
                }
            default:
                trace("Undefined mode - do nothing");
        }
    }

    private function onOver(sprite:FlxSprite):Void {
        color = 0x00FF00;
    }

    private function onOut(sprite:FlxSprite):Void {
        color = FlxColor.WHITE;
    }

    public function isEmpty():Bool {
        return (_item == null);
    }

    override public function destroy():Void {
        MouseEventManager.remove(this);
        super.destroy();
    }
}
