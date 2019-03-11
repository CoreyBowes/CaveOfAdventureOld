package;

import flixel.FlxG;
import flixel.util.FlxColor;

class EnemyJumper extends Enemy
{
    public var _jumpTimer:Float = 0;
    public var _jumpInterval:Float = 3;

	public function new(?xPos:Float=0, ?yPos:Float=0, ?enemyWidth=8, ?enemyHeight=8, ?platformOn=null)
	{
		super(xPos, yPos, enemyWidth, enemyHeight, platformOn);
        makeGraphic(enemyWidth, enemyHeight, FlxColor.PURPLE);
        acceleration.y = 600;
	}

	override public function update(elapsed:Float):Void
	{
        FlxG.collide(this, Reg.LVL._platforms);
        _jumpTimer += elapsed;
        if(_jumpTimer > _jumpInterval)
        {
            _jumpTimer -= _jumpInterval;
            velocity.y = -200;
        }
		super.update(elapsed);
	}
}
