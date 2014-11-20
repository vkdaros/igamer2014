package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxObject;
import flixel.util.FlxColor;
import flixel.plugin.MouseEventManager;

import Constants.*;
import Attachment;
import BoxTile;
import Doser;
import Attachment;

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

    // Callback function to add a box to Playstate.
    private var addToObjectsGroup:FlxSprite->Void;

    // Device (doser, switcher, etc.) attached to conveyor.
    private var _attachment:Attachment;

    /**
     * Position i,j with respect of tile grid. The screen coordinates x,y will
     * calculated automaticaly.
     */
    public function new(I:Int, J:Int, type:Int, grid:Array<Array<ConveyorTile>>,
                        direction:Int = SW, animationFrames:Array<Int> = null,
                        callback:FlxSprite->Void = null) {

        super(x, y);
        init(I, J, type, grid, direction, animationFrames, callback);
    }

    public function init(I:Int, J:Int, type:Int,
                         grid:Array<Array<ConveyorTile>>, direction:Int = SW,
                         animationFrames:Array<Int> = null,
                         callback:FlxSprite->Void = null) {
        i = I;
        j = J;
        _grid = grid;
        _direction = direction;
        _type = type;
        addToObjectsGroup = callback;

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
        MouseEventManager.add(this, onDown, null, onOver, onOut);
    }

    public function setTile(direction:Int, type:Int):Void {
        if (type == HIDDEN) { active = visible = false;
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

        if (animationFrames == null) {
            return;
        }

        // animation.add(NAME, FRAMES, FRAME_RATE, SHOULD_LOOP)
        animation.add("idle", [animationFrames[0]], 1, false);

        // Ops
        _rolling = (type != HIDDEN && type != GROUND);

        if (_rolling) {
            animation.add("roll", animationFrames, 4, true);
            animation.play("roll");
        }
        else {
            animation.play("idle");
        }
    }

    override public function update():Void {
        super.update();
    }

    public function powerSwitch(on:Bool):Void {
        if (on && !_rolling) {
            animation.play("rolling");
        }
        else if (!on && _rolling) {
            animation.play("idle");
        }
    }

    public function receiveBox(box:BoxTile):Void {
        _box = box;
        _box.setGridPosition(i, j);
        if (isValidPosition(_targetI, _targetJ) &&
            _grid[_targetI][_targetJ].active) {

            _box.setTarget(_grid[_targetI][_targetJ]);
            _box.setShaking(false);
        }
        else {
            _targetI = i;
            _targetJ = j;
            _box.setShaking(true);
        }
    }

    private function isValidPosition(I:Int, J:Int):Bool {
        if (I < 0 || J < 0 || I >= _grid.length || J >= _grid[0].length) {
            return false;
        }
        return true;
    }

    private function onDown(sprite:FlxSprite):Void {
        //var box = new BoxTile(i, j);
        //receiveBox(box);
        //addToObjectsGroup(box);

        // FIXME: draw order totally messed up.
        _attachment = new Doser(x, y, _direction);
        addToObjectsGroup(_attachment);
    }

    private function onOver(sprite:FlxSprite):Void {
        color = 0x00FF00;
    }

    private function onOut(sprite:FlxSprite):Void {
        color = FlxColor.WHITE;
    }

    override public function destroy():Void {
        MouseEventManager.remove(this);
        super.destroy();
    }
}
