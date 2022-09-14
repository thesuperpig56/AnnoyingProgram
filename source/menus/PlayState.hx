package menus;

import flixel.input.keyboard.FlxKey;
import openfl.events.KeyboardEvent;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.ui.FlxUIState;
import flixel.text.FlxText;
import flixel.util.FlxColor;

/**
 * This is just a FlxState which only shows a test message.
 * It doesn't do anything else. Just displays a test message.
 * Shouldn't be used or even have a user sent to this FlxState unless something went wrong.
 */
class PlayState extends FlxState
{
	var bgText:FlxText;
    var sprite:FlxSprite;

	var spriteTween:FlxSprite;
	var spriteAlive:Int = 10;
	var spriteRunning:Bool = false;
	
    
	override function create()
	{
        super.create();
		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		add(bg);
		var txt:FlxText = new FlxText(0, 0, FlxG.width,
			"Console:\n\nCmd:> _", 32);
		txt.setFormat("assets/fonts/SF-Pro.ttf", 32, FlxColor.WHITE, CENTER);
		txt.screenCenter();
		txt.visible = false;
		add(txt);
		bgText = txt;
		Main.changeWindowTitle("Application Manager", true);
		FlxG.stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyPress);
		FlxG.stage.addEventListener(KeyboardEvent.KEY_UP, onKeyRelease);
    }

	override function update(elapsed:Float) {
		super.update(elapsed);
	}

	private function onKeyPress(event:KeyboardEvent):Void
	{
		var eventKey:FlxKey = event.keyCode;
		trace('Pressed: ' + eventKey);
	}

	private function onKeyRelease(event:KeyboardEvent):Void
	{
		var eventKey:FlxKey = event.keyCode;
		trace("key released: " + eventKey);
	}

	// Actual stuff.
	function showSprite()
	{
		if (!spriteRunning)
		{
			trace("Show a random image!");
			sprite = new FlxSprite();
			sprite.pixels = Utilities.getImagePixels("assets/images/window" + FlxG.random.int(1, 4) + ".jpg");
			add(sprite);
		}
	}
}