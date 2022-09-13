package internal;

import internal.TransparentWindowBG;

class Transparency
{
	// // [DllImport("user32.dll", EntryPoint="SetWindowLongPtr")]
	// private static extern IntPtr SetWindowLongPtr64(IntPtr hWnd, int nIndex, IntPtr dwNewLong);

	// // [DllImport("user32.dll")]
	// public static extern bool SetLayeredWindowAttributes(IntPtr hwnd, uint crKey, byte bAlpha, uint dwFlags);

	// void main()
	// {
	// 	// create a window or something lOL
    //     // // // // // // // // private Dynamic _window = GetActiveWindow();
	// 	SetWindowLong32(_window.handle, -20, 0x00080000);
	// 	SetLayeredWindowAttributes(_window.handle, 0, 0, 0x00000001);
	// }
	public static function init(borderless:Bool)
	{
		// trace("attempting to make window transparent!!");
		TransparentWindowBG.setColorKey(0, lime.app.Application.current.window.title);
		Main.instance.setFPSVisibility(false);
		if (borderless)
			openfl.Lib.current.stage.window.borderless = true;
	}

	public static function uninit()
	{
		// trace("disabling transparency");
		TransparentWindowBG.removeColorKey(0, lime.app.Application.current.window.title);
		Main.instance.setFPSVisibility(true);
		if (openfl.Lib.current.stage.window.borderless)
			openfl.Lib.current.stage.window.borderless = false;
	}
}