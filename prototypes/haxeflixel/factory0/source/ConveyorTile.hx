package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxObject;

import Constants.*;
import BoxTile;

class ConveyorTile extends FlxSprite {
    private var _direction:Int;
    private var _box:BoxTile;
    private var _rolling:Bool;
    private var _type:Int;

    // Tile grid used to communicate to neighbor tiles.
    private var _grid:Array<Array<ConveyorTile>>;

    // Coordenates to next tile following _direction.
    private var _targetI:Int;
    private var _targetJ:Int;

    // Coordinates in tile matrix.
    public var i:Int;
    public var j:Int;

    /**
     * Position i,j with respect of tile grid. The screen coordinates x,y will
     * calculated automaticaly.
     */
    public function new(I:Int, J:Int, type:Int, grid:Array<Array<ConveyorTile>>,
                        direction:Int = SW) {
        i = I;
        j = J;
        _grid = grid;
        _direction = direction;
        _type = type;

        var xOffset = FlxG.width / 2;
        var yOffset = TILE_HEIGHT / 2;
        var x = (TILE_WIDTH / 2) * (j - i) + xOffset;
        var y = (i + j) * (TILE_HEIGHT / 2) + yOffset;

        super(x, y);
        offset.set(TILE_WIDTH / 2, TILE_HEIGHT / 2);

        // loadGraphic(PATH, ANIMATED, FRAME_WIDTH, FRAME_HEIGHT)
        loadGraphic("assets/images/conveyor.png", true, TILE_FRAME_WIDTH,
                    TILE_FRAME_HEIGHT);

        setFacingFlip(FlxObject.LEFT, false, false);
        setFacingFlip(FlxObject.RIGHT, true, false);
        facing = FlxObject.LEFT;

        _rolling = false;
        setTile(direction, _type);
    }

    public function setTile(direction:Int, type:Int):Void {
        _type = type;
        setDirection(direction);
        initAnimations(_type);
    }

    private function initAnimations(type:Int):Void {
        animation.destroyAnimations();

        // animation.add(NAME, FRAMES, FRAME_RATE, SHOULD_LOOP)
        animation.add("idle", [type * 4], 1, false);

        if (type == GROUND) {
            _rolling = false;
        }
        else {
            _rolling = true;
            var frames = [for (f in 0...4) f + type * 4];
            animation.add("roll", frames, 4, true);
        }

        if (_rolling) {
            animation.play("roll");
        }
        else {
            animation.play("idle");
        }
    }

    private function setDirection(direction:Int):Void {
        _direction = direction;

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

    override public function update():Void {
        super.update();
    }

    public function powerSwitch(on:Bool):Void {
        if (on && !_rolling) {
            animation.play("rolling");
            _box.moving = true;
        }
        else if (!on && _rolling) {
            animation.play("idle");
            _box.moving = false;
        }
    }

    public function receiveBox(box:BoxTile):Void {
        _box = box;
        _box.setGridPosition(i, j);
        if (isValidPosition(_targetI, _targetJ)) {
            _box.moving = _rolling;
            _box.setTarget(_grid[_targetI][_targetJ]);
        }
        else {
            _targetI = i;
            _targetJ = j;
            _box.moving = false;
        }
    }

    private function isValidPosition(I:Int, J:Int):Bool {
        if (I < 0 || J < 0 || I >= _grid.length || J >= _grid[0].length) {
            trace("INVALID");
            return false;
        }
        return true;
    }
}
