package;

import menus.SetupScreen;
import layout.FPS;
import layout.Volume;
import lime.graphics.Image;
import flixel.util.FlxColor;
import openfl.events.Event;
import flixel.FlxG;
import flixel.FlxGame;
import flixel.FlxState;
import openfl.display.Sprite;
import openfl.Lib;

using StringTools;

class Main extends Sprite
{
    var gameTitle:String = "Desktop Window Manager"; // The name of the game's window. (just as a default thing so when it starts, it has something.)
	var gameWidth:Int = 1280; // Width of the game in pixels (might be less / more in actual pixels depending on your zoom).
	var gameHeight:Int = 720; // Height of the game in pixels (might be less / more in actual pixels depending on your zoom).
	var initialState:Class<FlxState> = menus.SetupScreen; // The FlxState the game starts with.
	var zoom:Float = -1; // If -1, zoom is automatically calculated to fit the window dimensions.
	var framerate:Int = 60; // How many frames per second the game should run at.
	public static var skipSplash:Bool = true; // Whether to skip the flixel splash screen that appears in release mode.
	var startFullscreen:Bool = false; // Whether to start the game in fullscreen on desktop targets
	public static var instance:Main; // Makes it possible so you can affect the entire game.


	public static var gameTitlePrefix = "Desktop Window Manager | "; // the prefix that can be changed!
	public static var devVersion:Bool = false; // Shows if the release of the current game is a development branch release.
	public static var engineCoreVersion:String = "v0.2"; // This isn't running on a engine anymore.
	public static var synthexFontName = "SF-Pro.ttf"; // The font that is used for modifications!


    public static function main():Void { Lib.current.addChild(new Main()); }

    public function new()
	{
		super();

		if (stage != null) init();
		else addEventListener(Event.ADDED_TO_STAGE, init);
	}

    private function init(?E:Event):Void
	{
		if (hasEventListener(Event.ADDED_TO_STAGE)) removeEventListener(Event.ADDED_TO_STAGE, init);
		setupGame();
	}

	public static var restartedGame:Bool = false;

    private function setupGame():Void
	{
		instance = this;
		#if DEV
		devVersion = true;
		trace("Developer mode was compiled into the window. Automatically changing it!");
		#else
		devVersion = false;
		#end
		// HaxeFlixel creation into the OpenFL window.
		var stageWidth:Int = Lib.current.stage.stageWidth;
		var stageHeight:Int = Lib.current.stage.stageHeight;
		if (zoom == -1)
		{
			var ratioX:Float = stageWidth / gameWidth;
			var ratioY:Float = stageHeight / gameHeight;
			zoom = Math.min(ratioX, ratioY);
			gameWidth = Math.ceil(stageWidth / zoom);
			gameHeight = Math.ceil(stageHeight / zoom);
		}
		initialState = SetupScreen;
		game = new FlxGame(gameWidth, gameHeight, initialState, zoom, framerate, framerate, skipSplash, startFullscreen);
		addChild(game);

		// HaxeFlixel was loaded in correctly, start making changes!
		changeWindowTitle("Loading...", false);
		changeIcon("assets/icons/256.png"); // lol!

		#if !mobile
		fpsCounter = new FPS(10, 3, 0xFFFFFF);
		addChild(fpsCounter); // the most important child for information!
		setFPSVisibility(false); // not important ill change it later.

		// very special child for important work
		volumeGUI = new Volume(200, 3, 0xFFFFFF); // x: 110
		addChild(volumeGUI); // the most important child for information!
		volumeGUI.visible = false; // AnnoyingProgram disabled this.
		#end

		setExitHandler(Utilities.onQuit);

		var args = Sys.args();
		for (arg in args)
		{
			trace("argument located: " + arg);
			if (arg.contains("-exitattempt"))
			{
				trace("So the game was restarted because it was closed incorrectly.");
				restartedGame = true;
			}
			if (arg.contains("-debug"))
			{
				trace("Enabling dev version...");
				Main.devVersion = true;
				layout.FPS.fpsPrefix = "DEV PREVIEW\n";
			}
		}

		FlxG.autoPause = false;
		FlxG.console.autoPause = false;
		FlxG.drawFramerate = 60; // lol.
	}

	var game:FlxGame;

	public var fpsCounter:FPS;
    var volumeGUI:Volume; // lol

	public static function changeWindowTitle(text:String, raw:Bool)
	{
		if (raw) lime.app.Application.current.window.title = text;
		else lime.app.Application.current.window.title = gameTitlePrefix + text;
	}

	static var iconDirectorySet:String = "nothing";

	public static function changeIcon(directory:String)
	{
		var pullPath:String = directory;
		// check if already set.
		if (iconDirectorySet == directory)
		{
			trace("Icon already set. Cannot change icon at the moment.");
			return;
		}
		// continue
		var icon:Image = Image.fromFile(pullPath);
		if (icon == null) trace("INVAILD IMAGE DIRECTORY, PLEASE TRY AGAIN WITH A VAILD DIRECTORY.");
		else
		{
			iconDirectorySet = directory; // make sure the icon is saved so it doesnt keep spamming icon.
			#if !(web)
			trace("Loading in a new icon from directory: " + directory);
			lime.app.Application.current.window.setIcon(icon);
			#else
			trace("Failure to load icon due to icon calls on HTML5 breaking. Sorry!\nWould've loaded from: " + directory);
			#end
		}
	}

	static function setExitHandler(func:Void->Void):Void {
		#if openfl_legacy
		openfl.Lib.current.stage.onQuit = function() {
			func();
			openfl.Lib.close();
		};
		#else
		openfl.Lib.current.stage.application.onExit.add(function(code) {
			func();
		});
		#end
	}


	// UNNECCESSARY CODE SHIT

	public function setFPSVisibility(fpsEnabled:Bool):Void { fpsCounter.visible = fpsEnabled; }
	public function changeFPSColor(color:FlxColor) { fpsCounter.textColor = color; }
	public static function setFPSCap(cap:Float) { openfl.Lib.current.stage.frameRate = cap; } // made static
	public function getFPSCap():Float { return openfl.Lib.current.stage.frameRate; }
	public function getFPS():Float { return fpsCounter.currentFPS; }
}