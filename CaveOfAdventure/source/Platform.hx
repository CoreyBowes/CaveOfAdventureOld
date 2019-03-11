package;

import flixel.FlxSprite;
import flixel.FlxObject;
import flixel.util.FlxColor;

class Platform extends FlxSprite
{
    static var _baseWidth = 100;
    static var _baseHeight = 5;

	public function new(?xPos:Float=0, ?yPos:Float=0, ?platWidth=100, platHeight=5)
	{
		super(xPos, yPos);
        makeGraphic(platWidth, platHeight, FlxColor.WHITE, true);
        immovable = true;
        allowCollisions = FlxObject.UP;
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
}
