package;

import flixel.FlxSprite;
import flixel.util.FlxColor;

class Enemy extends FlxSprite
{
    static public var _baseWidth = 8;
    static public var _baseHeight = 8;
    public var _platformOn:FlxSprite;

	public function new(?xPos:Float=0, ?yPos:Float=0, ?enemyWidth=8, ?enemyHeight=8, ?platformOn=null, ?findPlatform=false)
	{
		super(xPos, yPos);
        makeGraphic(enemyWidth, enemyHeight, FlxColor.LIME);
        _platformOn = platformOn;
        velocity.x = 40;
        if(findPlatform)
        {
            _platformOn = Reg.LVL.findPlatformUnder(x, y);
        }
	}

    static public function spawnOnPlatform(spawnPlatform:FlxSprite):Enemy
    {
        return new Enemy();
    }

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
        if(_platformOn != null)
        {
            if(x < _platformOn.x)
            {
                velocity.x = 40;
            }
            if(x+width > _platformOn.x+_platformOn.width)
            {
                velocity.x = -40;
            }
        }
	}
}
