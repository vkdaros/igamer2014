package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;

import Constants.*;
import Device;
import IceCream;

class Doser extends Device {
    private var _flavor:Int;

    public function new(parent:ConveyorTile, X:Float, Y:Float,
                        direction:Int = SW, flavor:Int = 4) {
        super(parent, X, Y - 15, direction);
        _flavor = flavor;

        var xOffset = TILE_WIDTH / 2;
        var yOffset = TILE_HEIGHT * 1.5;

        // TODO: this moves the hitbox. It sholud be the new origin (position)
        //       of the sprite. But origin in Flixel is used only for rotation.
        //       Best approach would be create MySprite which extends FlXSprite
        //       and handle offset the way it is needed.
        offset.set(xOffset, yOffset);

        _bodyPiece = new FlxSprite(X - xOffset, Y - yOffset - 15);
        _topPiece = new FlxSprite(X - xOffset, Y - yOffset - 15);

        // loadGraphic(PATH, ANIMATED, FRAME_WIDTH, FRAME_HEIGHT)
        _bodyPiece.loadGraphic("assets/images/device_support.png", true,
                               TILE_WIDTH, 2 * TILE_FRAME_HEIGHT);
        _topPiece.loadGraphic("assets/images/doser_top.png", true, TILE_WIDTH,
                               2 * TILE_FRAME_HEIGHT);

        _bodyPiece.antialiasing = true;
        _topPiece.antialiasing = true;

        _bodyPiece.setFacingFlip(FlxObject.LEFT, false, false);
        _bodyPiece.setFacingFlip(FlxObject.RIGHT, true, false);
        _topPiece.setFacingFlip(FlxObject.LEFT, false, false);
        _topPiece.setFacingFlip(FlxObject.RIGHT, true, false);

        if (_direction == SW || _direction == NE) {
            _bodyPiece.facing = FlxObject.LEFT;
            _topPiece.facing = FlxObject.LEFT;
        }
        else {
            _bodyPiece.facing = FlxObject.RIGHT;
            _topPiece.facing = FlxObject.RIGHT;

        }

        //initAnimations();
    }

/*
    private function initAnimations():Void {
        animation.destroyAnimations();

        var firstFrame = 0;
        if (_direction == SE || _direction == NE) {
            //facing = FlxObject.RIGHT;
            firstFrame = 4;
        }

        // animation.add(NAME, FRAMES, FRAME_RATE, SHOULD_LOOP)
        animation.add("idle", [firstFrame], 1, false);
        animation.play("idle");
    }
*/

    override public function transformIceCream(item:IceCream):Void {
        if (item == null) {
            return;
        }

        // Add a new ball to the ice cream stack.
        item.stackPiece(_flavor);
    }

    public function setFlavor(flavor:Int):Void {
        _flavor = flavor;
    }

    override public function destroy():Void {
        _bodyPiece.destroy();
        _topPiece.destroy();
        super.destroy();
    }

    /**
     * Handler of the mouse up event for the device. It handles the event for
     * both the body and the top sprites.
     * @param sprite FlxSprite with the sprite for which the mouse event
     * occurred.
     */
    override public function onUp(sprite:FlxSprite):Void {
        FlxG.state.openSubState(new DoserPopup(this));
    }
}
