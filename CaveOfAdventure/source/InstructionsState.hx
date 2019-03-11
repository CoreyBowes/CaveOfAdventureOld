package;

import flixel.FlxState;
import flixel.FlxG;
import flixel.ui.FlxButton;
import flixel.text.FlxText;
import flixel.FlxSprite;
import flixel.util.FlxColor;

/*
State for the instructions page.
*/
class InstructionsState extends FlxState
{
    public var _titleText:FlxText;

	override public function create():Void
	{
		super.create();
        _titleText = new FlxText(0, 20, FlxG.width, "Instructions", 40);
        _titleText.alignment = CENTER;

        var instructionsStringOne = "You are entering the cave of adventure! Riches await you, "+
        "but also deadly monsters, spikes, and chasms. Will you brave the dangers and return with riches and fame?";
        var instructionsTextOne = new FlxText(FlxG.width/8, 80, FlxG.width*3/4, instructionsStringOne, 12);
        instructionsTextOne.alignment = CENTER;

        var instructionsStringTwo = "Reach the exit to advance to the next level. Don't fall to the "+
        "bottom of the screen or you'll die and have to start over!";
        var instructionsTextTwo = new FlxText(FlxG.width/2, 160, FlxG.width/2, instructionsStringTwo, 12);
        var exitIcon = new FlxSprite(FlxG.width/4, 160);
        exitIcon.makeGraphic(10, 20, FlxColor.YELLOW);
        add(exitIcon);

        var instructionsStringThree = "Slimes will kill you if they touch you. Avoid them.";
        var instructionsTextThree = new FlxText(FlxG.width/2, 240, FlxG.width/2, instructionsStringThree, 12);
        var slimeIcon = new FlxSprite(FlxG.width/4, 240);
        slimeIcon.makeGraphic(8, 8, FlxColor.LIME);
        add(slimeIcon);

        var instructionsStringFour = "Purple slimes like to jump. Watch out for that.";
        var instructionsTextFour = new FlxText(FlxG.width/2, 300, FlxG.width/2, instructionsStringFour, 12);
        var purpleSlimeIcon = new FlxSprite(FlxG.width/4, 300);
        purpleSlimeIcon.makeGraphic(8, 8, FlxColor.PURPLE);
        add(purpleSlimeIcon);

        var instructionsStringFive = "Red slimes are smart and will seek you out. You'll have to be quick to avoid them.";
        var instructionsTextFive = new FlxText(FlxG.width/2, 360, FlxG.width/2, instructionsStringFive, 12);
        var redSlimeIcon = new FlxSprite(FlxG.width/4, 360);
        redSlimeIcon.makeGraphic(8, 8, FlxColor.RED);
        add(redSlimeIcon);

        add(instructionsTextOne);
        add(instructionsTextTwo);
        add(instructionsTextThree);
        add(instructionsTextFour);
        add(instructionsTextFive);

        var mainMenu = new Menu(20, FlxG.height-30);
        mainMenu.addButton("Main Menu", goToMenu);
        add(mainMenu);
        add(new FlxButton(FlxG.width-100, FlxG.height-30, "Page Two", goToPageTwo));

        add(_titleText);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}

    public function goToPageTwo()
    {
        FlxG.switchState(new InstructionsPageTwoState());
    }

    public function goToMenu()
    {
        FlxG.switchState(new MenuState());
    }
}
