package;

import flash.Lib;
import flash.events.KeyboardEvent;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.ui.FlxButton;
import flixel.addons.ui.FlxUIText;
import flixel.addons.ui.FlxUIState;
import flixel.addons.ui.FlxUIButton;

import flixel.system.scaleModes.FillScaleMode;
import flixel.system.scaleModes.FixedScaleMode;
import flixel.system.scaleModes.RatioScaleMode;
import flixel.system.scaleModes.RelativeScaleMode;

// Multi-language support.
import firetongue.FireTongue;

import Constants.*;
import MenuState;
import PlayState;

/**
 * A FlxState which can be used for the game's menu.
 */
class StageSelectState extends FlxUIState {
    // Buttons to all stages.
    private var _buttons:Array<FlxUIButton>;
    private var _exitButton:FlxButton;

    // Scale modes.
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

        if (Main.tongue == null) {
            Main.tongue = new FireTongueEx();
            Main.tongue.init("en-US");
            FlxUIState.static_tongue = Main.tongue;
        }

        super.create();

        _buttons = new Array<FlxUIButton>();

        add(new FlxSprite(0, 0, "assets/images/bg_debug2.png"));
        var brazil = new FlxSprite(0, 0, "assets/images/brazil_map.png");
        brazil.x = (FlxG.width - brazil.width) / 2;
        brazil.antialiasing = true;
        add(brazil);
        createUI();
        initEventListener();
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
        super.update();
    }

    /**
     * Create UI using Flixel-UI elements and strings from FireTongue instead of
     * hardcoded labels.
     */
    private function createUI():Void {
        createUITitle();
        createUIButtons();
    }

    private function createUITitle():Void {
        // FlxUIText(x, y, width, text)
        // _tongue.get(csv_field, translation_context)
        var titleText = new FlxUIText(20, 20, 300, _tongue.get("$STAGE_SELECT",
                                                                "ui"));
        //titleText.x = (FlxG.width - titleText.width) / 2;
        titleText.alignment = "center";

        // Add titleText to the scene.
        add(titleText);
    }

    private function createUIButtons():Void {
        _exitButton = new FlxButton(20, 20, null, exitCallback);
        _exitButton.loadGraphic("assets/images/button_exit.png", true, 50, 50);
        _exitButton.antialiasing = true;
        add(_exitButton);

        var callbackFactory = function(id:Int):Void->Void {
            return function():Void {
                FlxG.switchState(new PlayState(id));
            };
        };
        _buttons.push(new FlxUIButton(300, 120, null, callbackFactory(0)));
        _buttons[0].loadGraphic("assets/images/stage_icon.png", true,
                                STAGE_BUTTON_SIZE, STAGE_BUTTON_SIZE);
        _buttons[0].antialiasing = true;

        _buttons.push(new FlxUIButton(535, 395, null, callbackFactory(1)));
        _buttons[1].loadGraphic("assets/images/stage_icon.png", true,
                                STAGE_BUTTON_SIZE, STAGE_BUTTON_SIZE);
        _buttons[1].antialiasing = true;

        _buttons.push(new FlxUIButton(470, 505, null, callbackFactory(2)));
        _buttons[2].loadGraphic("assets/images/stage_icon.png", true,
                                STAGE_BUTTON_SIZE, STAGE_BUTTON_SIZE);
        _buttons[2].antialiasing = true;

        for (button in _buttons) {
            add(button);
        }
    }

    private function buttonCallback():Void {
        // TODO: make each button call a different stage (duh!).
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
     * Return to menu.
     */
    public function exitCallback():Void {
        FlxG.switchState(new MenuState());
    }

    /**
     * Called whenever a key from keyboard or moble device is released.
     * If the key is ESCAPE, end the application.
     */
    public function onUp(event:KeyboardEvent):Void {
        // Get ESCAPE from keyboard or BACK from android.
        if (event.keyCode == 27) {
            #if android
            event.stopImmediatePropagation();
            #end
            FlxG.switchState(new MenuState());
        }
    }
}
