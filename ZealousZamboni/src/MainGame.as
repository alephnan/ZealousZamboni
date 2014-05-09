package
{
	import org.flixel.FlxGame;
	/**
	 * ...
	 * @author Kenny
	 */
	[SWF(width="640", height="540", backgroundColor="#000000")]
	public class MainGame extends FlxGame
	{
		public function MainGame()
		{
			super(640,540,StartState,1);
		}
	}
	
}