package 
{
	import org.flixel.*;
	/**
	 * ...
	 * @author Kenny
	 * Calling these WalkingDead so they don't get confused with zambonies lol
	 */
	public class WalkingDead extends ZzUnit 
	{
		[Embed(source = '../media/skater_wireframe.png')] private static const walkingDeadPNG:Class;
		
		private var speed:Number;
		
		//Number of updates until we do a path update
		private var nextPathUpdate:Number = 0;
		
		public function WalkingDead(X:Number, Y:Number) {
			super(X, Y);
			//place holder stuff
			speed = 100;
			loadGraphic(walkingDeadPNG, true, true, 32, 32, true);
			this.allowCollisions = FlxObject.NONE;
			// Change sprite size to be size of tile (better for trails)
			this.width = LevelLoader.TILE_SIZE;
			this.height = LevelLoader.TILE_SIZE;
			this.offset = new FlxPoint(12, 18);	// used trial and error here
			
			var o:Number = 0;	//offset for specifying animations
			addAnimation("walkS", [o + 0, o + 2, o + 6, o + 11], 3, true);
			o = 16;
			addAnimation("walkN", [o + 0, o + 2, o + 6, o + 11], 3, true);
			o = 32;
			addAnimation("walkW", [o + 0, o + 2, o + 6, o + 11], 3, true);
			o = 48;
			addAnimation("walkE", [o + 0, o + 2, o + 6, o + 11], 3, true);
			addAnimation("death", [6, 22, 38, 54], 8, true);
			addAnimation("hurt", [16], 1, true);
			maxVelocity.x = 100;
			maxVelocity.y = 100;
			drag.x = maxVelocity.x * 4;
			drag.y = maxVelocity.y * 4;
			this.play("walkS", true);
		}
		
		override public function update() : void {
			if(nextPathUpdate <= 0){
				updatePath();
				nextPathUpdate = 10;
			}else {
				nextPathUpdate -= 1;
			}
			if (pathAngle < 45) {
				play("walkE");
			}else if (pathAngle < 135) {
				play("walkN");
			}else if (pathAngle < 225) {
				play("walkW");
			}else if (pathAngle < 315){
				play("walkS");
			}else {
				play("walkE");
			}
			
			
		}
		
		private function updatePath() : void {
			var p:FlxPath = new FlxPath();
			p.addPoint(getMidpoint());
			//p.addPoint(PlayState(FlxG.state).getNearestSkater(getMidpoint()));
			this.followPath(p, speed);
		}
		
		override public function onCollision(other:FlxObject) : void {
			if (other is Zamboni) {
				this.kill();
			}
		}
		
		override public function kill() : void {
			super.kill();
			SoundPlayer.zombieDeath.play();
		}
		
	}
	
}