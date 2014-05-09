package  
{
	import org.flixel.*;
	/**
	 * ...
	 * @author Dana Van Aken
	 */
	public class PowerupQueue extends FlxGroup implements SpriteQueue
	{
		private var powerups:Array;
		
		public function PowerupQueue() 
		{
			powerups = new Array();
		}
		
		public function addSpriteData(sd:SpriteData):void {
			powerups.push(sd);
		}
		
		public function startTimer():void {
			this.powerups.sortOn("startTime", Array.NUMERIC | Array.DESCENDING);
			for each (var powerup:SpriteData in powerups) {
				var timer:FlxTimer = new FlxTimer();
				timer.start(powerup.startTime, 1, startSprite);
			}
		}
		
		private function startSprite(timer:FlxTimer):void {
			var next:SpriteData = powerups.pop();
			var powerup:PowerUp = new PowerUp(next.x, next.y, next.type);
			add(powerup);
			//PlayState(FlxG.state).addUnit(powerup);
		}
		
	}

}