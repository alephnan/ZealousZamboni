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
		
		public function skatersLeft():uint {
			return skaters.length;
		}
		
		public function activeSkaters():uint {
			return countLiving();
		}
		
		public function startTimer():void {
			initialNumSkaters = skaters.length;
			this.skaters.sortOn("startTime", Array.NUMERIC | Array.DESCENDING);
			if (!PlayState.TUTORIAL) {
				for each (var skater:SpriteData in skaters) {
					var timer:ZzTimer = new ZzTimer();
					timer.start(skater.startTime, 1, startSprite);
				}
			} else {
				
			}
			
		}
			
		private function startSprite(timer:ZzTimer):void {
			var next:SpriteData = skaters.pop();
			var p:FlxPoint;
			var count:int = 10;
			
			
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
				//var skater:Skater = new Skater(next.x, next.y, next.iceTime, null, next.x, next.y, next.dir);
				skater.setSkaterCompleteFn(skaterComplete);
				add(skater);
				skater.postConstruct(PlayState(FlxG.state).addDep);
			} 
		}
		
		public function startTutorialSkater(object:FlxObject=null):void {
			if (object != null) {
				trace("restarting skater");
			} else {
				trace("starting new skater");
			}
			new ZzTimer().start(2, 1, startSkater);
		}
		
		// USE ONLY FOR TUTORIAL
		private function startSkater(timer:ZzTimer):void {
			if (PlayState.TUTORIAL) {
				var next:SpriteData = skaters[skaters.length - 1];
				var p:FlxPoint;
				var count:int = 100;
				
				
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
					trace("skater x = " + next.x + " skater y = " + next.y + " ice time = " + next.iceTime + " tox = " + next.toX + " toy = " + next.toY + " dir = " + next.dir);
					var skater:Skater = new Skater(next.x, next.y, next.iceTime, null, next.toX, next.toY, next.dir);
					//var skater:Skater = new Skater(next.x, next.y, next.iceTime, null, next.x, next.y, next.dir);
					skater.setSkaterCompleteFn(skaterComplete);
					add(skater);
					skater.postConstruct(PlayState(FlxG.state).addDep);
				}
			}
			
		}
		
		public function skaterComplete(object:FlxObject, killed:Boolean = false):void {
			trace("in skater complete");
			//var finished:Boolean = skaters.length == 0 && countLiving() == 0;
			if (!killed) {
				PlayState(FlxG.state).playerPoints.generateReward(object.getMidpoint(), 1, true);
			}
			if (PlayState.TUTORIAL) {
				if (killed) {
					trace("skater killed");
					startTutorialSkater(object);
				} else {
					skaters.pop();
					// tell tutorial skater completed
					trace("Skater completed");
					PlayState(FlxG.state).tutorialState.skaterComplete();
				}
			}
		}
		
		override public function destroy():void {
			super.destroy();
			skaters = null;
		}
	}

}