package internal;

import internal.TransparentWindowBG;

class Transparency
{
	public static function init(borderless:Bool)
	{
		// trace("attempting to make window transparent!!");
		TransparentWindowBG.setColorKey(0, lime.app.Application.current.window.title);
		Main.instance.setFPSVisibility(false);
		if (borderless) openfl.Lib.current.stage.window.borderless = true;
			
	}

	public static function uninit()
	{
		// trace("disabling transparency");
		TransparentWindowBG.removeColorKey(0, lime.app.Application.current.window.title);
		Main.instance.setFPSVisibility(true);
		if (openfl.Lib.current.stage.window.borderless) openfl.Lib.current.stage.window.borderless = false;
	}
}