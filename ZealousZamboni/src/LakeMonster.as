package 
{
	import org.flixel.*;
	/**
	 * ...
	 * @author Kenny
	 */
	public class LakeMonster extends Monster 
	{
		private static const SPAWN_TIME:Number = 2;
		private static const POP_TIME:Number = .5;
		private static const CHOMP_TIME:Number = 2;
		private static const DEATH_TIME:Number = .5;
		public function LakeMonster(X:Number, Y:Number, type:String) {
			super(X, Y, type);
			loadGraphic(Media.lakeMonsterPNG, true, true, 64, 64, true);
			//this.color = 0x780090D0;
			this.allowCollisions = FlxObject.NONE;
			// Change sprite size to be size of tile (better for trails)
			var o:Number = 0;	//offset for specifying animations
			addAnimation("crack", [0], 0, true);
			addAnimation("popOut", [1,2,3,4,5], 10, false);
			addAnimation("chomp", [7, 8, 9, 10,11,12], 16, true);
			addAnimation("death", [13, 14, 15, 16], 8, false);
			maxVelocity.x = 0;
			maxVelocity.y = 0;
			play("crack");
			doAction(popOut, SPAWN_TIME);
		}
		
		private function popOut() : void {
			play("popOut");
			doAction(chomp, POP_TIME);
		}
		
		private function chomp() : void {
			play("chomp");
			doAction(death, CHOMP_TIME);
		}
		
		private function death() : void {
			play("death");
			doAction(kill, DEATH_TIME);
		}
		
		//Waits until the given time and then calls the given function
		private function doAction(action:Function, startTime:Number) : void{
			new ZzTimer().start(startTime, 1, function(t:*) : void {
				action();
			});
		}
	}
	
}