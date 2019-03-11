package;

import flixel.FlxState;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.text.FlxText;

class AchievementsState extends FlxState
{
    /*
    Creates a page with a given number of achievement icons per row.
    Needs space for both the achievement icon and the text that goes with it.
    Need some way to mark which achievements have been completed.
    */
	override public function create():Void
	{
		super.create();

        /*
        */
        FlxG.debugger.visible = true;
        FlxG.log.redirectTraces = true;
        FlxG.debugger.setLayout(RIGHT);
        FlxG.debugger.setLayout(MICRO);
        FlxG.debugger.drawDebug = true;

        add(new FlxText(0, 0, 0, "Achievements"));
        var achievementsPerRow:Int = 4;
        var xPos:Float = 20; // Starting x position for the achievements.
        var yPos:Float = 20; // Starting y position for the achievements.
        var iconSideLength:Float = 40;
        var textWidth:Float = 100;
        var textMargin:Float = 5;
        var rowHeight:Float = 100;
        var achievementsWidth:Float = FlxG.width-(yPos*2)-iconSideLength-textWidth-textMargin;

        var outsideTestIcon = new FlxSprite();
        // outsideTestIcon.loadGraphicFromSprite(Achievements._achievementsList[1]._icon); // Also fails.
        for(i in 0...Achievements._achievementsList.length)
        {
            trace("Drawing achievement "+i);
            var currentIcon = new FlxSprite();
            var currentName = new FlxText();
            var currentDescription = new FlxText();
            var backFrame = new FlxSprite();

            if(Achievements._achievementsList[i]._unlocked)
            {
                backFrame.makeGraphic(Std.int(iconSideLength+4), Std.int(iconSideLength+4), FlxColor.LIME);
            }
            else
            {
                backFrame.makeGraphic(Std.int(iconSideLength+4), Std.int(iconSideLength+4), FlxColor.WHITE);
            }
            backFrame.setPosition(xPos+(i%achievementsPerRow)*achievementsWidth/(achievementsPerRow-1)-2, 
            yPos+Std.int(i/achievementsPerRow)*rowHeight-2);
            add(backFrame);

            if(Achievements._achievementsList[i]._icon != null)
            {
                // currentIcon = Achievements._achievementsList[i]._icon;
                trace("Drawing icon.");
                try 
                {
                    var testIcon = new FlxSprite();
                    testIcon.loadGraphicFromSprite(FancyDraw.getHeartIcon(40, 40)); // This code runs fine.
                    // add(testIcon);
                    // add((Achievements._achievementsList[i]._icon));
                    currentIcon.loadGraphicFromSprite(Achievements._achievementsList[i]._icon); // This line causes the rest of the code to not execute.
                } 
                catch( msg : String ) 
                {
                    trace("Error occurred: " + msg);
                }
                trace("Icon drawn.");
               // currentIcon.makeGraphic(Std.int(iconSideLength), Std.int(iconSideLength), FlxColor.YELLOW);
            }
            currentIcon.setPosition(xPos+(i%achievementsPerRow)*achievementsWidth/(achievementsPerRow-1), 
            yPos+Std.int(i/achievementsPerRow)*rowHeight);
            add(currentIcon);
            trace("Current icon position: "+currentIcon.x+", "+currentIcon.y+"; width: "+currentIcon.width);

            currentName = new FlxText(xPos+(i%achievementsPerRow)*achievementsWidth/(achievementsPerRow-1)+iconSideLength+textMargin, 
            yPos+Std.int(i/achievementsPerRow)*rowHeight, textWidth, Achievements._achievementsList[i]._name, 10);
            add(currentName);

            currentDescription = new FlxText(xPos+(i%achievementsPerRow)*achievementsWidth/(achievementsPerRow-1)+iconSideLength+textMargin, 
            yPos+Std.int(i/achievementsPerRow)*rowHeight+currentName.height, textWidth, Achievements._achievementsList[i]._description, 8);
            add(currentDescription);
        }
        trace("Total sprites: "+members.length);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
}
