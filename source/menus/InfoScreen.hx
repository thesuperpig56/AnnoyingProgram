package menus;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.util.FlxColor;

class InfoScreen extends FlxState
{
	override function create() {
		super.create();
		PlayState.keysLocked = true;
		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.fromRGB(1, 1, 1));
		add(bg);
		var txt:FlxText = new FlxText(0, 0, FlxG.width, "Information screen. If you got here by\nmistake, close out the window and it'll\nreturn everything back to normal.", 32);
		txt.setFormat("assets/fonts/SF-Pro.ttf", 32, FlxColor.WHITE, CENTER);
		txt.screenCenter();
		add(txt);
		Main.changeWindowTitle("Information screen.", false);
		// version text.
		var verTxt:FlxText = new FlxText(12, FlxG.height - 24, 0, 'Compiled on: ${internal.Compile.getWhenCompiled()}', 12);
		verTxt.scrollFactor.set();
		verTxt.setFormat("assets/fonts/SF-Pro.ttf", 16, FlxColor.WHITE, LEFT);
		add(verTxt);
		// git
		var gitTxt:FlxText = new FlxText(12, FlxG.height - 44, 0, 'Git Branch ${internal.Compile.getCwdResponse("git", ["branch"])} | Git Hash: ${internal.Compile.getGitHash()}', 12);
		gitTxt.scrollFactor.set();
		gitTxt.setFormat("assets/fonts/SF-Pro.ttf", 16, FlxColor.WHITE, LEFT);
		add(gitTxt);
        // build system info
		var sysTxt:FlxText = new FlxText(12, FlxG.height - 64, 0, 'Compilation was made on a "${internal.Compile.getOS()}" system. | ${FlxG.VERSION.toString()}', 12);
		sysTxt.scrollFactor.set();
		sysTxt.setFormat("assets/fonts/SF-Pro.ttf", 16, FlxColor.WHITE, LEFT);
		add(sysTxt);
        // reveal
        internal.FlxTransWindow.getWindowsbackward();
		Main.changeWindowTitle("Application Manager " + Main.engineCoreVersion + " | Compilation Information", true);
	}

	override function update(elapsed:Float) {
		super.update(elapsed);
		// if (FlxG.keys.justPressed.ESCAPE) {
		// 	trace("Closing out the game.");
		// 	trace("Note: this bypasses the onExit handler since it's a system exit.");
		// 	Sys.exit(0); // lol.
		// }
	}
}