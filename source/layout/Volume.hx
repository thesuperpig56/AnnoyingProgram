package layout;

import flixel.FlxG;
import flixel.math.FlxMath;
// import handlers.utils.CorePaths;
import openfl.text.TextField;
import openfl.text.TextFormat;

/**
 *  When working with volume, use the HaxeFlixel source code for guidance.
 *  https://github.com/HaxeFlixel/flixel/blob/master/flixel/system/frontEnds/SoundFrontEnd.hx
 */
/**
 * This is a class which tries to handle all volume inputs.
 * This will also be an attempt to make a custom sound tray.
 * 
 * Must be added to the game as a child in Main.hx
 */
class Volume extends TextField {
	var currentVolume:Int = 0;

	var frameShit:Int = 0;
	var soundTrayToggle:Bool = true;

	@:noCompletion private var cacheCount:Int;
	@:noCompletion private var currentTime:Float;
	@:noCompletion private var times:Array<Float>;

	public function new(x:Float = 10, y:Float = 10, color:Int = 0x000000) {
		super();
		trace("Initialized a Volume UI.");

		this.x = x;
		this.y = y;

		alpha = 0; // lol
		frameShit = 0; // lol
		soundTrayToggle = false;

		selectable = false;
		mouseEnabled = false;
		// defaultTextFormat = new TextFormat("_sans", 12, color);
		var fontName:String = 'scoretxt.ttf';
		var fontSize:Int = 20; // font size default size: 16
		var fontShit:String = openfl.utils.Assets.getFont("assets/fonts/" + fontName).fontName;
		defaultTextFormat = new TextFormat(fontShit, fontSize, color);

		text = "volume placeholder!";

		cacheCount = 0;
		currentTime = 0;
		times = [];

		FlxG.sound.volumeHandler = volumeCallback;
		FlxG.sound.soundTrayEnabled = false;
		// FlxG.sound.showSoundTray(); // makes the sound tray show.

		#if flash
		addEventListener(Event.ENTER_FRAME, function(e) {
			var time = Lib.getTimer();
			__enterFrame(time - currentTime);
		});
		#end
	}

	// Basically the onUpdate thing for this.
	@:noCompletion
	private #if !flash override #end function __enterFrame(deltaTime:Float):Void {
		// lol!
		currentTime += deltaTime;
		times.push(currentTime);

		while (times[0] < currentTime - 1000) {
			times.shift();
		}

		var currentCount = times.length;

		#if (web)
		var effectVol:Float = 1; // lol
		#else
		var effectVol:Float = 0.5; // default shit!
		#end

		// #if FLX_KEYBOARD
		// if (FlxG.keys.anyJustReleased(FlxG.sound.volumeUpKeys)) {
		// 	FlxG.sound.play(CorePaths.sound('soundTray/soundup'), effectVol);
		// } else if (FlxG.keys.anyJustReleased(FlxG.sound.volumeDownKeys)) {
		// 	FlxG.sound.play(CorePaths.sound('soundTray/sounddown'), effectVol);
		// }
		// #end

		if (frameShit > 0 && soundTrayToggle) {
			#if (web)
			frameShit -= 2;
			#else
			frameShit -= 1;
			#end
			// trace("frameShit: " + frameShit);
		}

		if (soundTrayToggle) {
			switch (frameShit / 100) {
				case 0:
					soundTrayToggle = false;
					alpha = 0;
				// trace("sound tray gone!");
				default:
					var alphaVar:Float = (frameShit / 100);
					// trace("frameShit counter: " + alphaVar);
					alpha = alphaVar;
			}
		}

		cacheCount = currentCount;
	}

	function volumeCallback(volume:Float) {
		// trace("volume callback! | Current volume: " + volume + " | Muted: " + FlxG.sound.muted);
		var volMath:Float = FlxMath.roundDecimal(volume, 1);
		switch (volMath) {
			case 0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1:
				text = "Volume\n    " + volMath;
			default:
				text = "Volume\n    nul";
				trace("volume lookin odd: " + volume + " | volume math calculation result: " + volMath);
		}
		// text = "Volume: " + volume;
		frameShit = 100;
		soundTrayToggle = true;
		alpha = 1;
		// FlxG.sound.play(Paths.sound('soundTray/sounddown'));
	}
}