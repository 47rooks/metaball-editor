package;

import flixel.FlxGame;
import haxe.ui.Toolkit;
import openfl.display.Sprite;

class Main extends Sprite
{
	public function new()
	{
		super();
		// Initialize HaxeUI before creating the FlxGame
		Toolkit.init();
		addChild(new FlxGame(0, 0, MEState));
	}
}
