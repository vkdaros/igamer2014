package;

import flixel.FlxSprite;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.util.FlxTimer;
import flixel.group.FlxSpriteGroup;
import flixel.plugin.MouseEventManager;

import Constants.*;
import PlayState;

class SlideMenu extends FlxSpriteGroup {
    private var _isHidden:Bool; // When true, the menu is contracted/hidden.
    private var _slidingIn:Bool;
    private var _slidingOut:Bool;
    private var _overMenuItem:Bool;

    private var _background:FlxSprite;
    private var _tween:FlxTween;

    public function new() {
        super(GAME_WIDTH - SLIDE_MENU_WIDTH, 0);

        // Position of all sprites inside this group will be relative to group's
        // coordinates.
        _background = new FlxSprite(0, 0, "assets/images/slide_menu3.png");
        _background.antialiasing = true;
        /*
        _background.makeGraphic(SLIDE_MENU_WIDTH, GAME_HEIGHT,
                                SLIDE_MENU_COLOR);
        */
        _isHidden = false;
        _slidingIn = false;
        _slidingOut = false;
        _overMenuItem = false;

        // Setup the mouse events
        // add(SPRITE, ON_MOUSE_DOWN, ON_MOUSE_UP, ON_MOUSE_OVER, ON_MOUSE_OUT)
        MouseEventManager.add(_background, null, onUp, onOver, onOut);

        add(_background);
        addContent();

        // Show the menu for a while and hide it at the beginning of stage.
        var timer = new FlxTimer(1, function(t:FlxTimer):Void{slideIn();});
    }

    private function addContent():Void {
        // TODO: Refactor all this.
        var t1 = new FlxSprite(15 + SLIDE_MENU_MARGIN, 1.5 * TILE_FRAME_HEIGHT);
        t1.loadGraphic("assets/images/doser_top.png", false);
        t1.antialiasing = true;
        add(t1);

        var t2 = new FlxSprite(15 + SLIDE_MENU_MARGIN, t1.y + 1.4 * TILE_FRAME_HEIGHT);
        t2.loadGraphic("assets/images/scale_top.png", true, TILE_FRAME_WIDTH,
                       TILE_FRAME_HEIGHT);
        t2.antialiasing = true;
        add(t2);

/*
        var t3 = new FlxSprite(SLIDE_MENU_MARGIN * 3, 5 * TILE_FRAME_HEIGHT);
        t3.loadGraphic("assets/images/icecream_cup.png", true,
                       ICE_CREAM_FRAME_WIDTH, ICE_CREAM_FRAME_HEIGHT);
        t3.antialiasing = true;
        add(t3);
*/

        var t4 = new FlxSprite(15 + SLIDE_MENU_MARGIN, t2.y + 1.4 * TILE_FRAME_HEIGHT);
        t4.loadGraphic("assets/images/dispenser_top.png", true,
                       TILE_FRAME_WIDTH, TILE_FRAME_HEIGHT);
        t4.antialiasing = true;
        add(t4);

        var t5 = new FlxSprite(15 + SLIDE_MENU_MARGIN, t4.y + 1.4 * TILE_FRAME_HEIGHT);
        t5.loadGraphic("assets/images/switch_top.png", true,
                       TILE_FRAME_WIDTH, TILE_FRAME_HEIGHT);
        t5.antialiasing = true;
        add(t5);

        var onUpFactory = function(index:Int):FlxSprite->Void {
            return function(s:FlxSprite):Void {
                slideIn();
                PlayState.selectedItem = index;
            };
        }

        var itemOnOver = function(s:FlxSprite):Void {
            _overMenuItem = true;
        }

        var itemOnOut = function(s:FlxSprite):Void {
            _overMenuItem = false;
        }
        MouseEventManager.add(t1, null, onUpFactory(DOSER), itemOnOver,
                              itemOnOut);
        MouseEventManager.add(t2, null, onUpFactory(SCALE), itemOnOver,
                              itemOnOut);
        /*
        MouseEventManager.add(t3, null, onUpFactory(CUP), itemOnOver,
                              itemOnOut);
        */
        MouseEventManager.add(t4, null, onUpFactory(DISPENSER), itemOnOver,
                              itemOnOut);
        MouseEventManager.add(t5, null, onUpFactory(SWITCH), itemOnOver,
                              itemOnOut);
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
        if (_tween != null && !_overMenuItem && _slidingIn) {

            _tween.cancel();
            slideOut();
        }
    }

    private function onOut(sprite:FlxSprite):Void {
        if (!_overMenuItem) {
            if (_slidingOut) {
                slideIn();
            } else {
                slideIn(0.25);
            }
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
        if ((!_isHidden && !_slidingIn) || _slidingOut) {
            return;
        }
        _slidingOut = true;
        _slidingIn = false;

        var options = {
            type: FlxTween.ONESHOT,
            startDelay: delay,
            loopDelay: null,
            ease: FlxEase.quintOut,
            complete: function(t: FlxTween) {
                _isHidden = false;
                _slidingOut = false;
            }
        }
        _tween = FlxTween.linearMotion(this, x, y,
                                       GAME_WIDTH - SLIDE_MENU_WIDTH, 0,
                                       SLIDE_MENU_DURATION, true, options);
    }

    public function slideIn(delay:Float = 0.0):Void {
        if ((_isHidden && !_slidingOut) || _slidingIn) {
            return;
        }
        _slidingIn = true;
        _slidingOut = false;

        var options = {
            type: FlxTween.ONESHOT,
            startDelay: delay,
            loopDelay: null,
            ease: FlxEase.quintOut,
            complete: function(t: FlxTween) {
                _isHidden = true;
                _slidingIn = false;
            }
        }
        _tween = FlxTween.linearMotion(this, x, y,
                                       GAME_WIDTH - SLIDE_MENU_MARGIN, 0,
                                       SLIDE_MENU_DURATION, true, options);
    }
}
