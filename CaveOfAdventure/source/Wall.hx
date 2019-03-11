package;

import flixel.FlxSprite;
import flixel.FlxObject;
import flixel.util.FlxColor;

class Wall extends FlxSprite
{
    static var _baseWidth = 5;
    static var _baseHeight = 100;

	public function new(?xPos=0, ?yPos=0, ?wallWidth=5, wallHeight=100)
	{
		super(xPos, yPos);
        makeGraphic(wallWidth, wallHeight, FlxColor.WHITE);
        immovable = true;
        allowCollisions = FlxObject.ANY;
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
}
