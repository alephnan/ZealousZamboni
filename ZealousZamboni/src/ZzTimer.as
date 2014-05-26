package  
{
	import org.flixel.FlxTimer;
	/**
	 * ...
	 * @author Dana Van Aken
	 */
	public class ZzTimer extends FlxTimer
	{
		
		public function ZzTimer() 
		{
			super();
			ZzUtils.registerTimer(this);
		}
		
	}

}