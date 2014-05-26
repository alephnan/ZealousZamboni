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
		
		private var currEntrance : int;
		
		public function SkaterQueue() {
			skaters = new Array();
			initialNumSkaters = 0;
			
			currEntrance = 0;
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
				var timer:ZzTimer = new ZzTimer();
				timer.start(skater.startTime, 1, startSprite);
			}
			
		}
		
			
			
		private function startSprite(timer:ZzTimer):void {
			var next:SpriteData = skaters.pop();
			var p:FlxPoint;
			var count:int = 10;
			
			
			/* Old Ranadomized door selection: 
			 * 
			 * while (ZzUtils.entranceBlocked(p = ZzUtils.getRandomEntrance()) && count > 0) {
				count--;
				
								
				var skater:Skater = new Skater(p.x, p.y, next.iceTime);
				add(skater);
				skater.postConstruct(PlayState(FlxG.state).addDep);
			} 
			*/
			
			
			// Goes through entrance, and assign skaters to an entrance, in clock-arithmetic style
			var allEntrances :Array = ZzUtils.getAllEntrances();
			if (allEntrances.length > 0) {
				while (allEntrances[currEntrance] != null && ZzUtils.entranceBlocked(p = allEntrances[currEntrance]) && count > 0) {
					count--;
					currEntrance++;
					
					if (currEntrance == allEntrances.length) {
						currEntrance = 0;
					} 
				}
				if (next.x != 0 && next.y != 0) {
					//if we have skater x,y use the nearest entrance to that instead of round robin
					p = ZzUtils.getNearestEntrance(new FlxPoint(next.x, next.y));
				}
				var skater:Skater = new Skater(p.x, p.y, next.iceTime, null, next.toX, next.toY, next.dir);
				skater.setSkaterCompleteFn(skaterComplete);
				add(skater);
				skater.postConstruct(PlayState(FlxG.state).addDep);
			} 
		}
		
		public function skaterComplete(object:FlxObject, killed:Boolean = false):void {
			//var finished:Boolean = skaters.length == 0 && countLiving() == 0;
			if (!killed) {
				PlayState(FlxG.state).playerPoints.generateReward(object.getMidpoint(), 1, true);
			}
		}
		
		override public function destroy():void {
			super.destroy();
			skaters = null;
		}
	}

}