package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxObject;
import flixel.util.FlxColor;
import flixel.plugin.MouseEventManager;

import Constants.*;
import PlayState;
import IceCream;
import Cup;
import Device;
import Doser;
import Scale;

class ConveyorTile extends FlxSprite {
    private var _direction:Int;
    private var _rolling:Bool;
    private var _type:Int;

    // When the tile is the end of conveyor belt, it has to handle ice creams in
    // a different way.
    private var _isEnd:Bool;
    private var _truck:FlxSprite;

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
    private var _addIceCream:IceCream->Void;
    private var _addDevice:Device->Void;
    private var _addSprite:FlxSprite->Void;

    private var _device:Device;
    private var _item:IceCream;

    /**
     * Position i,j with respect of tile grid. The screen coordinates x,y will
     * be calculated automaticaly latter in init();
     */
    public function new(I:Int, J:Int, type:Int, grid:Array<Array<ConveyorTile>>,
                        direction:Int = SW, animationFrames:Array<Int> = null,
                        addIceCreamCallback:IceCream->Void = null,
                        addDeviceCallback:Device->Void = null,
                        addSpriteCallback:FlxSprite->Void = null) {

        super(0, 0);
        init(I, J, type, grid, direction, animationFrames, addIceCreamCallback,
             addDeviceCallback, addSpriteCallback);
    }

