package  
{
	import org.flixel.*;
	/**
	 * ...
	 * @author Dana Van Aken
	 */
	public class Shoutout extends FlxText
	{
		private static const MAX_SIZE:uint = 64;
		private var timer:FlxTimer;
		private var callback:Function;
		
		public function Shoutout(text:String, callback:Function=null) 
		{
			super(FlxG.width / 2 - 200, FlxG.height / 2 - 50, 300, text, true);
			setFormat("rock", 8, 0x3333cc, "center");
			timer = new FlxTimer();
			timer.start(1.5, 1, unpause);
			this.callback = callback;
		}
		
		override public function update():void {
			if (size < MAX_SIZE) {
				size++;
			}
			super.update();
		}
		
		public function unpause(timer:FlxTimer) {
			this.exists = false;
			callback(this);
		}
	}

}