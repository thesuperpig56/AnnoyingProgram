package menus;

import flixel.tweens.FlxTween;
import internal.WindowManagement;
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
class TestScreen extends FlxState
{
	var bgText:FlxText;
    
	override function create()
	{
        super.create();
		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		add(bg);
		var txt:FlxText = new FlxText(0, 0, FlxG.width,
			"Hmm.\nThis is just a test screen. Do anything!", 32);
		txt.setFormat("assets/fonts/SF-Pro.ttf", 32, FlxColor.WHITE, CENTER);
		txt.screenCenter();
		add(txt);
		bgText = txt;
		Main.changeWindowTitle("Showing the test screen.", false);
    }

	var tweenSDL:FlxTween;

	override function update(elapsed:Float) {
		super.update(elapsed);
		if (FlxG.keys.justPressed.ESCAPE)
		{
			trace("Closing out the game.");
			trace("Note: this bypasses the onExit handler since it's a system exit.");
			Sys.exit(0); // lol.
		}
		if (FlxG.keys.justPressed.ONE)
		{
			tweenSDLWindow();
			trace("hiding the window.");
		}
		if (FlxG.keys.justPressed.TWO)
		{
			untweenSDLWindow();
			trace("revealing the window.");
		}
		if (FlxG.keys.justPressed.THREE)
		{
			Utilities.setBackgroundTransparency(true);
			trace("bg transparent");
		}
		if (FlxG.keys.justPressed.FOUR)
		{
			FlxG.switchState(new menus.PlayState());
			trace("Moving to PlayState.");
		}
		#if DISABLESOFTLOCK
		if (FlxG.keys.justPressed.ESCAPE)
		{
			trace("SOFTLOCK DISABLED. ESCAPING!");
			FlxG.switchState(new menus.ModuleLoader());
		}
		#end
	}

	function tweenSDLWindow()
    {
        // Utilities.setBackgroundTransparency(true); // lol.
		if (tweenSDL != null)
		{
			tweenSDL.cancel();
			tweenSDL == null;
		}
        tweenSDL = FlxTween.tween(lime.app.Application.current.window, {opacity: 0}, 1);
        // sdlTween.onComplete = nextState();
    }

	function untweenSDLWindow()
    {
        // Utilities.setBackgroundTransparency(true); // lol.
		if (tweenSDL != null)
		{
			tweenSDL.cancel();
			tweenSDL == null;
		}
        tweenSDL = FlxTween.tween(lime.app.Application.current.window, {opacity: 1}, 1);
        // sdlTween.onComplete = nextState();
    }
}