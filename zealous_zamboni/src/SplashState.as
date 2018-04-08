package  
{
	import org.flixel.*;
	/**
	 * ...
	 * @author Dana Van Aken
	 */
	public class SplashState extends FlxState
	{
		override public function create() : void {
			var splash:FlxSprite = new FlxSprite(0, 0, Media.splashPNG);
			add(splash);
			FlxG.mouse.show();
		}
		
		override public function update():void {
			if (FlxG.mouse.justPressed() || FlxG.keys.justPressed("ENTER")) {
				FlxG.switchState(new MenuState);
				//FlxG.switchState(new PlayState);
			}
		}
		
	}

}