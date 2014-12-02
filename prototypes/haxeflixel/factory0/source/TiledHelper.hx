package;

/***
 * Tiled json file structures.
 */
typedef TiledLayer = {
    var name:String;
    var type:String;
    var width:Int;
    var height:Int;
    var data:Array<Float>;
    var objects:Array<TiledObject>;
}

typedef TiledMap = {
    var width:Int;
    var height:Int;
    var layers:Array<TiledLayer>;
    var tilesets:Array<TiledTileSet>;
}

typedef TiledTileSet = {
    var firstgid:Int;
    var name:String;
    var image:String;
    var imagewidth:Int;
    var imageheight:Int;
    var margin:Int;
    var properties:Dynamic;
    var spacing:Int;
    var tilewidth:Int;
    var tileheight:Int;
    var tileoffset:Map<String, Int>;

    // Only present when there are animated tiles.
    var tiles:Dynamic;
}

typedef TiledAnimation = {
    var animation:Array<TiledAnimationFrame>;
}

typedef TiledAnimationFrame = {
    var duration:Int;
    var tileid:Int;
}

typedef TiledObject = {
    var x:Int;
    var y:Int;
    var width:Int;
    var height:Int;
    var name:String;
    var type:String;
    var visible:Bool;
    var properties:Dynamic; // It's complicated... such as TiledTileSet.tiles.
    var rotation:Int;
}
