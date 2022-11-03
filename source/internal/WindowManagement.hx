package internal;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.FlxGraphic;
import flixel.math.FlxMath;
import haxe.Constraints.Function;
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

    public static function create(animated:Bool, ?animName:String)
    {
        if (!setup)
        {
			lime.app.Application.current.onUpdate.add(update); // lol.
        }
        var win:FuckedWindow = new FuckedWindow(null, FlxG.random.int(0, Std.int(Capabilities.screenResolutionX / 2)), FlxG.random.int(0, Std.int(Capabilities.screenResolutionY / 2)), animated, animName);
        trace("scuff window creation");
    }

    private static function update(elapsed:Int) { for (win in windows) win.onUpdate(elapsed); }
}

class FuckedWindow
{
	public var window:Window;
	public var name:String;
	public var sprite:Sprite;
    public var callbacks:Array<Function> = []; // lol.

	public function new(?name:String, ?customX:Int, ?customY:Int, ?animated:Bool, ?animName:String)
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

        if (animated == null) animated = false;
        if (animName == null || animName == '') animated = false;

        if (animated) new FuckedAnimation(this, animName); // lol lets see if this works.

    }

    public function onUpdate(elapsed:Int) {
        for (func in callbacks) func();
        // trace("onUpdate [" + elapsed);
    }

    public function onClose():Void {
        trace("the window has been closed!!!!");
        WindowManagement.windows.remove(this);
    }
}

class FuckedAnimation {
    public var window:FuckedWindow;
    public var anim:String = "none";
	private var visiblility:Bool = true;

    // Stolen from my other project since I made it work.
    private var ogWindowX:Int;
	private var ogWindowY:Int;
	private var winOfsX:Int = 0;
	private var winOfsY:Int = 0;
	private var ofs:Int = 30;
    
    public function new(trackthis:FuckedWindow, animation:String)
    {
        window = trackthis;
        anim = animation;
        ogWindowX = trackthis.window.x;
        ogWindowY = trackthis.window.y;
        trackthis.callbacks.push(update);
        trackthis.window.onFocusOut.add(onFocusOut); // lol.
    }

    private function processAnimation() {
		var curWindowY:Int = 0;
		var nextWindowY:Int = 0;
		var windowY:Int = 0;
		var curWindowX:Int = 0;
		var nextWindowX:Int = 0;
		var windowX:Int = 0;
        // do math!
        curWindowY = window.window.y;
        nextWindowY = ogWindowY + winOfsY;
        // x math!
		curWindowX = window.window.x;
		nextWindowX = ogWindowX + winOfsX;
        // setup gay movement
		windowY = Std.int(FlxMath.lerp(curWindowY, nextWindowY, 0.08));
		windowX = Std.int(FlxMath.lerp(curWindowX, nextWindowX, 0.08));
        // move
        move(windowX, windowY);
		playAnim();
    }

    private function move(x:Int, y:Int) { if (!(window.window.x == x && window.window.y == y)) window.window.move(x, y); } // one line is all.
    // Animation.
    private function playAnim() {
        switch (anim) {
            case 'left':
                winOfsX = -100;
                winOfsY = 0;
			case 'right':
				winOfsX = 100;
				winOfsY = 0;
            case 'glitch':
                winOfsX = FlxG.random.int(-100, 100);
                winOfsY = FlxG.random.int(-100, 100);
        }
    }

    public function update():Void {
        if (visiblility) processAnimation();
    }

    private function onFocusOut() {
        window.window.focus();
    }
}