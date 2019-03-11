package;

import flixel.FlxSprite;
import flixel.FlxObject;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;
import flixel.math.FlxPoint;

class Spike extends FlxSprite
{
    static var _baseWidth = 100;
    static var _baseHeight = 5;

	public function new(?xPos:Float=0, ?yPos:Float=0, ?platWidth=100, platHeight=5)
	{
		super(xPos, yPos);
        makeGraphic(platWidth, platHeight, FlxColor.WHITE, true);
        immovable = true;
        allowCollisions = FlxObject.UP;
        FlxSpriteUtil.fill(this, FlxColor.TRANSPARENT);
        var spikeVertices:Array<FlxPoint> = new Array();
        var numSpikes = Std.int(8*width/100);
        var spikeDepth = height/2;
        spikeVertices.push(new FlxPoint(0, spikeDepth));
        for(i in 0...numSpikes)
        {
            spikeVertices.push(new FlxPoint((i+0.5)*width/numSpikes, 0));
            spikeVertices.push(new FlxPoint((i+1)*width/numSpikes, spikeDepth));
        }
        FlxSpriteUtil.drawPolygon(this, spikeVertices, FlxColor.WHITE);
        FlxSpriteUtil.drawRect(this, 0, spikeDepth, width, (height-spikeDepth), FlxColor.WHITE);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
}
