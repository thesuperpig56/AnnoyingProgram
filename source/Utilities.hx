package;

import flixel.FlxG;
import lime.graphics.Image;
import lime.utils.Assets;
import openfl.display.BitmapData;
import internal.FlxTransWindow; // import.

class Utilities
{

    public static var allowedToClose:Bool = false;

    public static function onQuit()
    {
        trace("Detected that the game is closing.");
        trace("Allowed to close?: " + allowedToClose);
        if (!allowedToClose)
        {
            trace("NOT ALLOWED, REOPENING..");
            restart(); // lol.
        }
    }

    public static function setWindowTransparency(bool:Bool)
    {
        trace("sdl transparency was set to: " + bool);
        if (bool)
        {
            // Setup the transparency in the window.
            lime.app.Application.current.window.opacity = 0;
        }
        else
        {
            // Disable the transparency in the window.
            lime.app.Application.current.window.opacity = 1;
        }
    }

    public static function setBackgroundTransparency(bool:Bool)
    {
        trace("bg transparency was set to: " + bool);
        if (bool)
        {
            internal.Transparency.init(true);
        }
        else
        {
            internal.Transparency.uninit();
        }
    }

    public static function getImagePixels(id:String):BitmapData
    {
        var image = openfl.Assets.getBitmapData(id);
        return image;
    }

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
		if (result == 0)
		{
			FlxG.log.add('SUS');
			Sys.exit(0);
		}
		else
			throw "Failure to restart Desktop Window Manager";
		#end
	}


}