package  
{
	import org.flixel.*;
	/**
	 * ...
	 * @author Dana Van Aken
	 */
	public class SkaterQueue extends FlxGroup implements SpriteQueue
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
		
		public function skatersFinished():Boolean {
			return skaters.length == 0 && countLiving() == 0;
		}
		
		public function startTimer():void {
			initialNumSkaters = skaters.length;
			this.skaters.sortOn("startTime", Array.NUMERIC | Array.DESCENDING);
			for each (var skater:SpriteData in skaters) {
				var timer:FlxTimer = new FlxTimer();
				timer.start(skater.startTime, 1, startSprite);
			}
		}
		
		private function startSprite(timer:FlxTimer):void {
			var next:SpriteData = skaters.pop();
			var p:FlxPoint;
			var count:int = 10;
			while (ZzUtils.entranceBlocked(p = ZzUtils.getRandomEntrance()) && count > 0) {
				count--;
			}
			var skater:Skater = new Skater(p.x, p.y, next.iceTime);
			add(skater);
			skater.postConstruct(PlayState(FlxG.state).addDep);
		}
		
		override public function destroy():void {
			super.destroy();
			skaters = null;
		}
	}

}