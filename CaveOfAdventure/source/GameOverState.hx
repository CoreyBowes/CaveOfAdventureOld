package;

import flixel.FlxState;
import flixel.FlxG;
import flixel.ui.FlxButton;
import flixel.text.FlxText;

class GameOverState extends FlxState
{
	override public function create():Void
	{
		super.create();
        var gameOverText = new FlxText(FlxG.width/2, FlxG.height/2, 0, "You Lose", 40);
        var menuButton = new FlxButton(FlxG.width/2, FlxG.height/2+60, "Return to Menu", goToMenu);
        add(gameOverText);
        add(menuButton);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}

    public function goToMenu()
    {
        FlxG.switchState(new MenuState());
    }
}
