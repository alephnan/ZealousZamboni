package
{
	import flash.media.SoundChannel;
	import org.flixel.FlxObject;
	import org.flixel.FlxParticle;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	import org.flixel.FlxTilemap;
	import org.flixel.FlxGroup;
	import org.flixel.FlxG;
	import org.flixel.FlxPath
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.FlxBar;
	
	/**
	 * ...
	 * @author Kenny
	 */
	public class Skater extends ZzUnit
	{
		public static const TYPE_SIMPLE:String = "simple";
		[Embed(source='../media/skater.png')]
		private var skaterPNG:Class;
		[Embed(source='../media/skater2.png')]
		private var skater2PNG:Class;
		
		private static const SKATER_DEATH_SLACK:Number = 1; // seconds
		private static const START_TIME:Number = 0.5;
		private var goingLeft:Boolean = false;
		private var goingRight:Boolean = false;
		private var goingUp:Boolean = false;
		private var goingDown:Boolean = false;
		private var isControlled:Boolean = false;
		//The total time that this skater should skate for in seconds
		private var timeToSkate:int;
		//The internal timer that tracks how long to skate for
		public var timer:ZzTimer;
		//The progress bar for displaying how much time is left
		private var progress:FlxBar;
		//A value counting up to timeToSkate
		public var progressTime:Number;
		//The skater death timer
		private var deathTimer:ZzTimer;
		//This is set when a skater is stuck
		private var skaterStuck:Boolean;
		//Sound played when this skater is stuck
		private var skaterStuckSnd:SoundChannel;
		//Handles skater death explosion
		private var explosion:FlxEmitter;
		
		private var isStarted:Boolean = false;
		
		// color of trail associated with this skater
		private var trailColor:uint; 
		
		// Type of skater for later use
		private var type:String;
		
		private var skaterComplete:Function;
		
		public function Skater(X:Number, Y:Number, time:int, type:String = TYPE_SIMPLE, toX:Number = 0, toY:Number = 0, dir:String = "DOWN")
		{
			// randomly choose a trail color
			trailColor = Math.floor(Math.random() * LevelLoader.NUM_COLORS) + LevelLoader.TRAIL_TILE_INDEX;
			
			super(X, Y);
			this.type = type;
			timeToSkate = time;
			timer = new ZzTimer();
			progress = new FlxBar(x, y, 1, 48, 8, this, "progressTime", 0, time);
			progressTime = 1;
			progress.trackParent(-12, -26);
			//progress.createFilledBar(0x60112080, 0xF060A0FF, true, 0xff000000);
			progress.createFilledBar(0xF060A0FF, 0x60112080, true, 0xff000000);
			progress.update();
			//offset for specifying animations
			var o:Number = 0;
			//place holder stuff
			if (Math.random() < .5) {
				loadGraphic(skaterPNG, true, true, 32, 32, true);
				addAnimation("walkS", [o + 0, o + 1, o + 2, o + 3, o + 4, o + 5, o + 6, o + 7, o + 8, o + 9, o + 10, o + 11], 6, true);
				o = 16;
				addAnimation("walkN", [o + 0, o + 1, o + 2, o + 3, o + 4, o + 5, o + 6, o + 7, o + 8, o + 9, o + 10, o + 11], 6, true);
				o = 32;
				addAnimation("walkW", [o + 0, o + 1, o + 2, o + 3, o + 4, o + 5, o + 6, o + 7, o + 8, o + 9, o + 10, o + 11], 6, true);
				o = 48;
				addAnimation("walkE", [o + 0, o + 1, o + 2, o + 3, o + 4, o + 5, o + 6, o + 7, o + 8, o + 9, o + 10, o + 11], 6, true);
				o = 64;
				addAnimation("death", [o + 0, o + 1, o + 2, o + 3, o + 4], 8, true);
				addAnimation("hurt", [16], 1, true);
			}else {
				loadGraphic(skater2PNG, true, true, 32, 32, true);
				addAnimation("walkS", [o + 0, o + 1, o + 2, o + 3, o + 4, o + 5, o + 6, o + 7, o + 8, o + 9, o + 10, o + 11], 6, true);
				o = 16;
				addAnimation("walkN", [o + 0, o + 1, o + 2, o + 3, o + 4, o + 5, o + 6, o + 7, o + 8, o + 9, o + 10, o + 11], 6, true);
				o = 32;
				addAnimation("walkW", [o + 0, o + 1, o + 2, o + 3, o + 4, o + 5, o + 6, o + 7, o + 8, o + 9, o + 10, o + 11], 6, true);
				o = 48;
				addAnimation("walkE", [o + 0, o + 1, o + 2, o + 3, o + 4, o + 5, o + 6, o + 7, o + 8, o + 9, o + 10, o + 11], 6, true);
				o = 64;
				addAnimation("death", [o + 0, o + 1, o + 2, o + 3, o + 4], 8, true);
				addAnimation("hurt", [16], 1, true);
			}
			deathTimer = new ZzTimer();
			setupSkaterDeath()
			
			// Change sprite size to be size of tile (better for trails)
			this.width = LevelLoader.TILE_SIZE;
			this.height = LevelLoader.TILE_SIZE;
			this.allowCollisions = 0;
			this.offset = new FlxPoint(12, 18); // used trial and error here
			maxVelocity.x = 150;
			maxVelocity.y = 150;
			drag.x = maxVelocity.x * 4;
			drag.y = maxVelocity.y * 4;
			if (dir == "DOWN") {
				goingDown = true;
			}else if (dir == "LEFT") {
				goingLeft = true;
			}else if (dir == "RIGHT") {
				goingRight = true;
			}else {
				goingUp = true;
			}
			this.play("walkS", true);
			// Set up initial path that jumps over entrance ruts
			var pt:FlxPath = new FlxPath();
			pt.addPoint(getMidpoint());
			var endPoint:FlxPoint = new FlxPoint(getMidpoint().x, getMidpoint().y);
			if (toX == 0 && toY == 0) {
				isStarted = true;
				allowCollisions = FlxObject.ANY; 
			}else {
				if (toX != 0) {
					endPoint.x = toX;
				}
				if (toY != 0) {
					endPoint.y = toY;
				}
				pt.addPoint(endPoint);
				this.followPath(pt, 120);
				new ZzTimer().start(START_TIME, 1, function (t:*) : void { 
					isStarted = true;
					allowCollisions = FlxObject.ANY; 
					stopFollowingPath(true); } );
			}
			
			ZzLog.logAction(ZzLog.ACTION_SKATER_ENTER, getLoggableObject() );
		}
		
		override public function postConstruct(addDependency:Function):void
		{
			timer.start(timeToSkate, 1, timerUp);
			LevelLoader.SOUND_PLAYER.play("skaterStart");
			addDependency(progress);
			addDependency(explosion);
		}
		
		override public function preUpdate():void
		{
			super.preUpdate();
			if (!isStarted) return;
			if (!timer.finished && !skaterStuck)
			{
				var mp:FlxPoint = getMidpoint();
				var tilemap:FlxTilemap = PlayState(FlxG.state).level;
				var xTile:uint = uint(mp.x / LevelLoader.TILE_SIZE);
				var yTile:uint = uint(mp.y / LevelLoader.TILE_SIZE);
				var currentTile:uint = tilemap.getTile(xTile, yTile);
				if (currentTile >= LevelLoader.ICE_TILE_INDEX && currentTile < LevelLoader.ICE_TILE_INDEX_END)
				{
					// Add skater trail
					tilemap.setTile(xTile, yTile, trailColor, true);
				}
				else if (currentTile >= LevelLoader.DOWN_ARROW_BLOCK && currentTile <= LevelLoader.RIGHT_ARROW_BLOCK)
				{
					// We are on top of an arrow block.  We have to check for < 3 obstacles because 
					// otherwise we will get stuck and not trigger a skater death.
					if (currentTile == LevelLoader.DOWN_ARROW_BLOCK)
					{
						if (!goingDown && !(touching & FlxObject.DOWN))
						{
							clearDirection();
							goingDown = true;
						}
					}
					else if (currentTile == LevelLoader.UP_ARROW_BLOCK)
					{
						if (!goingUp && !(touching & FlxObject.UP))
						{
							clearDirection();
							goingUp = true;
						}
					}
					else if (currentTile == LevelLoader.RIGHT_ARROW_BLOCK)
					{
						if (!goingRight && !(touching & FlxObject.RIGHT))
						{
							clearDirection();
							goingRight = true;
						}
					}
					else if (currentTile == LevelLoader.LEFT_ARROW_BLOCK)
					{
						if (!goingLeft && !(touching & FlxObject.LEFT))
						{
							clearDirection();
							goingLeft = true;
						}
					}
					tilemap.setTile(xTile, yTile, trailColor, true);
				}
			}
		}
		
		override public function update():void
		{
			super.update();
			if (!alive) return;
			if(pathSpeed ==0){
				checkPit(skaterDeathHandler);
			}
			var curTile:FlxPoint = getMidpoint();
			if (!isStarted) return;
			if (skaterStuck && !isStuck(curTile.x / LevelLoader.TILE_SIZE, curTile.y / LevelLoader.TILE_SIZE)) {
				endStuck();
			}
			if (!timer.finished)
			{
				if (skaterStuck)
				{
					this.play("death", false);
				}
				else if (goingLeft)
				{
					velocity.x = -maxVelocity.x;
					velocity.y = 0;
					this.play("walkW", false);
				}
				else if (goingRight)
				{
					velocity.x = maxVelocity.x;
					velocity.y = 0;
					this.play("walkE", false);
				}
				else if (goingDown)
				{
					velocity.x = 0;
					velocity.y = maxVelocity.y;
					this.play("walkS", false);
				}
				else if (goingUp)
				{
					velocity.x = 0;
					velocity.y = -maxVelocity.y;
					this.play("walkN", false);
				}
				progressTime = timeToSkate - timer.timeLeft;
			}
			else if(alive)
			{
				progressTime = timeToSkate;
				if (this.pathSpeed == 0)
				{
					ZzLog.logAction(ZzLog.ACTION_SKATER_EXIT, getLoggableObject());
					exists = false;
					progress.exists = false;
					//PlayState(FlxG.state).skaterComplete(this, false);
					skaterComplete(this, false);
				}
			}
		
		}
		
		private function timerUp(t:ZzTimer):void
		{
			if (!alive) return;
			endStuck();
			LevelLoader.SOUND_PLAYER.play("skaterSuccess");
			var p:FlxPath = new FlxPath();
			p.addPoint(getMidpoint());
			p.addPoint(ZzUtils.getNearestEntrance(getMidpoint()));
			this.allowCollisions = 0;
			progress.createFilledBar(0xFFFFFF00, 0xFFFFFF00, true, 0xff000000);
			progress.update();
			this.followPath(p, 100);
		}
		
		override public function setNextMove(level:FlxTilemap, entities:FlxGroup):void
		{
		}
		
		private function skaterDeathHandler(timer:ZzTimer=null):void
		{
			ZzLog.logAction(ZzLog.ACTION_SKATER_DIE, getLoggableObject() );
			LevelLoader.SOUND_PLAYER.play("skaterDeath");
			alive = false;
			exists = false;
			progress.exists = false;
			if (timer != null) {
				startSkaterDeath();
				timer.start(2, 1, skaterDeathCleanup);
			} else {
				skaterDeathCleanup();
			}
		}
		
		private function skaterDeathCleanup(timer:ZzTimer = null):void {
			explosion.kill();
			//PlayState(FlxG.state).skaterComplete(this, true);
			skaterComplete(this, true);
		}
		
		override public function onCollision(other:FlxObject):void
		{
			var curTile:FlxPoint = getMidpoint();
			// Check tiles around current tile to see if skater is stuck
			if (isStuck(curTile.x / LevelLoader.TILE_SIZE, curTile.y / LevelLoader.TILE_SIZE))
			{
				if (!skaterStuck)
				{
					ZzLog.logAction(ZzLog.ACTION_SKATER_STUCK, getLoggableObject() );
					skaterStuck = true;
					deathTimer.start(SKATER_DEATH_SLACK, 1, skaterDeathHandler);
	
					skaterStuckSnd =  LevelLoader.SOUND_PLAYER.play("skaterStuck", 0, (int)(SKATER_DEATH_SLACK / (LevelLoader.SOUND_PLAYER.length("skaterStuck"))));
				}
			}
			else if (skaterStuck)
			{
				endStuck();
			}
			if (goingLeft)
				isGoingLeft();
			else if (goingDown)
				isGoingDown();
			else if (goingUp)
				isGoingUp();
			else if (goingRight)
				isGoingRight();
			if (other is WalkingDead)
			{
				ZzLog.logAction(ZzLog.ACTION_SKATER_EATEN_BY_ZOMBIE, getLoggableObject());
				skaterDeathHandler(new ZzTimer());
			}
		}
		
		//Function called when skater gets free from being stuck
		private function endStuck():void
		{
			
			ZzLog.logAction(ZzLog.ACTION_SKATER_UNSTUCK, getLoggableObject() );
			if (skaterStuckSnd)
			{
				skaterStuckSnd.stop();
			}
			skaterStuck = false;
			deathTimer.stop();
			_flicker = false;
			_flickerTimer = 0;
		}
		
		public function isGoingLeft():void
		{
			if (goingLeft && (touching & FlxObject.LEFT))
			{
				if (!(touching & FlxObject.DOWN))
				{
					goingLeft = false;
					goingDown = true;
				}
				else if (!(touching & FlxObject.RIGHT))
				{
					goingLeft = false;
					goingRight = true;
				}
				else if (!(touching & FlxObject.UP))
				{
					goingLeft = false;
					goingUp = true;
				}
			}
		}
		
		private function checkNumObstacles(curPosX:uint, curPosY:uint):uint
		{
			var tileMap:FlxTilemap = PlayState(FlxG.state).level;
			var numObstacles:uint = 0;
			if (tileMap.getTile(curPosX, curPosY - 1) > LevelLoader.RIGHT_ARROW_BLOCK || tileMap.getTile(curPosX, curPosY - 1) == LevelLoader.ENTRANCE_TILE_INDEX)
				numObstacles++;
			if (tileMap.getTile(curPosX, curPosY + 1) > LevelLoader.RIGHT_ARROW_BLOCK || tileMap.getTile(curPosX, curPosY + 1) == LevelLoader.ENTRANCE_TILE_INDEX)
				numObstacles++;
			if (tileMap.getTile(curPosX - 1, curPosY) > LevelLoader.RIGHT_ARROW_BLOCK || tileMap.getTile(curPosX - 1, curPosY) == LevelLoader.ENTRANCE_TILE_INDEX)
				numObstacles++;
			if (tileMap.getTile(curPosX + 1, curPosY) > LevelLoader.RIGHT_ARROW_BLOCK || tileMap.getTile(curPosX + 1, curPosY) == LevelLoader.ENTRANCE_TILE_INDEX)
				numObstacles++;
			return numObstacles;
		}
		
		/**
		 * Returns true if the skater is currently stuck
		 * @param	curPosX
		 * @param	curPosY
		 */
		public function isStuck(curPosX:uint, curPosY:uint):Boolean {
			var tileMap:FlxTilemap = PlayState(FlxG.state).level;
			if (tileMap.getTile(curPosX, curPosX) == LevelLoader.ENTRANCE_TILE_INDEX) {
				//trace("skater on entrance tile: " + curPosX + ", " + curPosY);
				return ZzUtils.entranceBlocked(new FlxPoint(curPosX, curPosY));
			}
			//trace("skater on entrance tile: " + curPosX + ", " + curPosY);
			return !(tileMap.getTile(curPosX + 1, curPosY) <= LevelLoader.RIGHT_ARROW_BLOCK ||
			         tileMap.getTile(curPosX - 1, curPosY) <= LevelLoader.RIGHT_ARROW_BLOCK ||
					 tileMap.getTile(curPosX, curPosY + 1) <= LevelLoader.RIGHT_ARROW_BLOCK ||
					 tileMap.getTile(curPosX, curPosY - 1) <= LevelLoader.RIGHT_ARROW_BLOCK);
		}
		
		public function isGoingRight():void
		{
			if (goingRight && (touching & FlxObject.RIGHT))
			{
				if (!(touching & FlxObject.UP))
				{
					goingRight = false;
					goingUp = true;
				}
				else if (!(touching & FlxObject.LEFT))
				{
					goingRight = false;
					goingLeft = true;
				}
				else if (!(touching & FlxObject.DOWN))
				{
					goingRight = false;
					goingDown = true;
				}
			}
		}
		
		public function isGoingUp():void
		{
			if (goingUp && (touching & FlxObject.UP))
			{
				if (!(touching & FlxObject.LEFT))
				{
					goingUp = false;
					goingLeft = true;
				}
				else if (!(touching & FlxObject.DOWN))
				{
					goingUp = false;
					goingDown = true;
				}
				else if (!(touching & FlxObject.RIGHT))
				{
					goingUp = false;
					goingRight = true;
				}
			}
		}
		
		public function isGoingDown():void
		{
			if (goingDown && (touching & FlxObject.DOWN))
			{
				if (!(touching & FlxObject.RIGHT))
				{
					goingDown = false;
					goingRight = true;
				}
				else if (!(touching & FlxObject.UP))
				{
					goingDown = false;
					goingUp = true;
				}
				else if (!(touching & FlxObject.LEFT))
				{
					goingDown = false;
					goingLeft = true;
				}
			}
		}
		
		private function clearDirection():void
		{
			goingDown = goingUp = goingLeft = goingRight = false;
		}
		
		private function setupSkaterDeath():void {
			explosion = new FlxEmitter(4, 4, 100);
			var color:Array = new Array( 0xff000000, 0xffff0000, 0xff0101df );
			for (var i:uint = 0; i < 100; ++i) {
				var particle:FlxParticle = new FlxParticle();
				particle.makeGraphic(4, 4, color[i%3]);
				particle.exists = false;
				explosion.add(particle);
			}
		}
		
		public function setSkaterCompleteFn(complete:Function):void {
			this.skaterComplete = complete;
		}
		
		private function startSkaterDeath():void {
			explosion.at(this);
			explosion.gravity = 100;
			explosion.start(true, 2);
		}
		
		override public function destroy():void {
			super.destroy();
			timer = null;
			progress.destroy();
			deathTimer = null;
			explosion.destroy();
		}
		
		/**
		 * Returns a loggable summary of this object's state
		 * @return
		 */
		public override function getLoggableObject() : Object {
			return { 
					"type" : type, 
					"x" : x, 
					"y" : y, 
					"id" : this.ID 
					};
		}
	}

}