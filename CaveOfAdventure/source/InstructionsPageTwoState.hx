package;

import flixel.FlxState;
import flixel.FlxG;
import flixel.ui.FlxButton;
import flixel.text.FlxText;

/*
State for the instructions page two. Work in progress.
*/
class InstructionsPageTwoState extends FlxState
{
    public var _titleText:FlxText;

	override public function create():Void
	{
		super.create();

        var instructionsStringSix = "Spikes will kill you if you touch them, naturally.";
        var instructionsTextSix = new FlxText(FlxG.width/2, 160, FlxG.width/2, instructionsStringSix, 12);
        var spikeIcon = new Spike(FlxG.width/4, 160);
        add(spikeIcon);

        var instructionsStringSeven = "Collect gold to earn your fortune.";
        var instructionsTextSeven = new FlxText(FlxG.width/2, 220, FlxG.width/2, instructionsStringSeven, 12);

        var instructionsStringEight = "Keys will open all doors on the level.";
        var instructionsTextEight = new FlxText(FlxG.width/2, 280, FlxG.width/2, instructionsStringEight, 12);

        add(instructionsTextSix);
        add(instructionsTextSeven);
        add(instructionsTextEight);

        var mainMenu = new Menu(20, FlxG.height-30);
        mainMenu.addButton("Main Menu", goToMenu);
        add(mainMenu);
        add(new FlxButton(FlxG.width-100, FlxG.height-30, "Page One", goToPageOne));
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}

    public function goToPageOne()
    {
        FlxG.switchState(new InstructionsState());
    }

    public function goToMenu()
    {
        FlxG.switchState(new MenuState());
    }
}
