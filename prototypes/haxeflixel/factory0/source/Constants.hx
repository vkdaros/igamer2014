package;

class Constants {
    // Dimensions of ground tile (without elevation).
    public static inline var TILE_WIDTH:Int = 100;
    public static inline var TILE_HEIGHT:Int = 50;

    // Dimensions of tile frame in tile sheet.
    public static inline var TILE_FRAME_WIDTH:Int = 100;
    public static inline var TILE_FRAME_HEIGHT:Int = 65;

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
    public static inline var SLIDE_MENU_X:Int          = 600;
    public static inline var SLIDE_MENU_Y:Int          = 0;
    public static inline var SLIDE_MENU_WIDTH:Int      = 200;
    public static inline var SLIDE_MENU_COLOR:Int      = 0x99B0C4DE;
    public static inline var SLIDE_MENU_MARGIN:Int     = 20;
    public static inline var SLIDE_MENU_DURATION:Float = 0.5;
}
