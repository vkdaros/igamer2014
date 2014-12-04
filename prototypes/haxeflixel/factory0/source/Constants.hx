package;

class Constants {
    // Screen size
    public static inline var GAME_WIDTH:Int  = 960;
    public static inline var GAME_HEIGHT:Int = 552;

    // Offset of the factory grid with respect of the screen.
    public static inline var X_OFFSET:Int = 505;
    public static inline var Y_OFFSET:Int = 100;

    // Dimensions of ground tile (without elevation).
    public static inline var TILE_WIDTH:Int  = 100;
    public static inline var TILE_HEIGHT:Int =  50;

    // Dimensions of tile frame in tile sheet.
    public static inline var TILE_FRAME_WIDTH:Int  = 100;
    public static inline var TILE_FRAME_HEIGHT:Int = 65;

    // Dimensions of ice cream frame.
    public static inline var ICE_CREAM_FRAME_WIDTH:Int  = 32;
    public static inline var ICE_CREAM_FRAME_HEIGHT:Int = 32;

    // Dimension of stage button for StageSelectState.
    public static inline var STAGE_BUTTON_SIZE:Int = 56;

    // Truck dimensions.
    public static inline var TRUCK_FRAME_WIDTH:Int  = 260;
    public static inline var TRUCK_FRAME_HEIGHT:Int = 230;
    public static inline var TRUCK_X_OFFSET:Int     =  40;
    public static inline var TRUCK_Y_OFFSET:Int     = 120;

    // Isometric directions.
    public static inline var NE:Int = 0;
    public static inline var NW:Int = 1;
    public static inline var SW:Int = 2;
    public static inline var SE:Int = 3;

    // Conveyors possible types. Same index system from Tiled.
    public static inline var HIDDEN:Int =  0;
    public static inline var BEGIN:Int  =  1;
    public static inline var END:Int    =  5;
    public static inline var DOWN:Int   =  9;
    public static inline var UP:Int     = 13;
    public static inline var GROUND:Int = 18;

    // Tiled max value from which tiles are considered x and y flipped.
    public static inline var TILED_X_FLIP:Float = 2147483648;
    public static inline var TILED_Y_FLIP:Float = 1073741824;

    // Tween movement parameters.
    public static inline var BOX_MOVEMENT_DURATION:Int = 1; // seconds.

    // Slide menu properties.
    public static inline var SLIDE_MENU_WIDTH:Int      = 210;
    public static inline var SLIDE_MENU_COLOR:Int      = 0x99B0C4DE;
    public static inline var SLIDE_MENU_MARGIN:Int     = 60;
    public static inline var SLIDE_MENU_DURATION:Float = 0.5;

    // Device popup constants.
    public static inline var POPUP_BACKGROUND_COLOR:Int = 0x33CCCCCC;
    public static inline var POPUP_INFOAREA_BGCOLOR:Int = 0x55FFFFFF;
    public static inline var POPUP_INFOAREA_FGCOLOR:Int = 0x55000000;
    public static inline var POPUP_BUTTON_WIDTH:Int     = 50;
    public static inline var POPUP_BUTTON_HEIGHT:Int    = 50;
    public static inline var POPUP_BUTTON_HMARGIN:Int   = 5;
    public static inline var POPUP_BUTTON_VMARGIN:Int   = 15;

    // Game elements.
    public static inline var DISPENSER:Int = 0;
    public static inline var DOSER:Int     = 1;
    public static inline var CUP:Int       = 2;
    public static inline var BOX:Int       = 3;
    public static inline var SWITCH:Int    = 4;
    public static inline var SCALE:Int     = 5;

    // Scale limits.
    public static inline var MIN_SCALE_VALUE:Int = 1;
    public static inline var MAX_SCALE_VALUE:Int = 3;

    // Doser limits.
    public static inline var MIN_DOSER_VALUE:Int = 1;
    public static inline var MAX_DOSER_VALUE:Int = 2;
}
