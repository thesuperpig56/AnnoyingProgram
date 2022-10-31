package;

import sys.FileSystem;
import flixel.FlxG;
import lime.graphics.Image;
import lime.utils.Assets;
import openfl.display.BitmapData;
import internal.FlxTransWindow; // import.
import Sys;

class Utilities
{

    public static var allowedToClose:Bool = false;

    public static function onQuit()
    {
        trace("Detected that the window is closing.");
        trace("Allowed to close?: " + allowedToClose);
        if (!allowedToClose) restart(); // lol.
        else trace("no issues here! letting the window close.");
    }

    public static function setWindowTransparency(bool:Bool)
    {
        trace("sdl transparency was set to: " + bool);
        if (bool) lime.app.Application.current.window.opacity = 0;
        else lime.app.Application.current.window.opacity = 1;
    }

    public static function setBackgroundTransparency(bool:Bool)
    {
        trace("bg transparency was set to: " + bool);
        if (bool) internal.FlxTransWindow.getWindowsTransparent();
        else internal.FlxTransWindow.getWindowsbackward();
    }

    public static function getImagePixels(id:String):BitmapData { return openfl.Assets.getBitmapData(id); }

    public static function getRandomImagePixels():BitmapData
    {
        var array = FileSystem.readDirectory("assets/images");
        // pull random shit out of array.
        var int = array.length;
        var data = getImagePixels("assets/images/" + array[FlxG.random.int(0, int - 1)]);
        return data;
    }

    public static function getAllImagesArray():Array<String> { return FileSystem.readDirectory("assets/images"); }

    public static function popupWindow()
    {
        // internal.WindowManagement.instance.popupWindow(1280, 720, 500, "Name"); // test.
        // broken don't use.
    }

    public static function restart()
	{
		#if cpp
		var os = Sys.systemName();
		var args = "-exitattempt";
        if (Main.devVersion) args += " -debug";
		var app = "";
		var workingdir = Sys.getCwd();

		FlxG.log.add(app);

		app = Sys.programPath();

		// Launch application:
		var result = systools.win.Tools.createProcess(app // app. path
			, args // app. args
			, workingdir // app. working directory
			, false // do not hide the window
			, false // do not wait for the application to terminate
		);
		// Show result:
		if (result == 0) Sys.exit(0);
		else throw "Failure to restart Desktop Window Manager";
		#end
	}


}