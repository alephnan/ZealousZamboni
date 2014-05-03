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
		public var progressTime:int;
		
		public function Skater(X:Number, Y:Number, time:int) {
			super(X, Y);
			timeToSkate = time;
			timer = new FlxTimer();
			timer.start(time, 1, timerUp);
			progress = new FlxBar(x, y, 1, 48, 8, this, "progressTime", 0, time);
			progressTime = 0;
			PlayState(FlxG.state).add(progress);
			progress.trackParent(0, -5);
			lastTrailTile = new FlxPoint(X, Y);
			trail = new Trail();
			//place holder stuff
			loadGraphic(skaterPNG, true, true, 32, 32, true);
			var o:Number = 0;	//offset for specifying animations
			addAnimation("walkS", [o + 0, o + 1, o + 2, o + 3, o + 4, o + 5, o + 6, o + 7, o + 8, o + 9, o + 10, o + 11], 6, true);
			o = 16;
			addAnimation("walkN", [o + 0, o + 1, o + 2, o + 3, o + 4, o + 5, o + 6, o + 7, o + 8, o + 9, o + 10, o + 11], 6, true);
			o = 32;
			addAnimation("walkW", [o + 0, o + 1, o + 2, o + 3, o + 4, o + 5, o + 6, o + 7, o + 8, o + 9, o + 10, o + 11], 6, true);
			o = 48;
			addAnimation("walkE", [o+0, o+1, o+2, o+3, o+4, o+5, o+6, o+7, o+8, o+9, o+10, o+11], 6, true);
			maxVelocity.x = 80;
			maxVelocity.y = 80;
			drag.x = maxVelocity.x * 4;
			drag.y = maxVelocity.y * 4;
			goingRight = true;
			this.play("walkS", true);
		}
		
		
		public function getTrail() : Trail {
			return trail;
		}
		
		override public function update() : void {
			super.update();
			if(!timer.finished){
				if (goingLeft) {
					velocity.x = -maxVelocity.x;
					velocity.y = 0;
					this.play("walkW", false);
				}
				if (goingRight) {
					velocity.x = maxVelocity.x;
					velocity.y = 0;
					this.play("walkE", false);
				}
				if (goingDown) {
					velocity.x = 0;
					velocity.y = maxVelocity.y;
					this.play("walkS", false);
				}
				if (goingUp) {
					velocity.x = 0;
					velocity.y = -maxVelocity.y;
					this.play("walkN", false);
				}
				if (Math.abs(x - lastTrailTile.x) > 7 || Math.abs(y - lastTrailTile.y) > 7) {
					trail.addTile(this.getMidpoint().x, this.getMidpoint().y);
					lastTrailTile.x = x;
					lastTrailTile.y = y;
				}
				progressTime = timeToSkate-timer.timeLeft;
			}else {
				progressTime = timeToSkate;
				this.allowCollisions = 0;
			}
			
		}
		
		private function timerUp(t:FlxTimer) : void {
			var p:FlxPath = PlayState(FlxG.state).level.findPath(getMidpoint(), new FlxPoint(32, 32));
			this.followPath(p, 100);
		}
		
		
		override public function setNextMove(level:FlxTilemap, entities:FlxGroup) : void {
			
		}
		
		override public function onCollision(other:FlxObject) : void {
			rotate();
		}
		
		public function rotate() : void{
			if (goingLeft) {
				goingLeft = false;
				goingDown = true;
			}else if (goingDown) {
				goingDown = false;
				goingRight = true;
			}else if (goingRight) {
				goingRight = false;
				goingUp = true;
			}else if (goingUp) {
				goingUp = false;
				goingLeft = true;
			}
		}
	}
	
}