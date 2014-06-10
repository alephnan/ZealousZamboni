package  
{
	import org.flixel.*;
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
		
		override public function update():void {
			if (!FlxG.paused) {
				super.update();
			}
		}
		
	}

}