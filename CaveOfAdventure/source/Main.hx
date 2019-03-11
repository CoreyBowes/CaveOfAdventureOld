package;

import flixel.FlxGame;
import openfl.display.Sprite;

class Main extends Sprite
{
	public function new()
	{
		super();
        Reg.initializeGame();
		addChild(new FlxGame(640, 480, MenuState));
        // addChild(new FlxGame(0, 0, SacrificeState));
	}
}
