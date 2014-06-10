package  
{
	import org.flixel.*;
	/**
	 * ...
	 * @author Dana Van Aken
	 */
	public class MonsterQueue extends FlxGroup implements SpriteQueue
	{
		private var zombies:Array;
		
		public function MonsterQueue() 
		{
			zombies = new Array();
		}
		
		public function addSpriteData(sd:SpriteData):void {
			zombies.push(sd);
		}
		
		public function zombiesFinished():Boolean {
			return zombies.length == 0 && countLiving() == 0;
		}
		
		public function zombiesLeft():uint {
			return zombies.length;
		}
		
		public function activeZombies():uint {
			return countLiving();
		}
		
		public function startTimer():void {
			this.zombies.sortOn("startTime", Array.NUMERIC | Array.DESCENDING);
			for each (var zombie:SpriteData in zombies) {
				var timer:ZzTimer = new ZzTimer();
				timer.start(zombie.startTime, 1, startSprite);
			}
		}
		
		private function startSprite(timer:ZzTimer):void {
			var next:SpriteData = zombies.pop();
			var zombie:Monster = new next.classType(next.x, next.y, next.type);
			add(zombie);
			//PlayState(FlxG.state).addUnit(zombie);
		}
		
		override public function destroy():void {
			super.destroy();
			zombies = null;
		}
		
	}

}