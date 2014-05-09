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
		private var updateSkatersLeft:Function;
		
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
				var timer:FlxTimer = new FlxTimer();
				timer.start(skater.startTime, 1, startSprite);
			}
		}
		
		private function startSprite(timer:FlxTimer):void {
			var next:SpriteData = skaters.pop();
			var p:FlxPoint = ZzUtils.getRandomEntrance();
			var skater:Skater = new Skater(p.x, p.y, next.iceTime);
			add(skater);
			skater.postConstruct(PlayState(FlxG.state).addDep);
			updateSkatersLeft(skaters.length);
		}
		
		public function getInitialNumSkaters():uint {
			return initialNumSkaters;
		}
		
		public function setUpdateSkatersFunction(updateSkatersLeft:Function):uint {
			this.updateSkatersLeft = updateSkatersLeft;
			return skaters.length;
		}
	}

}