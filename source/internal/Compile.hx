package internal;

import openfl.system.Capabilities;

using StringTools;

class Compile
{
    public static macro function getWhenCompiled():haxe.macro.Expr.ExprOf<String> {
        var time:String = Date.now().toString();
        time = time.trim();
        return macro $v{time};
    }

    public static macro function getOS():haxe.macro.Expr.ExprOf<String> {
        var response = "";
        var os = Capabilities.os;
        response = '${os}';
        return macro $v{response};
    }

    // Command based macros.

    public static macro function getGitHash():haxe.macro.Expr.ExprOf<String> {
		#if !display
		var process = new sys.io.Process("git", ["rev-parse", "HEAD"]);
		if (process.exitCode() != 0) {
			var message = process.stderr.readAll().toString();
			var pos = haxe.macro.Context.currentPos();
			haxe.macro.Context.error("Cannot execute `git rev-parse HEAD`. " + message, pos);
		}
		var commitHash:String = process.stdout.readLine();
		return macro $v{commitHash};
		#else
		var commitHash:String = "null";
		return macro $v{commitHash};
		#end
    }

    public static macro function getCwdResponse(cmd:String, arg:Array<String>):haxe.macro.Expr.ExprOf<String> {
		#if !display
		var process = new sys.io.Process(cmd, arg);
		if (process.exitCode() != 0) {
			var message = process.stderr.readAll().toString();
			var pos = haxe.macro.Context.currentPos();
			haxe.macro.Context.error('Cannot execute `${cmd} | arguments: ${arg}`. ' + message, pos);
		}
		var response:String = process.stdout.readLine();
		return macro $v{response};
		#else
		var response:String = "null";
		return macro $v{response};
		#end
    }
}