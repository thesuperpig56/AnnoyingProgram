package internal;

#if windows
@:native("HWND__") extern class HWNDStruct
{
}

typedef HWND = cpp.Pointer<HWNDStruct>;
typedef BOOL = Null<Int>;
typedef BYTE = Null<Int>;
typedef LONG = Null<Int>;
typedef DWORD = LONG;
typedef COLORREF = DWORD;

@:headerCode("#include <windows.h>")
#end
class TransparentWindowBG // ignore the errors lol it compiles fine
{
	#if windows
	@:native("FindWindowA") @:extern
	private static function findWindow(className:cpp.ConstCharStar, windowName:cpp.ConstCharStar):HWND
		return null;

	@:native("SetWindowLongA") @:extern
	private static function setWindowLong(hWnd:HWND, nIndex:Int, dwNewLong:LONG):LONG
		return null;

	@:native("SetLayeredWindowAttributes") @:extern
	private static function setLayeredWindowAttributes(hwnd:HWND, crKey:COLORREF, bAlpha:BYTE, dwFlags:DWORD):BOOL
		return null;

	@:native("GetLastError") @:extern
	private static function getLastError():DWORD
		return null;
        #end
	/*
        This sets a color so that whenever it appears, it becomes transparent. 
        Unsure if this can stack.
        Returns true if it succeeds, false if not.
        @param color Should be in a 0xAARRGGBB format.
        @param winName Just put the name of a (should be the game's) window, or better yet just 
        do something like openfl.Lib.current.application.window.title 
        */
	public static function setColorKey(color:Int, winName:String)
	{
		#if windows
		var win:HWND = findWindow(null, winName);
		if (win == null)
		{
			trace("Error finding window!");
			trace("Code: " + Std.string(getLastError()));
			return false;
		}
		if (setWindowLong(win, -20, 0x00080000) == 0)
		{
			trace("Error setting window to be layered!");
			trace("Code: " + Std.string(getLastError()));
			return false;
		}
		if (setLayeredWindowAttributes(win, color, 0, 0x00000001) == 0)
		{
			trace("Error setting color key on window!");
			trace("Code: " + Std.string(getLastError()));
			return false;
		}
		return true;
		#else
		trace("windows only lol");
		return false;
		#end
	}
	
 	/*
        This makes a color non-transparent. 
        Returns true if it succeeds, false if not.
        @param color Should be in a 0xAARRGGBB format.
        @param winName Just put the name of a (should be the game's) window, or better yet just 
        do something like openfl.Lib.current.application.window.title 
        */
	public static function removeColorKey(color:Int, winName:String)
	{
		#if windows
		var win:HWND = findWindow(null, winName);
		if (win == null)
		{
			trace("Error finding window!");
			trace("Code: " + Std.string(getLastError()));
			return false;
		}
		if (setWindowLong(win, -20, 0x00080000) == 0)
		{
			trace("Error setting window to be layered!");
			trace("Code: " + Std.string(getLastError()));
			return false;
		}
		if (setLayeredWindowAttributes(win, color, 0, 0x00000000) == 0)
		{
			trace("Error setting color key on window!");
			trace("Code: " + Std.string(getLastError()));
			return false;
		}
		return true;
		#else
			trace("windows only lolol");
		return false;
	        #end
	}
}
