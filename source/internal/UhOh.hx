package internal;

import haxe.CallStack.StackItem;
import haxe.CallStack;
import haxe.io.Path;
import lime.app.Application;
import sys.FileSystem;
import sys.io.File;

using StringTools;
#if CRASH_HANDLER
import openfl.events.UncaughtErrorEvent;
#end


class UhOh
{
    #if CRASH_HANDLER
    public static function onCrash(e: UncaughtErrorEvent) {
        var errMsg:String = "";
        var path:String;
        var callStack:Array<StackItem> = CallStack.exceptionStack(true);
        var dateNow:String = Date.now().toString();
        dateNow = dateNow.replace(" ", "_");
        dateNow = dateNow.replace(":", "'");
        path = './crash/AnnoyingProgram_${dateNow}.txt';
        for (stackItem in callStack) {
            switch (stackItem) {
                case FilePos(s, file, line, column): errMsg += file + ' (line ${line})\n';
                default: Sys.println(stackItem);
            }
        }
        errMsg += '\nUncaught error: \n${e.error} \n\nThis is not supposed to occur so, whoops!\n\n\n> Crash handler was based on code from sqirra-rng';
        if (!FileSystem.exists("./crash/")) FileSystem.createDirectory("./crash/");
        File.saveContent(path, errMsg + '\n');
        Sys.println(errMsg);
        Sys.println("Crash dump was saved in: " + Path.normalize(path));
        Application.current.window.alert(errMsg, "Uh oh!");
        WindowManagement.closeAllWindows(); // Don't keep those windows open!
        Sys.exit(1);
    }
    #end
}