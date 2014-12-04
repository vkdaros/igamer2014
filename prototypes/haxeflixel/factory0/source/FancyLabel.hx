package;

import flixel.FlxG;
import flixel.group.FlxSpriteGroup;
import flixel.util.FlxSpriteUtil;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.text.pxText.PxBitmapFont;
import flixel.text.pxText.PxTextAlign;
import flixel.text.FlxBitmapTextField;
import flixel.system.debug.LogStyle;

/**
 * Renders a frame for general purpose.
 */
class FancyLabel extends FlxSpriteGroup {
	
	/** Class used to render a string in a sprite. */
	private var _text:FlxBitmapTextField;
	
	/**
	 * Class constructor.
	 * @param x Float with the label's horizontal position.
	 * @param y Float with the label's vertical position.
	 * @param w Float with the label's fixed width.
	 * @param h Float with the label's fixed height.
	 * @param text String with the text to be displayed in the label.
	 * @param font PxBitmapFont with the font to be used for displaying the
	 * text.
	 * @param fontScale Float with the font scale in range [0, 1] (the default
	 * is 1).
	 * @param lineColor Int with the color of the edge line (the default is
	 * FlxColor.TRANSPARENT).
	 * @param fillColor Int with the color of the background (the default is
	 * FlxColor.WHITE).
	 * @param ellipseWidth Float with the width of the ellipse for the rounded
	 * corners (the default is 0 - meaning no rounded corners).
	 * @param ellipseHeight Float with the height of the ellipse for the rounded
	 * corners (the default is 0 - meaning no rounded corners).
	 * @param lineThickness Int with the thickness of the edge line.
	 */
	public function new(x:Float, y:Float, w:Float, h:Float,
						text:String, font:PxBitmapFont, fontScale:Float = 1,
						lineColor:Int = FlxColor.TRANSPARENT,
						fillColor:Int = FlxColor.WHITE,
						ellipseWidth:Float = 0, ellipseHeight:Float = 0,
						lineThickness:Int = 1) {
		super(x, y);

		// Sanity checks
		lineThickness = cast(Math.abs(cast(lineThickness, Float)), Int);
		if (fontScale < 0)
			fontScale = 0;
		else if (fontScale > 1)
			fontScale = 1;
		
		// First prepare the background
		var background = new FlxSprite(x, y);
		background.makeGraphic(cast(w, Int) + 2 * lineThickness,
							   cast(h, Int) + 2 * lineThickness,
							   FlxColor.TRANSPARENT, true);

		var lineStyle:LineStyle = { thickness: lineThickness, color: lineColor };
		var fillStyle:FillStyle = { hasFill: true, color: fillColor };
		FlxSpriteUtil.drawRoundRect(background, x, y, w, h, ellipseWidth, ellipseHeight, FlxColor.TRANSPARENT, lineStyle, fillStyle, null);
		
		add(background);
		
		// Then, prepare the text
        _text = new FlxBitmapTextField(font);
        _text.x = lineThickness;
        _text.y = lineThickness;
        _text.useTextColor = false;
        _text.fontScale = fontScale;
        _text.alignment = PxTextAlign.CENTER;
        _text.offset.y = font.getFontHeight() * fontScale / 2;
        _text.antialiasing = true;
		_text.text = text;
        add(_text);
	}
	
	/** Property with the label text. */
	public var text(get, set):String;
	
	/**
	 * Getter of the text property.
	 * @return String with the current text being rendered by the class.
	 */
	private function get_text():String {
		return _text.text;
	}
	
	/**
	 * Setter of the text property.
	 * @param text String with the new text to render in the class.
	 * @return String with the updated text in the class.
	 */
	private function set_text(text:String):String {
		_text.text = text;
		return _text.text;
	}
}
