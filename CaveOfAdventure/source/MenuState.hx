package;

import flixel.FlxState;
import flixel.FlxG;
import flixel.ui.FlxButton;
import flixel.text.FlxText;

class MenuState extends FlxState
{
    public var _titleText:FlxText;
	override public function create():Void
	{
		super.create();
        _titleText = new FlxText(0, 20, FlxG.width, "Cave of Sacrifice", 40);
        _titleText.alignment = CENTER;
        var mainMenu = new Menu(FlxG.width/2-40, FlxG.height/2);
        mainMenu.addButton("New Game", startNewGame);
        mainMenu.addButton("Continue Game", continueGame);
        mainMenu.addButton("Instructions", goToInstructions);
        mainMenu.addButton("Achievements", goToAchievements);
        add(mainMenu);

        /*
        var playButton = new FlxButton(FlxG.width/2, FlxG.height/2, "New Game", startNewGame);
        var continueButton = new FlxButton(FlxG.width/2, FlxG.height/2+40, "Continue Game", continueGame);
        add(playButton);
        add(continueButton);
        */

        add(_titleText);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}

    public function startNewGame()
    {
        Reg._currentLevel = 1;
        for(i in 0...Reg._abilities.length)
        {
            Reg._abilities[i] = false;
        }
        FlxG.switchState(new LevelState());
    }

    public function continueGame()
    {
        FlxG.switchState(new LevelState());
    }

    public function goToInstructions()
    {
        FlxG.switchState(new InstructionsState());
    }

    public function goToAchievements()
    {
        FlxG.switchState(new AchievementsState());
    }
}
