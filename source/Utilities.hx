package;

import internal.FlxTransWindow; // import.

class Utilities
{
    public static function setTransparency(bool:Bool)
    {
        trace("transparency was set to: " + bool);
        if (bool)
        {
            // Setup the transparency in the window.
            lime.app.Application.window.opacity = 0;
        }
        else
        {
            // Disable the transparency in the window.
            lime.app.Application.window.opacity = 1;
        }
    }

    public static function createWindow()
    {
        internal.WindowManagement.createWindow(); // test.
    }
}