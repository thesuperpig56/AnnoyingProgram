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
    private var windows:Array<FuckedWindow> = [];
    
}

class FuckedWindow
{
	public var window:Window;
	public var name:String;
	public var sprite:Sprite;

	public function new()
    {

    }
}