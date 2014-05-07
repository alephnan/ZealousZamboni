package
{
	import org.flixel.FlxObject;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	import org.flixel.FlxTilemap;
	import org.flixel.FlxGroup;
	import org.flixel.FlxG;
	import org.flixel.FlxTimer;
	import org.flixel.FlxPath;
	import org.flixel.plugin.photonstorm.FlxBar;
	
	/**
	 * ...
	 * @author Kenny
	 */
	public class Skater extends ZzUnit
	{
		[Embed(source = '../media/skater.png')] private var skaterPNG:Class;
		
		private static const SKATER_DEATH_SLACK:uint = 5;	// seconds
		
		private var goingLeft:Boolean = false;
		private var goingRight:Boolean = false;
		private var goingUp:Boolean = false;
		private var goingDown:Boolean = false;
		private var isControlled:Boolean = false;
		private var trail:Trail;
		private var lastTrailTile:FlxPoint;
		//The total time that this skater should skate for in seconds
		private var timeToSkate:int;
		//The internal timer that tracks how long to skate for
		public var timer:FlxTimer;
		//The progress bar for displaying how much time is left
		private var progress:FlxBar;
		//A value counting up to timeToSkate
		public var progressTime:Number;
		//The skater death timer
		private var deathTimer:FlxTimer;
		//This is set when a skater is stuck
		private var skaterStuck:Boolean;
		
		public function Skater(X:Number, Y:Number, time:int) {
			super(X, Y);
			timeToSkate = time;
			timer = new FlxTimer();
			progress = new FlxBar(x, y, 1, 48, 8, this, "progressTime", 0, time);
			progressTime = 1;
			progress.trackParent(0, -5);
			progress.createFilledBar(0xA0112080,0xF060A0FF, true, 0xff000000);
			progress.update();
			lastTrailTile = this.getMidpoint();
			lastTrailTile.x /= LevelLoader.TILE_SIZE;
			lastTrailTile.y /= LevelLoader.TILE_SIZE;
			trail = new Trail();
			//place holder stuff
			loadGraphic(skaterPNG, true, true, 32, 32, true);
			deathTimer = new FlxTimer();
			
			// Change sprite size to be size of tile (better for trails)
			this.width = LevelLoader.TILE_SIZE;
			this.height = LevelLoader.TILE_SIZE;
			this.offset = new FlxPoint(12, 18);	// used trial and error here
			
			var o:Number = 0;	//offset for specifying animations
			addAnimation("walkS", [o + 0, o + 1, o + 2, o + 3, o + 4, o + 5, o + 6, o + 7, o + 8, o + 9, o + 10, o + 11], 6, true);
			o = 16;
			addAnimation("walkN", [o + 0, o + 1, o + 2, o + 3, o + 4, o + 5, o + 6, o + 7, o + 8, o + 9, o + 10, o + 11], 6, true);
			o = 32;
			addAnimation("walkW", [o + 0, o + 1, o + 2, o + 3, o + 4, o + 5, o + 6, o + 7, o + 8, o + 9, o + 10, o + 11], 6, true);
			o = 48;
			addAnimation("walkE", [o + 0, o + 1, o + 2, o + 3, o + 4, o + 5, o + 6, o + 7, o + 8, o + 9, o + 10, o + 11], 6, true);
			addAnimation("death", [6, 22, 38, 54], 8, true);
			maxVelocity.x = 120;
			maxVelocity.y = 120;
			drag.x = maxVelocity.x * 4;
			drag.y = maxVelocity.y * 4;
			goingRight = true;
			this.play("walkS", true);
			
		}
		
		
		override public function postConstruct(addDependency : Function) : void {
			timer.start(timeToSkate, 1, timerUp);
			addDependency(progress);
			addDependency(trail);
		}
		
		public function getTrail() : Trail {
			return trail;
		}
		
		override public function update() : void {
			super.update();
			if (!timer.finished) {
				if (skaterStuck) {
					this.play("death", false);
				} else if (goingLeft) {
					velocity.x = -maxVelocity.x;
					velocity.y = 0;
					this.play("walkW", false);
				} else if (goingRight) {
					velocity.x = maxVelocity.x;
					velocity.y = 0;
					this.play("walkE", false);
				} else if (goingDown) {
					velocity.x = 0;
					velocity.y = maxVelocity.y;
					this.play("walkS", false);
				} else if (goingUp) {
					velocity.x = 0;
					velocity.y = -maxVelocity.y;
					this.play("walkN", false);
				}
				/*if (Math.abs(x - lastTrailTile.x) > 7 || Math.abs(y - lastTrailTile.y) > 7) {
					trail.addTile(this.getMidpoint().x, this.getMidpoint().y);
					lastTrailTile.x = x;
					lastTrailTile.y = y;
				}*/
				var tilemap:FlxTilemap = PlayState(FlxG.state).level;
				var xTile:uint = uint(getMidpoint().x / LevelLoader.TILE_SIZE);
				var yTile:uint = uint(getMidpoint().y / LevelLoader.TILE_SIZE);
				if (tilemap.getTile(xTile, yTile) == LevelLoader.ICE_TILE_INDEX) {
					tilemap.setTile(xTile, yTile, LevelLoader.TRAIL_TILE_INDEX, true);
				}
				progressTime = timeToSkate-timer.timeLeft;
			}else {
				progressTime = timeToSkate;
				if (this.pathSpeed == 0) {
					exists = false;
					progress.exists = false;
					PlayState(FlxG.state).skaterComplete(this);
				}
			}
			
		}
		
		private function timerUp(t:FlxTimer) : void {
			//var p:FlxPath = PlayState(FlxG.state).level.findPath(getMidpoint(), PlayState(FlxG.state).getNearestEntrance(getMidpoint()));
			var p:FlxPath = new FlxPath();
			p.addPoint(getMidpoint());
			p.addPoint(PlayState(FlxG.state).getNearestEntrance(getMidpoint()));
			this.allowCollisions = 0;
			progress.createFilledBar(0xFFFFFF00,0xFFFFFF00, true, 0xff000000);
			progress.update();
			this.followPath(p, 100);
		}
		
		
		override public function setNextMove(level:FlxTilemap, entities:FlxGroup) : void {
			
		}
		
		private function skaterDeathHandler(timer:FlxTimer):void {
			exists = false;
			progress.exists = false;
			PlayState(FlxG.state).skaterComplete(this);
		}
		
		override public function onOverlap(other:FlxObject) : void {
			onCollision(other);
		}
		
		override public function onCollision(other:FlxObject) : void {
			var tileMap:FlxTilemap = PlayState(FlxG.state).level;
			var curTile:FlxPoint = getMidpoint();
			curTile.x /= LevelLoader.TILE_SIZE;
			curTile.y /= LevelLoader.TILE_SIZE;
			
			// TODO: is there a way to implement this more efficiently?
			// Check tiles around current tile to see if skater is stuck
			if ((tileMap.getTile(curTile.x, curTile.y - 1) == LevelLoader.TRAIL_TILE_INDEX) && 
			    (tileMap.getTile(curTile.x, curTile.y + 1) == LevelLoader.TRAIL_TILE_INDEX) &&
				(tileMap.getTile(curTile.x - 1, curTile.y) == LevelLoader.TRAIL_TILE_INDEX) &&
				(tileMap.getTile(curTile.x + 1, curTile.y) == LevelLoader.TRAIL_TILE_INDEX)) {
				if (!skaterStuck) {
					skaterStuck = true;
					
					deathTimer.start(SKATER_DEATH_SLACK, 1, skaterDeathHandler);
				}
			} else if (skaterStuck) {
				skaterStuck = false;
				deathTimer.stop();
			}
			
			//rotate();
			if (goingLeft) 
				isGoingLeft();
			else if (goingDown) 
				isGoingDown();
			else if (goingUp) 
				isGoingUp();
			else if (goingRight) 
				isGoingRight();
		}
	
		public function isGoingLeft(): void {
			if (goingLeft && (touching & FlxObject.LEFT)) {
				if (!(touching & FlxObject.DOWN)) {
					goingLeft = false;
					goingDown = true;
				} else if (!(touching & FlxObject.RIGHT)) {
					goingLeft = false;
					goingRight = true;
				} else if (!(touching & FlxObject.UP)) {
					goingLeft = false;
					goingUp = true;
				}
			}
		}
		
		public function isGoingRight(): void {
			if (goingRight && (touching & FlxObject.RIGHT)) {
				if (!(touching & FlxObject.UP)) {
					goingRight = false;
					goingUp = true;
				} else if (!(touching & FlxObject.LEFT)) {
					goingRight = false;
					goingLeft = true;
				} else if (!(touching & FlxObject.DOWN)) {
					goingRight = false;
					goingDown = true;
				}
			}
		}
		
		public function isGoingUp(): void {
			if (goingUp && (touching & FlxObject.UP)) {
				if (!(touching & FlxObject.LEFT)) {
					goingUp = false;
					goingLeft = true;
				} else if (!(touching & FlxObject.DOWN)) {
					goingUp = false;
					goingDown = true;
				} else if (!(touching & FlxObject.RIGHT)) {
					goingUp = false;
					goingRight = true;
				}
			}
		}
		
		public function isGoingDown(): void {
			if (goingDown && (touching & FlxObject.DOWN)) {
				if (!(touching & FlxObject.RIGHT)) {
					goingDown = false;
					goingRight = true;
				} else if (!(touching & FlxObject.UP)) {
					goingDown = false;
					goingUp = true;
				} else if (!(touching & FlxObject.LEFT)) {
					goingDown = false;
					goingLeft = true;
				}
			}
		}
	}
	
}