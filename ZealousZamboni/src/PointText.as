package  
{
	import org.flixel.FlxPoint;
	import org.flixel.FlxText;
	/**
	 * ...
	 * @author Dana Van Aken
	 */
	public class PointText extends FlxText
	{
		private var originalY:uint;
		
		public function PointText(x:uint, y:uint, text:String, size:uint, color:uint, scale:FlxPoint) 
		{
			super(x, y, 50, text, false);
			this.size = size;
			this.color = color;
			originalY = y;
			//this.scale = scale;
			this.setFormat("coolverica", size, color);
		}
		
		override public function update():void {
			trace("here2");
			if (size == 60) {
				if (originalY - (--y) > 100) {
					exists = false;
					visible = false;
				} else {
					super.update();
				}
			} else {
				if (originalY - (--y) > 15) {
					exists = false;
					visible = false;
				} else {
					super.update();
				}
			}
			
		}
		
		public function resetText(x:uint, y:uint, text:String, size:uint, color:uint, scale:FlxPoint):void {
			super.reset(x, y);
			originalY = y;
			this.text = text;
			//this.size = size;
			//this.color = color;
			//this.scale = scale;
			this.setFormat("coolverica", size, color);
		}
		
	}

}