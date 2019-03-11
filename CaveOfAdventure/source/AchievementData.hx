package;

import flixel.FlxState;
import flixel.FlxSprite;
import openfl.display.BitmapData;

class AchievementData
{
    public var _name:String = "";
    public var _description:String = "";
    public var _unlocked:Bool = false;
    public var _icon:FlxSprite = null;
    public var _iconBitmap:BitmapData = null; // A possible way around the FlxSprite problem, if I can figure out how to store and load the image in a BitmapData object instead.
    public var _progress:Int = 0;
    public var _progressNeeded:Int = 1;

    public function new()
    {

    }
}
