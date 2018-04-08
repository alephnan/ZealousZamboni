package 
{
	import org.flixel.*;
	/**
	 * ...
	 * @author Kenny
	 * Calling these WalkingDead so they don't get confused with zambonies lol
	 */
	public class WalkingDead extends Monster
	{
		public static const SIMPLE:String = "simple";
		
		public static const BIG:String = "big";
		
		private var speed:Number;
		
		//Number of updates until we do a path update
		private var nextPathUpdate:Number = 0;
		
		private static const START_TIME:Number = 3; //number of seconds to wait before starting
		private var lungeDist:Number = 40;
		
		private var canLunge:Boolean = true;
		
		private var isStarted:Boolean = false;
		
		private var type:String;
		
		public function WalkingDead(X:Number, Y:Number, type:String) {
			super(X, Y, type);
			//place holder stuff
			this.type = type;
			speed = 100;
			loadGraphic(Media.walkingDeadPNG, true, true, 32, 32, true);
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
			if (type == BIG) {
				health = 3;
				scale = new FlxPoint(1.4, 1.4);
				color = 0xFF999999;
			}
			new ZzTimer().start(START_TIME, 1, function (t:*) : void { isStarted = true } );
			
			ZzLog.logAction(ZzLog.ACTION_ZOMBIE_ENTER, getLoggableObject());
		}
		
		override public function update() : void {
			if (!alive || !isStarted) return;
			checkPit(kill);
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
				ZzLog.logAction(ZzLog.ACTION_ZOMBIE_LUNGE, getLoggableObject());
				speed *= 4;
				canLunge = false;
				new ZzTimer().start(.1, 1, function (t:*) : void { speed /= 8; } );
				new ZzTimer().start(5, 1, function (t:*) : void { speed *= 2; canLunge = true} );
			}
			this.followPath(p, speed);
			
		}
		
		override public function onCollision(other:FlxObject) : void {
			if (!alive) return;
			if (other is Zamboni) {
				if(health == 1){
					ZzLog.logAction(ZzLog.ACTION_ZOMBIE_DIE, getLoggableObject());
					PlayState(FlxG.state).playerPoints.generateReward(other.getMidpoint(), PlayerPoints.KILL_ZOMBIE_REWARD, false);
					alive = false;
					LevelLoader.SOUND_PLAYER.play("zombieDeath");
					LevelLoader.SOUND_PLAYER.play("zombieHit");
					this.stopFollowingPath(true);
					this.pathSpeed = 0;
					this.maxVelocity.x = 1000;
					this.maxVelocity.y = 1000;
					this.velocity.x = other.velocity.x*3;
					this.velocity.y = other.velocity.y*3;
					this.angularVelocity = 900;
					this.angularAcceleration = -400;
					var tm:ZzTimer = new ZzTimer();
					tm.start(1, 1, function (t:*) : void {
						kill()
					});
				}else {
					isStarted = false;
					health--;
					LevelLoader.SOUND_PLAYER.play("zombieHit");
					this.stopFollowingPath(true);
					this.maxVelocity.x = 1000;
					this.maxVelocity.y = 1000;
					this.velocity.x = other.velocity.x;
					this.velocity.y = other.velocity.y;
					other.velocity.x = 0;
					other.velocity.y = 0;
					this.angularVelocity = 900;
					this.angularAcceleration = -400;
					new ZzTimer().start(2, 1, function () : void{
						velocity.x = 0;
						velocity.y = 0;
						isStarted = true;
						angularVelocity = 0;
						angularAcceleration = 0;
						angle = 0;
					});
				}
				
			}
			
		}
		
		/**
		 * Returns a loggable summary of this object's state
		 * @return
		 */
		public override function getLoggableObject() : Object {
			return { 
					"x" : x, 
					"y" : y, 
					"id" : this.ID 
					};
		}
	}
	
}