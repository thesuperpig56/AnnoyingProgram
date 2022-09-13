package internal;

import openfl.Lib;
import flixel.graphics.FlxGraphic;
import openfl.display.Bitmap;
import flixel.FlxG;
import flixel.FlxSprite;
import lime.app.Application;
import lime.graphics.RenderContext;
import lime.ui.MouseButton;
import lime.ui.KeyCode;
import lime.ui.KeyModifier;
import lime.ui.Window;
import openfl.geom.Matrix;
import openfl.geom.Rectangle;
import openfl.display.Sprite;
import openfl.utils.Assets;

class WindowManagement
{
    var window:Window;
    var dadWin = new Sprite();
    var casualImage = new Sprite();
    public static var instance:WindowManagement;

    public function main()
    {
        instance = this;
    }

    // Finish this at home using the GitHub link:
    // https://github.com/DuskieWhy/Transparent-and-MultiWindow-FNF

    public function popupWindow(customWidth:Int, customHeight:Int, ?customX:Int, ?customName:String) {
        var display = Application.current.window.display.currentMode;
        // PlayState.defaultCamZoom = 0.5;

		// if(customName == '' || customName == null){
		// 	customName = 'Opponent.json';
		// }

        window = Lib.application.createWindow({
            title: customName,
            width: customWidth,
            height: customHeight,
            borderless: false,
            alwaysOnTop: true

        });
		if(customX == null){
			customX = -10;
		}
        window.x = customX;
        window.y = Std.int(display.height / 2);
        window.stage.color = 0xFF010101;
        @:privateAccess
        window.stage.addEventListener("keyDown", FlxG.keys.onKeyDown);
        @:privateAccess
        window.stage.addEventListener("keyUp", FlxG.keys.onKeyUp);
        // Application.current.window.x = Std.int(display.width / 2) - 640;
        // Application.current.window.y = Std.int(display.height / 2);

        var bg = FlxGraphic.fromAssetKey("assets/images/window1.jpg").bitmap;
        var spr = new Sprite();

        var m = new Matrix();

        spr.graphics.beginBitmapFill(bg, m);
        spr.graphics.drawRect(0, 0, bg.width, bg.height);
        spr.graphics.endFill();
        FlxG.mouse.useSystemCursor = true;

        //Application.current.window.resize(640, 480);



        // dadWin.graphics.beginBitmapFill(dad.pixels, m);
        // dadWin.graphics.drawRect(0, 0, dad.pixels.width, dad.pixels.height);
        // dadWin.graphics.endFill();
        // dadScrollWin.scrollRect = new Rectangle();
	    // windowDad.stage.addChild(spr);
        // windowDad.stage.addChild(dadScrollWin);
        // dadScrollWin.addChild(dadWin);
        // dadScrollWin.scaleX = 0.7;
        // dadScrollWin.scaleY = 0.7;
        // dadGroup.visible = false;

        window.stage.addChild(spr);
        casualImage.visible = true;
        // uncomment the line above if you want it to hide the dad ingame and make it visible via the windoe
        Application.current.window.focus();
	    	FlxG.autoPause = false;
    }
}