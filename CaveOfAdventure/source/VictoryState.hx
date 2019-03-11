package;

import flixel.FlxState;
import flixel.FlxG;
import flixel.ui.FlxButton;
import flixel.text.FlxText;

class VictoryState extends FlxState
{
	override public function create():Void
	{
		super.create();

        Achievements.unlockAchievementByName("Cave Master");

        var victoryText = new FlxText(FlxG.width/2, FlxG.height/2, 0, "You Win", 40);
        var nuggetsText = new FlxText(FlxG.width/2, FlxG.height/2+50, 0, 
        "Gold nuggets collected: "+Reg._goldNuggetsCollected+"/"+Reg._goldNuggetsTotal, 12);
        var menuButton = new FlxButton(FlxG.width/2, FlxG.height/2+70, "Return to Menu", goToMenu);

        if(Reg._goldNuggetsCollected == Reg._goldNuggetsTotal)
        {
            Achievements.unlockAchievementByName("Filthy Rich");
        }

        add(victoryText);
        add(nuggetsText);
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
