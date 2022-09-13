package;

import menus.SetupScreen;
import internal.WindowManagement;
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
    var gameTitle:String = "Synthex Engine Core | "; // The name of the game's window. (just as a default thing so when it starts, it has something.)
	var gameWidth:Int = 1280; // Width of the game in pixels (might be less / more in actual pixels depending on your zoom).
	var gameHeight:Int = 720; // Height of the game in pixels (might be less / more in actual pixels depending on your zoom).
	var initialState:Class<FlxState> = menus.SetupScreen; // The FlxState the game starts with.
	var zoom:Float = -1; // If -1, zoom is automatically calculated to fit the window dimensions.
	var framerate:Int = 166; // How many frames per second the game should run at.
	public static var skipSplash:Bool = true; // Whether to skip the flixel splash screen that appears in release mode.
	var startFullscreen:Bool = false; // Whether to start the game in fullscreen on desktop targets
	public static var instance:Main; // Makes it possible so you can affect the entire game.


	public static var gameTitlePrefix = "Synthex Engine Core | "; // the prefix that can be changed!
	public static var devVersion:Bool = true; // Shows if the release of the current game is a development branch release.
	public static var engineCoreVersion:String = "v0.1"; // latest version of Synthex engine from github! This is the version that's running on it!
	public static var synthexFontName = "SF-Pro.ttf"; // The font that is used for modifications!


    public static function main():Void
	{
		Lib.current.addChild(new Main()); // its like the most important child because if its not used, it will be raped by errors.
	}


    public function new()
	{
		super();

		if (stage != null)
		{
			init();
		}
		else
		{
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
	}

    private function init(?E:Event):Void
	{
		if (hasEventListener(Event.ADDED_TO_STAGE))
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
		}

		setupGame();
	}


    private function setupGame():Void
	{
		instance = this;

		trace("nulling out stage color!");
		// stage.window.borderless = true;
		// stage.window.context.attributes.background = null; // please work
		Lib.current.stage.window.context.attributes.background = null; // lol
		Lib.current.opaqueBackground = null; // please.?
		Lib.current.stage.color = null; // ?
		Lib.current.stage.opaqueBackground = null;

		// this appears to be doing something? check later with compiling of windows.
		// link to where i found this: https://github.com/HaxeFlixel/flixel/issues/1981
		
		// FlxG.camera.bgColor = FlxColor.TRANSPARENT; // fuck please work i beg of u

		// #if cpp
		// trace("Loading transparency addon..");
		// Transparency.init(); // lol
		// #end
		// Transparency.init();

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

		// StateHandler.newState = new menus.PregameLoader();
		
		#if SKIPDEBUGCHECK
		trace("disabled debug check.");
		devVersion = false;
		#end
		
		initialState = SetupScreen;

		#if web
		trace("Disabling the background since we on the web");
		handlers.SaveHandler.backgroundVisible = false;
		#end

		game = new FlxGame(gameWidth, gameHeight, initialState, zoom, framerate, framerate, skipSplash, startFullscreen);

		addChild(game); // hopefully this child doesn't get bootytickled by errors. o_o

		changeWindowTitle("Loading...", false);
		changeIcon("assets/icons/256.png"); // lol!

		#if !mobile
		fpsCounter = new FPS(10, 3, 0xFFFFFF);
		addChild(fpsCounter); // the most important child for information!
		setFPSVisibility(true);
		// toggleFPS(FlxG.save.data.fps);

		// very special child for important work
		volumeGUI = new Volume(200, 3, 0xFFFFFF); // x: 110
		addChild(volumeGUI); // the most important child for information!
		volumeGUI.visible = true;
		#end

		WindowManagement.instance.main();

		// Utilities.setTransparency(true); // lol.

		#if CRASH_HANDLER
		trace("Crash Handler is now enabled!");
		Lib.current.loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, onCrash);
		#end
	}

	var game:FlxGame;

	var fpsCounter:FPS;
    var volumeGUI:Volume; // lol

	public static function changeWindowTitle(text:String, raw:Bool)
	{
		// trace('Attempting to change window title to: ' + text);
        var disguiseMode:Bool = false; // just here.
		if (disguiseMode)
		{
			// lime.app.Application.current.window.title = "GoGuardian Teacher - Enroll";
		}
		else
		{
			if (raw)
				lime.app.Application.current.window.title = text;
			else
				lime.app.Application.current.window.title = gameTitlePrefix + text;
		}
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
		if (icon == null)
		{
			trace("INVAILD IMAGE DIRECTORY, PLEASE TRY AGAIN WITH A VAILD DIRECTORY.");
		}
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


	// UNNECCESSARY CODE SHIT

	public function setFPSVisibility(fpsEnabled:Bool):Void {
		fpsCounter.visible = fpsEnabled;
	}

	public function changeFPSColor(color:FlxColor)
	{
		fpsCounter.textColor = color;
	}

	public static function setFPSCap(cap:Float) // made static
	{
		openfl.Lib.current.stage.frameRate = cap;
	}

	public function getFPSCap():Float
	{
		return openfl.Lib.current.stage.frameRate;
	}

	public function getFPS():Float
	{
		return fpsCounter.currentFPS;
	}


}