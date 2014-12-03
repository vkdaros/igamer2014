package;

import flixel.FlxG;
import flixel.group.FlxSpriteGroup;
import flixel.util.FlxSpriteUtil;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.system.debug.LogStyle;

/**
 * Renders a frame for general purpose.
 */
class RoundFrame extends FlxSprite {

	private var _x:Int;

	private var _y:Int;

	private var _w:Int;

	private var _h:Int;

	private var _lineColor:Int;

	private var _fillColor:Int;

	/**
	 * Prints a log message with DEBUG style.
	 * @param data Any type with the data to be printed out to the console log.
	 */
	public function new(x:Int, y:Int, w:Int, h:Int, lineColor:Int, fillColor:Int) {
		super(x, y);
		width = w;
		height = h;

		_x = x;
		_y = y;
		_w = w;
		_h = h;
		_lineColor = lineColor;
		_fillColor = fillColor;
	}

	public function create():Void {
		makeGraphic(_w, _h, FlxColor.TRANSPARENT, true);

		var lineStyle:LineStyle = { thickness: 2, color: _lineColor };
		var fillStyle:FillStyle = { hasFill: true, color: _fillColor };

		FlxSpriteUtil.drawRoundRect(this, _x, _y, _w, _h, 2, 2, _fillColor, lineStyle, fillStyle, null);
	}
}
