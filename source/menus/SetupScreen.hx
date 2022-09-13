package menus;

import flixel.tweens.FlxTween;
import Utilities;
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
class SetupScreen extends FlxState
{
	var bgText:FlxText;
    var sdlTween:FlxTween;
    var sdlStartTween:Bool = false;
    
	override function create()
	{
        super.create();
		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		add(bg);
		var txt:FlxText = new FlxText(0, 0, FlxG.width,
			"hiding myself!", 32);
		txt.setFormat("assets/fonts/SF-Pro.ttf", 32, FlxColor.WHITE, CENTER);
		txt.screenCenter();
		add(txt);
		bgText = txt;
		Main.changeWindowTitle("hiding!", false);
    }

	override function update(elapsed:Float) {
		super.update(elapsed);
        if (!sdlStartTween)
        {
            sdlStartTween = true;
            tweenSDLWindow();
        }
        if (lime.app.Application.current.window.opacity == 0)
        {
            if (sdlTween.active)
                sdlTween.cancel();
            nextState();
        }
	}

    function tweenSDLWindow()
    {
        sdlTween = FlxTween.tween(lime.app.Application.current.window, {opacity: 0}, 0.5);
        // sdlTween.onComplete = nextState();
    }

    function nextState():Void
    {
        trace("going to test screen!");
        FlxG.switchState(new TestScreen());
    }
}