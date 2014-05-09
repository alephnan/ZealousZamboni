package  
{
	import org.flixel.*;
	/**
	 * ...
	 * @author Dana Van Aken
	 */
	public class SkaterQueue implements SpriteQueue
	{
		private var skaters:Array;
		private var initialNumSkaters:uint;
		
		public function SkaterQueue() {
			skaters = new Array();
			initialNumSkaters = 0;
		}
		
		public function addSpriteData(sd:SpriteData):void {
			skaters.push(sd);
		}
		
		public function startTimer():void {
			initialNumSkaters = skaters.length;
			this.skaters.sortOn("startTime", Array.NUMERIC | Array.DESCENDING);
			for each (var skater:SpriteData in skaters) {
				//trace(skater.toString());
				var timer:FlxTimer = new FlxTimer();
				timer.start(skater.startTime, 1, startSprite);
			}
		}
		
		private function startSprite(timer:FlxTimer):void {
			var next:SpriteData = skaters.pop();
			var p:FlxPoint = ZamboniUtil.getRandomEntrance();
			var skater:Skater = new Skater(p.x, p.y, next.iceTime);
			PlayState(FlxG.state).addUnit(skater);
		}
		
		
		public function skatersLeft():uint {
			trace(skaters.length);
			return skaters.length;
		}
		
		public function getInitialNumSkaters():uint {
			return initialNumSkaters;
		}
	}

}