package  
{
	import org.flixel.*;
	/**
	 * ...
	 * @author Dana Van Aken
	 */
	public class WalkingDeadQueue extends FlxGroup implements SpriteQueue
	{
		private var zombies:Array;
		
		public function WalkingDeadQueue() 
		{
			zombies = new Array();
		}
		
		public function addSpriteData(sd:SpriteData):void {
			zombies.push(sd);
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
			var zombie:WalkingDead = new WalkingDead(next.x, next.y);
			add(zombie);
			//PlayState(FlxG.state).addUnit(zombie);
		}
		
		override public function destroy():void {
			super.destroy();
			zombies = null;
		}
		
	}

}