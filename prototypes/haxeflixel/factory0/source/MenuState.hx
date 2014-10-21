package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.ui.FlxUIState;
import flixel.addons.ui.FlxUIText;
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
        add(new FlxText(50, 50, 100, "Hello World!"));
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
                        case "back": FlxG.switchState(new MenuState());
                    }
            }
        }
    }

    /**
     * Create UI using Flixel-UI elements and strings from FireTongue instead of
     * hardcoded labels.
     */
    private function createUI():Void {
        // FlxUIText(x, y, width, text)
        // _tongue.get(csv_field, translation_context)
        var titleText = new FlxUIText(50, 100, 100, _tongue.get("$GAME_NAME", "ui"));
        titleText.x = (FlxG.width - titleText.width) / 2;
        titleText.alignment = "center";

        // Add titleText to the scene.
        add(titleText);
    }
}
