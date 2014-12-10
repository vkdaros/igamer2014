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

import openfl.Assets;

import Constants.*;
import MenuState;
import PlayState;

/**
 * A FlxState which can be used for the game's menu.
 */
class StageSelectState extends FlxUIState {
    // Buttons to all stages.
    private var _exitButton:FlxButton;

    // Scale modes.
    private var fill:FillScaleMode;
    private var ratio:RatioScaleMode;
    private var relative:RelativeScaleMode;
    private var fixed:FixedScaleMode;
	
	/** Map with the level files. */
	private var _stageMap:Map<Int, Dynamic>;

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

        add(new FlxSprite(0, 0, "assets/images/bg.png"));
        var brazil = new FlxSprite(0, 0, "assets/images/brazil_map.png");
        brazil.x = (FlxG.width - brazil.width) / 2;
        brazil.antialiasing = true;
        add(brazil);
		
		initStageMap();
		
        createUI();
        initEventListener();
    }

	/**
	 * Configure the levels' files, names and positions on the Brazilian map
	 */
	private function initStageMap():Void {
        _stageMap = new Map<Int, Dynamic>();
		// The level map is configured as follows:
		//   name: name of the city to be displayed
		//   file: path of the file with the level json
		//   x, y: coordinates of the position of the city on the Brazilian map
        _stageMap[0] = { name: "Rio Branco",
						 file: "assets/maps/rio_branco.json",
						 x: 314, y: 195 };
        _stageMap[1] = { name: "Manaus",
						 file: "assets/maps/manaus.json",
						 x: 400, y: 116 };
        _stageMap[2] = { name: "Belo Horizonte",
						 file: "assets/maps/belo_horizonte.json",
						 x: 603, y: 318 };
        _stageMap[3] = { name: "Rio de Janeiro",
						 file: "assets/maps/rio_de_janeiro.json",
						 x: 630, y: 380 };
        _stageMap[4] = { name: "São Paulo",
						 file: "assets/maps/sao_paulo.json",
						 x: 566, y: 366 };
		_stageMap[5] = { name: "Porto Alegre",
						 file: "assets/maps/porto_alegre.json",
						 x: 518, y: 452 };
		_stageMap[6] = { name: "Teresina",
						 file: "assets/maps/teresina.json",
						 x: 624, y: 133 };
		_stageMap[7] = { name: "Cuiabá",
						 file: "assets/maps/cuiaba.json",
						 x: 462, y: 257 };
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

	/**
	 * Create the buttons to call the different levels
	 */
    private function createUIButtons():Void {
        _exitButton = new FlxButton(20, 20, null, exitCallback);
        _exitButton.loadGraphic("assets/images/button_exit.png", true, 50, 50);
        _exitButton.antialiasing = true;
        add(_exitButton);

		/**
		 * Generic callback function for the level buttons
		 * @param id Integer with the index of the level on the levels map
		 */
        var callbackFactory = function(id:Int):Void->Void {
            return function():Void {
				var json = Assets.getText(_stageMap[id].file);
                FlxG.switchState(new PlayState(_stageMap[id].name, json));
            };
        };
		
		// Create a button for each entry on the levels map
		for (i in _stageMap.keys()) {
			var data = _stageMap.get(i);
			var button = new FlxUIButton(data.x, data.y, data.name,
									callbackFactory(i));
			button.loadGraphic("assets/images/stage_icon.png", true,
									STAGE_BUTTON_SIZE, STAGE_BUTTON_SIZE);
			button.x -= STAGE_BUTTON_SIZE / 2;
			button.y -= STAGE_BUTTON_SIZE / 2;
			button.antialiasing = true;
			add(button);
		}		
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
