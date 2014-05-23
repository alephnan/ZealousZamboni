package  
{
	/**
	 * ...
	 * @author Dana Van Aken
	 */
	public class SpriteData 
	{
		public var x:uint;
		public var y:uint;
		public var startTime:uint;
		public var iceTime:uint;
		public var type:String;
		public var toX:uint;
		public var toY:uint;
		public var dir:String;
		
		public function SpriteData(x:uint = 0, y:uint = 0, startTime:uint = 0, iceTime:uint = 0, type:String = null,
			toX:uint = 0, toY:uint = 0, dir:String = "DOWN")
		{
			this.x = x;
			this.y = y;
			this.toX = toX;
			this.toY = toY;
			this.startTime = startTime;
			this.iceTime = iceTime;
			this.type = type;
			this.dir = dir;
		}
		
		public function toString():String {
			return "(x: " + x + " y: " + y + " startTime: " + startTime + " iceTime: " + iceTime + ")";
		}
		
	}

}