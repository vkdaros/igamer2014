package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.ui.FlxUIState;
import flixel.addons.ui.FlxUIText;
import flixel.addons.ui.FlxUIButton;
import flixel.text.FlxText;
import flixel.util.FlxMath;

// Multi-language support.
import firetongue.FireTongue;

/**
 * A FlxState which can be used for the game's menu.
 */
class MenuState extends FlxUIState {
    /**
     * Function that is called up when to state is created to set it up.
     */
    override public function create():Void {
        if (Main.tongue == null) {
            Main.tongue = new FireTongueEx();
            Main.tongue.init("en-US");
            FlxUIState.static_tongue = Main.tongue;
        }
        super.create();

        createUI();
    }

    /**
     * Function that is called when this state is destroyed - you might want to
     * consider setting all objects this state uses to null to help garbage
     * collection.
     */
    override public function destroy():Void {
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
        var titleText = new FlxUIText(50, 100, 100, _tongue.get("$GAME_NAME",
                                                                "ui"));
        titleText.x = (FlxG.width - titleText.width) / 2;
        titleText.alignment = "center";

        // Add titleText to the scene.
        add(titleText);
    }

    private function createUIButtons():Void {
        /* Play button */
        // FlxUIButton(x, y, label)
        var playButton = new FlxUIButton(10, 400, _tongue.get("$MENU_PLAY",
                                                               "ui"));
        playButton.params = ["play"];
        //playButton.id = "?";
        playButton.x = (FlxG.width - playButton.width) / 2;

        // Add button to the scene.
        add(playButton);

        /* Switch language buttons */
        var enButton = new FlxUIButton(10, 430, _tongue.get("$LANGUAGE:EN-US",
                                                            "index"));
        var ptButton = new FlxUIButton(10, 450, _tongue.get("$LANGUAGE:PT-BR",
                                                            "index"));
        enButton.params = ["en-US"];
        ptButton.params = ["pt-BR"];
        enButton.x = (FlxG.width - enButton.width) / 2;
        ptButton.x = (FlxG.width - ptButton.width) / 2;
        add(enButton);
        add(ptButton);
    }

    public override function getRequest(id:String, sender:Dynamic, data:Dynamic,
                                        ?params:Array<Dynamic>):Dynamic {
        return null;
    }

    public override function getEvent(id:String, target:Dynamic, data:Dynamic,
                                      ?params:Array<Dynamic>):Void {
        if (params != null) {
            switch (id) {
                case "click_button":
                    switch (cast(params[0], String)) {
                        case "play": FlxG.switchState(new PlayState());
                        case "en-US": switchLanguage("en-US");
                        case "pt-BR": switchLanguage("pt-BR");
                    }
            }
        }
    }

    private function switchLanguage(language:String):Void {
        if (Main.tongue != null) {
		    Main.tongue.init(language, reloadState);
        }
    }

	private function reloadState():Void {
		FlxG.switchState(new MenuState());
	}
}
