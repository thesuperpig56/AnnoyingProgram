package menus;

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
			"Hmm.\nIt appears that the game tried to move\nto another state but since it wasn't set\nyou were moved here instead.\nThe game is soft-locked.", 32);
		txt.setFormat("assets/fonts/SF-Pro.ttf", 32, FlxColor.WHITE, CENTER);
		txt.screenCenter();
		add(txt);
		bgText = txt;
		Main.changeWindowTitle("Showing the test screen.", false);
    }

	override function update(elapsed:Float) {
		super.update(elapsed);
		// if (FlxG.keys.justPressed.G)
		// {
		// 	Utilities.popupWindow();
		// }
		#if DISABLESOFTLOCK
		if (FlxG.keys.justPressed.ESCAPE)
		{
			trace("SOFTLOCK DISABLED. ESCAPING!");
			FlxG.switchState(new menus.ModuleLoader());
		}
		#end
	}
}