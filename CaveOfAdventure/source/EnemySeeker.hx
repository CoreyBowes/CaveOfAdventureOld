package;

import flixel.util.FlxColor;

class EnemySeeker extends Enemy
{
	public function new(?xPos:Float=0, ?yPos:Float=0, ?enemyWidth=8, ?enemyHeight=8, ?platformOn=null)
	{
		super(xPos, yPos, enemyWidth, enemyHeight, platformOn);
        makeGraphic(enemyWidth, enemyHeight, FlxColor.RED);
	}

	override public function update(elapsed:Float):Void
	{
        if(x > Reg.LVL._player.x && x > _platformOn.x)
        {
            velocity.x = -40;
        }
        else if(x < Reg.LVL._player.x && x+width < _platformOn.x+_platformOn.width)
        {
            velocity.x = 40;
        }
        else
        {
            velocity.x = 0;
        }
		super.update(elapsed);
	}
}
