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
		[Embed(source = '../media/zombie.png')] private static const walkingDeadPNG:Class;
		
		private var speed:Number;
		
		//Number of updates until we do a path update
		private var nextPathUpdate:Number = 0;
		
		private var lungeDist:Number = 40;
		
		private var canLunge:Boolean = true;
		
		public function WalkingDead(X:Number, Y:Number) {
			super(X, Y);
			//place holder stuff
			speed = 100;
			loadGraphic(walkingDeadPNG, true, true, 32, 32, true);
			//this.color = 0x780090D0;
			this.allowCollisions = FlxObject.NONE;
			// Change sprite size to be size of tile (better for trails)
			this.width = LevelLoader.TILE_SIZE;
			this.height = LevelLoader.TILE_SIZE;
			this.offset = new FlxPoint(12, 18);	// used trial and error here
			
			var o:Number = 0;	//offset for specifying animations
			addAnimation("walkS", [o + 0, o + 1, o + 2, o + 3], 5, true);
			o = 4;
			addAnimation("walkN", [o + 0, o + 1, o + 2, o + 3], 5, true);
			o = 8;
			addAnimation("walkW", [o + 0, o + 1, o + 2, o + 3], 5, true);
			o = 12;
			addAnimation("walkE", [o + 0, o + 1, o + 2, o + 3], 5, true);
			addAnimation("death", [0, 4, 8, 12], 8, true);
			addAnimation("hurt", [0], 1, true);
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
			if (pathAngle < 0) pathAngle += 360;
			if (pathAngle < 45) {
				play("walkN");
			}else if (pathAngle < 135) {
				play("walkE");
			}else if (pathAngle < 225) {
				play("walkS");
			}else if (pathAngle < 315){
				play("walkW");
			}else {
				play("walkN");
			}
			//Need to manually call collision on this with skaters & zamboni since collision is turned off
			this.allowCollisions = FlxObject.ANY;
			//FlxG.overlap(this, PlayState(FlxG.state).activeSprites, collide);
			FlxG.overlap(this, PlayState(FlxG.state).activeSprites[0], collide);
			FlxG.overlap(this, PlayState(FlxG.state).activeSprites[1], collide);
			this.allowCollisions = FlxObject.NONE;
			
		}
		
		private function collide(e1:FlxObject, e2:FlxObject) : void {
			if (e2 is Skater || e2 is Zamboni) {
				ZzUnit(e2).onCollision(this);
				onCollision(e2);
			}
		}
		
		private function updatePath() : void {
			var p:FlxPath = new FlxPath();
			p.addPoint(getMidpoint());
			p.addPoint(PlayState(FlxG.state).getNearestSkater(getMidpoint()));
			if (canLunge && ZzUtils.dist(getMidpoint(), p.tail()) < lungeDist) {
				speed *= 4;
				canLunge = false;
				new FlxTimer().start(.1, 1, function (t:*) : void { speed /= 8; } );
				new FlxTimer().start(5, 1, function (t:*) : void { speed *= 2; canLunge = true} );
			}
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