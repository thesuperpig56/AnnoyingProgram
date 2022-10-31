package menus;

import flixel.util.FlxTimer;
import flixel.tweens.FlxTween;
import internal.Transparency;
import flixel.input.keyboard.FlxKey;
import openfl.events.KeyboardEvent;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.ui.FlxUIState;
import flixel.text.FlxText;
import flixel.util.FlxColor;

/**
 * This is the FlxState that is the main state that the window is on.
 * I don't like how this was one line long so I'm adding random lines to this.
 * Okay, I like this size so I'll stop now.
 */
class PlayState extends FlxState
{
	var bgText:FlxText;

	var timer:FlxTimer; 

	var disableSpriteSpawn:Bool = false;

	var consoleString:String = "";
	var consoleActive:Bool = false;
	var consoleTween:FlxTween;
	var fpsTween:FlxTween;

    var sprite:FlxSprite;

	var spriteTween:FlxTween;
	var spriteAlive:Int = 10;
	var spriteRunning:Bool = false;
	
    
	override function create() {
        super.create();
		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.fromRGB(1, 1, 1));
		add(bg);
		Utilities.setBackgroundTransparency(true);
		var txt:FlxText = new FlxText(0, 0, FlxG.width,
			"Console:\n\nCmd:> _", 32);
		txt.setFormat("assets/fonts/SF-Pro.ttf", 32, FlxColor.WHITE, CENTER);
		txt.screenCenter();
		txt.visible = true;
		txt.alpha = 0;
		add(txt);
		bgText = txt;
		Main.changeWindowTitle("Application Manager", true);
		FlxG.stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyPress);
		FlxG.stage.addEventListener(KeyboardEvent.KEY_UP, onKeyRelease);
		trace("hide bg!");

		// fps
		Main.instance.fpsCounter.visible = true;
		Main.instance.fpsCounter.alpha = 0;
		openfl.Lib.current.stage.window.borderless = true;
    }

	var shouldShow:Int = 0;

	override function update(elapsed:Float) {
		super.update(elapsed);
		if (FlxG.random.bool(1) && !spriteRunning && !disableSpriteSpawn) {
			if (shouldShow >= 100) {
				showSprite();
				trace("show time!");
				shouldShow = 0;
			}
			else { shouldShow += 1; }
		}
	}

	private function onKeyPress(event:KeyboardEvent):Void {
		var eventKey:FlxKey = event.keyCode;
		// trace('Pressed: ' + eventKey);
		if (bgText.alpha == 1 && consoleActive) {
			var key = eventKey.toString();
			var updateText:Bool = true;
			switch (key) {
				case 'ZERO': key = "0";
				case 'ONE': key = "1";
				case 'TWO': key = "2";
				case 'THREE': key = "3";
				case 'FOUR': key = "4";
				case 'FIVE': key = "5";
				case 'SIX': key = "6";
				case 'SEVEN': key = "7";
				case 'EIGHT': key = "8";
				case 'NINE': key = "9";
				case 'SPACE': key = " ";
				case 'PLUS': key = "=";
				case 'NUMPADPLUS': key = '+';
				case 'PERIOD': key = '.';
				// ok this got more than one thing so yea!
				case 'GRAVEACCENT':
					trace("Not typing this one, just closing console!");
					toggleConsole();
					updateText = false;
				case 'BACKSPACE':
					consoleBackspace();
					key = "";
				case 'ENTER':
					consoleEnterKey();
					updateText = false;
			}
			if (updateText && !(key.length > 1)) {
				consoleString += key.toLowerCase();
				consoleUpdateEvent();
			}
			else if (!updateText) {}
			else if (updateText) trace('unknown key. key: [${key}]');
		}
		else {
			switch (eventKey.toString()) {
				case 'ESCAPE': if (Main.devVersion) { Sys.exit(0); }
				case 'GRAVEACCENT': toggleConsole();
			}
		}
	}

	private function onKeyRelease(event:KeyboardEvent):Void { var eventKey:FlxKey = event.keyCode; }

	// Actual stuff.
	function showSprite()
	{
		if (!spriteRunning) {
			trace("Show a random image!");
			sprite = new FlxSprite();
			sprite.pixels = Utilities.getRandomImagePixels();
			sprite.alpha = 0;
			sprite.screenCenter();
			Utilities.setBackgroundTransparency(true); // fuck.
			add(sprite);
			spriteTween = FlxTween.tween(sprite, {alpha: 1}, 1);
			spriteTween.onComplete = countdownActiveTimer;
			spriteRunning = true;
		}
	}

	function hideSprite() {
		if (spriteRunning) {
			trace("hide da sprite!");
			spriteTween = FlxTween.tween(sprite, {alpha: 0}, 1);
			spriteTween.onComplete = cleanIt;
		}
	}

	function toggleConsole() {
		if (!spriteRunning) {
			trace("Toggled console.");
			disableSpriteSpawn = true;
			if (consoleActive) {
				if (consoleTween != null) consoleTween.cancel();
					
				consoleTween = FlxTween.tween(bgText, {alpha: 0}, 0.5);
				consoleTween.onComplete = consoleHideInternal;
				if (fpsTween != null) fpsTween.cancel();
				fpsTween = FlxTween.tween(Main.instance.fpsCounter, {alpha: 0}, 0.5);
			}
			else {
				if (consoleTween != null) consoleTween.cancel();
				consoleTween = FlxTween.tween(bgText, {alpha: 1}, 0.5);
				consoleTween.onComplete = consoleShowInternal;
				if (fpsTween != null) fpsTween.cancel();
				fpsTween = FlxTween.tween(Main.instance.fpsCounter, {alpha: 1}, 0.5);
			}
		}
	}

	function consoleHideInternal(tween: FlxTween):Void {
		consoleActive = false;
		consoleString = "";
		disableSpriteSpawn = false;
		Main.instance.fpsCounter.visible = true;
	}

	function consoleShowInternal(tween: FlxTween):Void {
		consoleActive = true;
		consoleString = "";
		disableSpriteSpawn = true;
		Main.instance.fpsCounter.visible = true;
	}
	
	function consoleEnterKey() {
		if (consoleActive) {
			switch (consoleString)
			{
				case "force":
					trace("forcing sprite");
					shouldShow = 100;
					bgText.text = "Console:\n\nCmd:> _\n\nThe sprite will now show.";
				case "system.exit", "sys.exit", "system.close", "sys.close":
					trace("closing out the game.");
					Sys.exit(0);
				case "test":
					if (Main.devVersion) FlxG.switchState(new menus.TestScreen());
					else { bgText.text = "Console:\n\nCmd:> _\n\nThe test screen is not accessible."; }
				case "debug = true", "devmode = true", "dev = true", "debug == true", "devmode == true", "dev == true", "debug == true;", "devmode == true;", "dev == true;":
					bgText.text = "Console:\n\nCmd:> _\n\nEnabling developer mode.";
					Main.devVersion = true;
					layout.FPS.fpsPrefix = "DEV PREVIEW\n";
					trace("Enabled developer mode.");
				case "debug = false", "devmode = false", "dev = false", "debug == false", "devmode == false", "dev == false", "debug == false;", "devmode == false;", "dev == false;":
					bgText.text = "Console:\n\nCmd:> _\n\nDisabling developer mode.";
					Main.devVersion = false;
					layout.FPS.fpsPrefix = "";
					trace("Disabled developer mode.");
				case "array.print": trace(Utilities.getAllImagesArray());
				case "": bgText.text = "Console:\n\nCmd:> _\n\nPlease enter a command.";
				default: bgText.text = "Console:\n\nCmd:> _\n\nInvaild command. Please try again.";
			}
			consoleString = "";
		}
	}

	function consoleBackspace()
	{
		if (consoleActive) {
			if (consoleString.length != 0) {
				consoleString = consoleString.substring(0, consoleString.length - 1);
				consoleUpdateEvent();
			}
		}
	}

	function consoleUpdateEvent() { if (consoleActive) { bgText.text = "Console:\n\nCmd:> " + consoleString + "_"; } }

	// Timer functions.
	function countdownActiveTimer(tween: FlxTween):Void { timer = new FlxTimer().start(5, hideSpriteForTimer); }

	function hideSpriteForTimer(timer: FlxTimer):Void { hideSprite(); }

	function cleanIt(tween: FlxTween):Void
	{
		trace("setting sprite to null");
		remove(sprite);
		sprite = null;
		spriteRunning = false;
	}
}