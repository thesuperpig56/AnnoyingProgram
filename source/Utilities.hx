package;

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

    public static function popupWindow()
    {
        // internal.WindowManagement.instance.popupWindow(1280, 720, 500, "Name"); // test.
        // broken don't use.
    }


}