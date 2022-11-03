package internal;

using StringTools;

class IncorrectCounter
{
    public static var counter(default, set):Int = 0;
    
	static function set_counter(value:Int):Int {
		return counter = value;
	}

    public static function isThisIt(text:String) {
        text = text.trim();
        var value = Std.parseInt(text);
        if (value != null) counter = value;
    }

    public static function getNewText():String {
        counter += 1;
        switch (counter) {
            case 0: return "this message isnt supposed to show so haha hehe haha im so smart if this doesnt show up";
            case 1: return "Nice try.";
            case 2: return "Failed again huh?";
            case 3: return "Three times.\nAmazing how you failed.";
            case 4: return "Ok, four times now.";
            case 5: return "FIVE? I am surprised at that.";
            case 6: return "Ok, this is starting to be\na sad thing now to me.";
            case 7: return "Seven is too much now.";
            case 8: return "I am running out of ideas\nfor these dialogue messages.";
            case 9: return "Please actually close it next time correctly.";
            case 50: return "You are so terrible.";
            case 51: return "I'll allow you to close it now. Go ahead.";
            case 52:
                Utilities.allowedToClose = true;
                Sys.exit(0);
				return "Take a break, I'll do it.\nI still can't believe this.";
            default: return "Failed exit attempts:\n" + counter;
        }
    }
}