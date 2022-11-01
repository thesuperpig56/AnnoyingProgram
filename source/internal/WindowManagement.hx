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
import openfl.events.EventType;
import openfl.geom.Matrix;
import openfl.geom.Rectangle;
import openfl.system.Capabilities;
import openfl.utils.Assets;

class WindowManagement
{
    public static var windows:Array<FuckedWindow> = [];
    public static var setup:Bool = false;

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
        if (!setup)
        {
			lime.app.Application.current.onUpdate.add(update); // lol.
        }
        var win:FuckedWindow = new FuckedWindow(null, FlxG.random.int(0, Std.int(Capabilities.screenResolutionX / 2)), FlxG.random.int(0, Std.int(Capabilities.screenResolutionY / 2)));
        trace("scuff window creation");
    }

    private static function update(elapsed:Int) { for (win in windows) win.onUpdate(elapsed); }
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
        trace("Window was created at [x: " + customX + ", y: " + customY + "]");
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

    public function onUpdate(elapsed:Int) {
        // trace("onUpdate [" + elapsed);
    }

    public function onClose():Void {
        trace("the window has been closed!!!!");
        WindowManagement.windows.remove(this);
    }
}