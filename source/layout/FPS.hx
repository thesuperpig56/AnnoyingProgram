package layout;

import flixel.FlxG;
import flixel.FlxState;
import flixel.math.FlxMath;
import haxe.Timer;
import openfl.events.Event;
import openfl.system.System;
import openfl.text.TextField;
import openfl.text.TextFormat;
#if flash
import openfl.Lib;
#end

/**
	The FPS class provides an easy-to-use monitor to display
	the current frame rate of an OpenFL project
**/
#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
class FPS extends TextField
{
	/**
		The current frame rate, expressed using frames-per-second
	**/
	public var currentFPS(default, null):Int;

	public static var fpsPrefix:String = "";

	@:noCompletion private var cacheCount:Int;
	@:noCompletion private var currentTime:Float;
	@:noCompletion private var times:Array<Float>;

	public function new(x:Float = 10, y:Float = 10, color:Int = 0x000000)
	{
		super();
        trace("Initialized a FPS UI.");

		this.x = x;
		this.y = y;

		currentFPS = 0;
		selectable = false;
		mouseEnabled = false;
		var fontName:String = '${Main.synthexFontName}';
		var fontShit:String = openfl.utils.Assets.getFont("assets/fonts/" + fontName).fontName;
		defaultTextFormat = new TextFormat(fontShit, 16, color);

		if (Main.devVersion) // why not.
			fpsPrefix = "DEV PREVIEW\n";
		
		text = fpsPrefix + "Ver: " + Main.engineCoreVersion + "\nFPS: ";

		cacheCount = 0;
		currentTime = 0;
		times = [];

		#if flash
		addEventListener(Event.ENTER_FRAME, function(e)
		{
			var time = Lib.getTimer();
			__enterFrame(time - currentTime);
		});
		#end
	}

	// Event Handlers
	@:noCompletion
	private #if !flash override #end function __enterFrame(deltaTime:Float):Void
	{
		currentTime += deltaTime;
		times.push(currentTime);

		while (times[0] < currentTime - 1000)
		{
			times.shift();
		}

		var currentCount = times.length;
		currentFPS = Math.round((currentCount + cacheCount) / 2);

		var memoryMegas:Float = 0;

		if (currentCount != cacheCount /*&& visible*/)
		{
			#if (openfl && cpp && DEV)
			memoryMegas = Math.abs(FlxMath.roundDecimal(System.totalMemory / 1000000, 1));
			text = fpsPrefix + "Ver: " + Main.engineCoreVersion + "\nFPS: " + currentFPS + "\nMemory: " + memoryMegas + " MB";
			#else
			text = fpsPrefix + "Ver: " + Main.engineCoreVersion + "\nFPS: " + currentFPS;
			#end
		}

		cacheCount = currentCount;
	}
}
