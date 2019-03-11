package;

import flixel.FlxSprite;
import flixel.FlxObject;
import flixel.util.FlxColor;

class MovingPlatform extends Platform
{
    static var _speed = 20;
    static var _rangeTop = 50;
    static var _rangeBottom = 350;

	public function new(?xPos:Float=0, ?yPos:Float=0, ?platWidth=100, platHeight=5)
	{
		super(xPos, yPos, platWidth, platHeight);
        velocity.y = -_speed;
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
        if(y < _rangeTop)
        {
            velocity.y = _speed;
        }
        else if(y > _rangeBottom)
        {
            velocity.y = -_speed;
        }
	}
}
