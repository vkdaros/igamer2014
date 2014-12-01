package;

import flixel.FlxG;
import flixel.system.debug.LogStyle;

/**
 * Utilitary class for easy of use of logging in the debug console.
 */
class Log {

	/**
	 * Prints a log message with DEBUG style.
	 * @param data Any type with the data to be printed out to the console log.
	 */
	public static function debug(data:Dynamic):Void {
		FlxG.log.advanced(data, LogStyle.CONSOLE);
	}

	/**
	 * Prints a log message with INFO style.
	 * @param data Any type with the data to be printed out to the console log.
	 */
	public static function info(data:Dynamic):Void {
		FlxG.log.advanced(data, LogStyle.NORMAL);
	}

	/**
	 * Prints a log message with WARNING style.
	 * @param data Any type with the data to be printed out to the console log.
	 */
	public static function warning(data:Dynamic):Void {
		FlxG.log.advanced(data, LogStyle.WARNING);
	}

	/**
	 * Prints a log message with CRITICAL style.
	 * @param data Any type with the data to be printed out to the console log.
	 */
	public static function critical(data:Dynamic):Void {
		FlxG.log.advanced(data, LogStyle.ERROR);
	}
}
