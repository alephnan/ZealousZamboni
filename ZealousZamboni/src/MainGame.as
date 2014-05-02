package
{
	import org.flixel.FlxGame;
	/**
	 * ...
	 * @author Kenny
	 */
	[SWF(width="640", height="480", backgroundColor="#000000")]
	public class MainGame extends FlxGame
	{
		public function MainGame()
		{
			super(320,240,StartState,1);
		}
	}
	
}