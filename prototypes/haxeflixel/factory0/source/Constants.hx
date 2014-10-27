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


    // Conveyors possible types.
    public static inline var HIDDEN:Int = -1;
    public static inline var BEGIN:Int  =  0;
    public static inline var END:Int    =  1;
    public static inline var DOWN:Int   =  2;
    public static inline var UP:Int     =  3;
    public static inline var GROUND:Int =  4;

    // Tween movement parameters.
    public static inline var BOX_MOVEMENT_DURATION:Int = 1; // seconds.
}