    public function init(I:Int, J:Int, type:Int,
                         grid:Array<Array<ConveyorTile>>, direction:Int = SW,
                         animationFrames:Array<Int> = null,
                         addIceCreamCallback:IceCream->Void = null,
                         addDeviceCallback:Device->Void = null,
                         addSpriteCallback:FlxSprite->Void = null) {
        i = I;
        j = J;
        _grid = grid;
        _direction = direction;
        _type = type;
        _isEnd = false;
        _retryDeliver = false;
        _addIceCream = addIceCreamCallback;
        _addDevice = addDeviceCallback;
        _addSprite = addSpriteCallback;

        x = (TILE_WIDTH / 2.0) * (j - i) + X_OFFSET;
        y = (i + j) * (TILE_HEIGHT / 2.0) + Y_OFFSET;

        // TODO: this moves the hitbox. It sholud be the new origin (position)
        //       of the sprite. But origin in Flixel is used only for rotation.
        //       Best approach would be create MySprite which extends FlXSprite
        //       and handle offset the way it is needed.
        offset.set(TILE_WIDTH / 2.0, TILE_HEIGHT / 2.0);

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

        setDirectionTarget(_direction);
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
            if (_device != null) {
                _device.turnOn();
            }
        }
    }

    public function turnOff():Void {
        if (_rolling) {
            _rolling = false;
            animation.pause();
            if (_device != null) {
                _device.turnOff();
            }
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
            _item.direction = _direction;
        }
    }

    public function deliverIceCream():Void {
        if (_item == null) {
            // No ice cream to deliver.
            _retryDeliver = false;
            return;
        }

        // If there is a device in this tile, it transforms ice cream (once).
        if (_device != null && !_retryDeliver) {
            _device.transformIceCream(_item);
        }

        // If this tile is the end of conveyor belt, item goes to the truck.
        if (_isEnd) {
            // 'Show' the ice cream to PlayState and let that class decided if
            // it is the end of the game or if the game should continue.
            // PlayState.validateResult(_item);
            _item.destroy();
            if (_truck != null) {
                _truck.animation.play("jump");
            }
            releaseIceCream();
            return;
        }

        var neighbor = getNeighbor(_item.direction);

        // If target is out of grid, or a hidden tile or is the currnent tile,
        // then the item can't go anywhere.
        if (neighbor == null || !neighbor.active || neighbor == this ||
            (_targetI == i && _targetJ == j)) {
                _item.setShaking(true);
        }
        else {
            // If the target is ok but is not empty, then the item must wait.
            if (!neighbor.isEmpty()) {
                _item.setShaking(true);
                _retryDeliver = true;
            }
            else {
                // If everything is ok, then the item can go to next tile.
                _retryDeliver = false;
                _item.setShaking(false);
                _item.setTarget(getNeighbor(_item.direction));
                releaseIceCream();
            }
        }
    }

    public function releaseIceCream():Void {
        _item = null;
    }

    /**
     * Function called by devices when they are destroying themselves.
     */
    public function removeDevice():Void {
        _device = null;
    }

    private function isValidPosition(I:Int, J:Int):Bool {
        if (I < 0 || J < 0 || I >= _grid.length || J >= _grid[0].length) {
            return false;
        }
        return true;
    }

    private function onUp(sprite:FlxSprite):Void {
        var item = PlayState.selectedItem;

        // TODO:
        // This conditional is temporary and just for testing.
        // When there is only devices in menu, this if() should be removed.
        if (item == CUP || item == BOX) {
            addIceCream(item);
            return;
        }
        addDevice(item);
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

    public function addDevice(type:Int):Void {
        // Only accept a new device when conveyor doesn't have one and the
        // factory is stopped.
        if (_device == null && !_rolling) {
            switch (type) {
                case DOSER:
                    _device = new Doser(this, x, y, _direction);
                case DISPENSER:
                    _device = new Dispenser(this, x, y, _direction);
                case SWITCH:
                    _device = new Switch(this, x, y, _direction);
                case SCALE:
                    _device = new Scale(this, x, y, _direction);
            }
            _addDevice(_device);
        }
    }

    public function addIceCream(type:Int):Void{
        // Only accept a new ice cream when conveyor is empty and the factory is
        // running.
        if (isEmpty() && _rolling) {
            var iceCream:IceCream;
            switch (type) {
                case CUP:
                    iceCream = new Cup(i, j);
                default:
                    iceCream = null;
            }
            receiveIceCream(iceCream);
            deliverIceCream();
            _addIceCream(iceCream);
        }
    }

    public function setDirection(direction:Int):Void {
        _direction = direction;
    }

    private function setDirectionTarget(direction:Int):Void {
        _targetI = i;
        _targetJ = j;

        switch (direction) {
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

    private function getNeighbor(direction:Int):ConveyorTile {
        var neighborI = i;
        var neighborJ = j;

        switch (direction) {
            case NE:
                neighborI--;
            case NW:
                neighborJ--;
            case SW:
                neighborI++;
            case SE:
                neighborJ++;
        }

        if (!isValidPosition(neighborI, neighborJ)) {
            return null;
        }
        return _grid[neighborI][neighborJ];
    }

    public function setIsEnd(isEnd:Bool):Void {
        _isEnd = isEnd;
        _truck = new FlxSprite(x, y);
        _truck.loadGraphic("assets/images/truck.png", true, TRUCK_FRAME_WIDTH,
                           TRUCK_FRAME_HEIGHT);
        _truck.antialiasing = true;

        _truck.setFacingFlip(FlxObject.LEFT, false, false);
        _truck.setFacingFlip(FlxObject.RIGHT, true, false);

        if (_direction == SW || _direction == NW) {
            _truck.facing = FlxObject.LEFT;
            _truck.offset.set(TRUCK_FRAME_WIDTH - TRUCK_X_OFFSET,
                              TRUCK_Y_OFFSET);
        }
        else {
            _truck.facing = FlxObject.RIGHT;
            _truck.offset.set(TRUCK_X_OFFSET, TRUCK_Y_OFFSET);
        }
        _truck.animation.destroyAnimations();
        _truck.animation.add("idle", [0], 1, false);
        _truck.animation.add("jump", [0, 1, 2, 3, 4], 10, false);
        _truck.animation.play("jump");
        _addSprite(_truck);
    }

    override public function destroy():Void {
        MouseEventManager.remove(this);
        super.destroy();
    }
}
