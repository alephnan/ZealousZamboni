package  
{
	import org.flixel.*;
	/**
	 * ...
	 * @author Dana Van Aken
	 */
	public class SplashState extends FlxState
	{
		
		public function SplashState() 
		{
			var splash:FlxSprite = new FlxSprite(0, 0, Media.splashPNG);
			add(splash);
			FlxG.mouse.show();
		}
		
		override public function update():void {
			if (FlxG.mouse.justPressed()) {
				FlxG.switchState(new StartState());
			}
		}
		
	}

}