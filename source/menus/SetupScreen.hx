package menus;

import Utilities;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.ui.FlxUIState;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;

/**
 * This is just a FlxState which only hides the SDL window and shows a message.
 * It just transitions to the PlayState state after setting the SDL opacity.
 * This shouldn't be used more than once unless the process was restarted.
 */
class SetupScreen extends FlxState
{
	var bgText:FlxText;
    var sdlTween:FlxTween;
    var sdlStartTween:Bool = false;
    
	override function create()
	{
        super.create();
		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.fromRGB(1, 1, 1));
		add(bg);
        var text:String = "bye bye!";
        if (Main.restartedGame) text = internal.IncorrectCounter.getNewText();
		var txt:FlxText = new FlxText(0, 0, FlxG.width,
			text, 32);
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
            FlxG.mouse.useSystemCursor = true;
            tweenSDLWindow();
        }
	}

    function tweenSDLWindow()
    {
        Utilities.setBackgroundTransparency(true); // lol.
        sdlTween = FlxTween.tween(lime.app.Application.current.window, {opacity: 0}, 1);
        sdlTween.onComplete = nextState;
    }

    function nextState(tween:FlxTween):Void
    {
        if (Main.devVersion) FlxG.switchState(new TestScreen());
        else FlxG.switchState(new menus.PlayState()); // lol.
    }
}