package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.group.FlxSpriteGroup;
import flixel.plugin.MouseEventManager;

import Constants.*;

class SlideMenu extends FlxSpriteGroup {
    private var _isHidden:Bool; // When true, the menu is contracted/hidden.
    private var _overMenuItem:Bool;
    private var _background:FlxSprite;
    private var _tween:FlxTween;

    public function new() {
        super(FlxG.width - SLIDE_MENU_MARGIN, SLIDE_MENU_Y);

        // Position of all sprites inside this group will be relative to group's
        // coordinates.
        _background = new FlxSprite(0, 0);
        _background.makeGraphic(SLIDE_MENU_WIDTH, FlxG.height,
                                SLIDE_MENU_COLOR);
        _isHidden = true;
        _overMenuItem = false;

        // Setup the mouse events
        // add(SPRITE, ON_MOUSE_DOWN, ON_MOUSE_UP, ON_MOUSE_OVER, ON_MOUSE_OUT)
        MouseEventManager.add(_background, null, onUp, onOver, onOut);

        add(_background);
        addContent();
    }

    private function addContent():Void {
        // Place holder content.
        // TODO: Replace this with the real content.
        var t1 = new FlxSprite(SLIDE_MENU_MARGIN, SLIDE_MENU_MARGIN);
        t1.loadGraphic("assets/images/doser.png", true, TILE_FRAME_WIDTH,
                       2 * TILE_FRAME_HEIGHT);
        t1.antialiasing = true;
        add(t1);

        var t2 = new FlxSprite(SLIDE_MENU_MARGIN, 3 * TILE_FRAME_HEIGHT);
        t2.loadGraphic("assets/images/box.png", true, TILE_FRAME_WIDTH,
                       TILE_FRAME_HEIGHT);
        t2.antialiasing = true;
        add(t2);

        var itemOnUp = function(s:FlxSprite):Void {
            trace("Click on menu item");
        }
        var itemOnOver = function(s:FlxSprite):Void {
            _overMenuItem = true;
        }
        var itemOnOut = function(s:FlxSprite):Void {
            _overMenuItem = false;
        }
        MouseEventManager.add(t1, null, itemOnUp, itemOnOver, itemOnOut);
        MouseEventManager.add(t2, null, itemOnUp, itemOnOver, itemOnOut);
    }

    private function onUp(sprite:FlxSprite):Void {
        if (_isHidden) {
            slideOut();
        } else {
            slideIn();
        }
    }

    private function onOver(sprite:FlxSprite):Void {
        // If onOver is called while tween is waiting its delay, cancel slideIn.
        if (_tween != null && !_overMenuItem && !_isHidden &&
            _tween.percent <= 0) {

            _tween.cancel();
        }
    }

    private function onOut(sprite:FlxSprite):Void {
        if (!_overMenuItem) {
            slideIn(0.25);
        }
    }

    override public function update():Void {
        super.update();
    }

    override public function destroy():Void {
        MouseEventManager.remove(_background);
        super.destroy();
    }

    public function isHidden():Bool{
        return _isHidden;
    }

    public function slideOut(delay:Float = 0.0):Void {
        if (!_isHidden) {
            return;
        }

        var options = {
            type: FlxTween.ONESHOT,
            startDelay: delay,
            loopDelay: null,
            ease: FlxEase.quintOut,
            complete: function(t: FlxTween) {_isHidden = false;}
        }
        _tween = FlxTween.linearMotion(this, x, y, SLIDE_MENU_X, SLIDE_MENU_Y,
                                       SLIDE_MENU_DURATION, true, options);
    }

    public function slideIn(delay:Float = 0.0):Void {
        // If it is already hidden or sliding, do nothing.
        if (_isHidden || _tween.active) {
            return;
        }

        var options = {
            type: FlxTween.ONESHOT,
            startDelay: delay,
            loopDelay: null,
            ease: FlxEase.quintOut,
            complete: function(t: FlxTween) {_isHidden = true;}
        }
        _tween = FlxTween.linearMotion(this, x, y,
                                       FlxG.width - SLIDE_MENU_MARGIN,
                                       SLIDE_MENU_Y, SLIDE_MENU_DURATION, true,
                                       options);
    }
}
