package internal;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.FlxGraphic;
import lime.app.Application;
import lime.graphics.RenderContext;
import lime.ui.KeyCode;
import lime.ui.KeyModifier;
import lime.ui.MouseButton;
import lime.ui.Window;
import openfl.Lib;
import openfl.display.Bitmap;
import openfl.display.Sprite;
import openfl.geom.Matrix;
import openfl.geom.Rectangle;
import openfl.utils.Assets;

class WindowManagement
{
    public static var windows:Array<FuckedWindow> = [];

    public static function closeAllWindows() {
        var int:Int = 0;
        for (win in windows)
        {
            win.window.close();
            int++;
        }
        if (int > 0) trace("Window Management has closed " + '"${int}" windows.');
    }

    public static function create()
    {
        var win:FuckedWindow = new FuckedWindow();
        trace("scuff window creation");
    }
}

class FuckedWindow
{
	public var window:Window;
	public var name:String;
	public var sprite:Sprite;

	public function new(?name:String, ?customX:Int, ?customY:Int)
    {
        var display = Application.current.window.display.currentMode;
		if (name == '' || name == null) { name = "Wowzers!"; }
		window = Lib.application.createWindow({
			title: name,
			width: 500,
			height: 400,
			borderless: false,
			alwaysOnTop: false
		});
        if (customX == null) { customX = -10; }
        if (customY == null) { customY = Std.int(display.height * 0.37); }
		window.x = customX;
		window.y = customY; // Std.int(display.height * 0.37);
		window.stage.color = 0xFF010101;
        @:privateAccess
		window.stage.addEventListener("keyDown", FlxG.keys.onKeyDown);
        @:privateAccess
		window.stage.addEventListener("keyUp", FlxG.keys.onKeyUp);
		window.stage.window.onClose.add(onClose);
        //
		Application.current.window.focus();
		FlxG.autoPause = false;

		FlxG.drawFramerate = 60;
		FlxG.updateFramerate = 60;
        WindowManagement.windows.push(this);
    }

    public function onClose():Void {
        trace("the window has been closed!!!!");
        WindowManagement.windows.remove(this);
    }
}