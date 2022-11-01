package internal;

import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import hscript.Interp;
import hscript.Parser;
import llua.Convert;
import llua.Lua;
import llua.LuaL;
import llua.State;
import menus.PlayState;

using StringTools;
#if sys
import sys.FileSystem;
import sys.io.File;
#end


class LuaScript
{
	public static var Function_Stop:Dynamic = 1;
	public static var Function_Continue:Dynamic = 0;
	public static var Function_StopLua:Dynamic = 2;
    public var lua:State = null;
    public var scriptName = '';
    public var closed:Bool = false;

	#if hscript
	public static var haxeInterp:Interp = null;
	#end

    public function new(script:String) {
        lua = LuaL.newstate();
        LuaL.openlibs(lua);
        Lua.init_callbacks(lua);
        trace("Lua version: " + Lua.version());
        trace("LuaJIT version: " + Lua.versionJIT());
        try {
            var result:Dynamic = LuaL.dofile(lua, script);
            var resultStr:String = Lua.tostring(lua, result);
            if (resultStr != null && result != 0) {
                trace("An error occurred while trying to load lua script! | " + resultStr);
                lime.app.Application.current.window.alert(resultStr, "Internal Lua Script Error");
                lua = null;
                return;
            }
        } catch (e:Dynamic) {
            trace(e);
            return;
        }
        scriptName = script;
        trace("Lua file was loaded successfully: " + script);

        // Start creating Lua functions.
        set('Function_StopLua', Function_StopLua);
        set('Function_Stop', Function_Stop);
        set('Function_Continue', Function_Continue);
        set('luaDebugMode', false);
        set('luaDeprecatedWarnings', true);

        // Set variables that Lua can get!
        set('version', Main.engineCoreVersion.trim());
        set('devVersion', Main.devVersion);
        set('buildTarget', 'Windows');

        // Implement functions
		Lua_helper.add_callback(lua, "runHaxeCode", function(codeToRun:String) {
			#if hscript
			initHaxeInterp();

			try {
				var myFunction:Dynamic = haxeInterp.expr(new Parser().parseString(codeToRun));
				myFunction();
			} catch (e:Dynamic) {
				switch (e) {
					case 'Null Function Pointer', 'SReturn':
					// nothing
					default:
						luaTrace(scriptName + ":" + lastCalledFunction + " - " + e, false, false, FlxColor.RED);
				}
			}
			#end
		});

        Lua_helper.add_callback(lua, "openPopup", function() {
            trace("lua based popup event!");
            internal.WindowManagement.create(); // lol.
        });

        Lua_helper.add_callback(lua, "trace", function(text:String) {
            trace('[LUA | ${scriptName}]: ' + text);
        });

        call('onCreate', []);
        // Done!
    }

    var lastCalledFunction:String = '';
	public function call(func:String, args:Array<Dynamic>): Dynamic{
		if(closed) return Function_Continue;

		lastCalledFunction = func;
		try {
			if(lua == null) return Function_Continue;

			Lua.getglobal(lua, func);
			
			for(arg in args) {
				Convert.toLua(lua, arg);
			}

			var result:Null<Int> = Lua.pcall(lua, args.length, 1, 0);
			var error:Dynamic = getErrorMessage();
			if(!resultIsAllowed(lua, result))
			{
				Lua.pop(lua, 1);
				if(error != null) luaTrace("ERROR (" + func + "): " + error, false, false, FlxColor.RED);
			}
			else
			{
				var conv:Dynamic = Convert.fromLua(lua, result);
				Lua.pop(lua, 1);
				if(conv == null) conv = Function_Continue;
				return conv;
			}
			return Function_Continue;
		}
		catch (e:Dynamic) {
			trace(e);
		}
		return Function_Continue;
	}

    function getErrorMessage() {
		var v:String = Lua.tostring(lua, -1);
		if(!isErrorAllowed(v)) v = null;
		return v;
	}

    function resultIsAllowed(leLua:State, leResult:Null<Int>) { //Makes it ignore warnings
		return Lua.type(leLua, leResult) >= Lua.LUA_TNIL;
	}

	function isErrorAllowed(error:String) {
		switch(error)
		{
			case 'attempt to call a nil value' | 'C++ exception':
				return false;
		}
		return true;
	}

    public function set(variable:String, data:Dynamic) {
		if(lua == null) {
			return;
		}
		Convert.toLua(lua, data);
		Lua.setglobal(lua, variable);
	}

    public function getBool(variable:String) {
		var result:String = null;
		Lua.getglobal(lua, variable);
		result = Convert.fromLua(lua, -1);
		Lua.pop(lua, 1);
		if(result == null) {
			return false;
		}
		return (result == 'true');
	}

	public function luaTrace(text:String, ignoreCheck:Bool = false, deprecated:Bool = false, color:FlxColor = FlxColor.WHITE) {
		if (ignoreCheck || getBool('luaDebugMode')) {
			if (deprecated && !getBool('luaDeprecatedWarnings')) {
				return;
			}
			trace("[LUA TRACE]: " + text);
		}
	}

    // Haxe code shit!
	#if hscript
	public function initHaxeInterp() {
		if (haxeInterp == null) {
			haxeInterp = new Interp();
			haxeInterp.variables.set('FlxG', FlxG);
			haxeInterp.variables.set('FlxSprite', FlxSprite);
			haxeInterp.variables.set('FlxCamera', FlxCamera);
			haxeInterp.variables.set('FlxTween', FlxTween);
			haxeInterp.variables.set('FlxEase', FlxEase);
			haxeInterp.variables.set('PlayState', PlayState);
			haxeInterp.variables.set('game', PlayState.instance);
			haxeInterp.variables.set('StringTools', StringTools);

			haxeInterp.variables.set('setVar', function(name:String, value:Dynamic) {
				PlayState.instance.variables.set(name, value);
			});
			haxeInterp.variables.set('getVar', function(name:String) {
				if (!PlayState.instance.variables.exists(name))
					return null;
				return PlayState.instance.variables.get(name);
			});
		}
	}
	#end
}