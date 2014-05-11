package
{
	import flash.media.SoundChannel;
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
		[Embed(source='../media/skater.png')]
		private var skaterPNG:Class;
		[Embed(source='../media/skater2.png')]
		private var skater2PNG:Class;
		
		private static const SKATER_DEATH_SLACK:uint = 5; // seconds
		
		private var goingLeft:Boolean = false;
		private var goingRight:Boolean = false;
		private var goingUp:Boolean = false;
		private var goingDown:Boolean = false;
		private var isControlled:Boolean = false;
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
		//Sound played when this skater is stuck
		private var skaterStuckSnd:SoundChannel;
		
		public function Skater(X:Number, Y:Number, time:int)
		{
			super(X, Y);
			timeToSkate = time;
			timer = new FlxTimer();
			progress = new FlxBar(x, y, 1, 48, 8, this, "progressTime", 0, time);
			progressTime = 1;
			progress.trackParent(-12, -26);
			progress.createFilledBar(0x60112080, 0xF060A0FF, true, 0xff000000);
			progress.update();
			
			//place holder stuff
			if (Math.random() < .5) {
				loadGraphic(skaterPNG, true, true, 32, 32, true);
				var o:Number = 0; //offset for specifying animations
				addAnimation("walkS", [o + 0, o + 1, o + 2, o + 3, o + 4, o + 5, o + 6, o + 7, o + 8, o + 9, o + 10, o + 11], 6, true);
				o = 16;
				addAnimation("walkN", [o + 0, o + 1, o + 2, o + 3, o + 4, o + 5, o + 6, o + 7, o + 8, o + 9, o + 10, o + 11], 6, true);
				o = 32;
				addAnimation("walkW", [o + 0, o + 1, o + 2, o + 3, o + 4, o + 5, o + 6, o + 7, o + 8, o + 9, o + 10, o + 11], 6, true);
				o = 48;
				addAnimation("walkE", [o + 0, o + 1, o + 2, o + 3, o + 4, o + 5, o + 6, o + 7, o + 8, o + 9, o + 10, o + 11], 6, true);
				addAnimation("death", [6, 22, 38, 54], 8, true);
				addAnimation("hurt", [16], 1, true);
			}else {
				loadGraphic(skater2PNG, true, true, 32, 32, true);
				var o:Number = 0; //offset for specifying animations
				addAnimation("walkS", [o + 0, o + 1, o + 2, o + 3, o + 4, o + 5, o + 6, o + 7, o + 8, o + 9, o + 10, o + 11], 6, true);
				o = 16;
				addAnimation("walkN", [o + 0, o + 1, o + 2, o + 3, o + 4, o + 5, o + 6, o + 7, o + 8, o + 9, o + 10, o + 11], 6, true);
				o = 32;
				addAnimation("walkW", [o + 0, o + 1, o + 2, o + 3, o + 4, o + 5, o + 6, o + 7, o + 8, o + 9, o + 10, o + 11], 6, true);
				o = 48;
				addAnimation("walkE", [o + 0, o + 1, o + 2, o + 3, o + 4, o + 5, o + 6, o + 7, o + 8, o + 9, o + 10, o + 11], 6, true);
				addAnimation("death", [6, 22, 38, 54], 8, true);
				addAnimation("hurt", [16], 1, true);
			}
			//loadGraphic(skaterPNG, true, true, 32, 32, true);
			deathTimer = new FlxTimer();
			
			// Change sprite size to be size of tile (better for trails)
			this.width = LevelLoader.TILE_SIZE;
			this.height = LevelLoader.TILE_SIZE;
			this.offset = new FlxPoint(12, 18); // used trial and error here
			
			/*var o:Number = 0; //offset for specifying animations
			addAnimation("walkS", [o + 0, o + 1, o + 2, o + 3, o + 4, o + 5, o + 6, o + 7, o + 8, o + 9, o + 10, o + 11], 6, true);
			o = 16;
			addAnimation("walkN", [o + 0, o + 1, o + 2, o + 3, o + 4, o + 5, o + 6, o + 7, o + 8, o + 9, o + 10, o + 11], 6, true);
			o = 32;
			addAnimation("walkW", [o + 0, o + 1, o + 2, o + 3, o + 4, o + 5, o + 6, o + 7, o + 8, o + 9, o + 10, o + 11], 6, true);
			o = 48;
			addAnimation("walkE", [o + 0, o + 1, o + 2, o + 3, o + 4, o + 5, o + 6, o + 7, o + 8, o + 9, o + 10, o + 11], 6, true);
			addAnimation("death", [6, 22, 38, 54], 8, true);
			addAnimation("hurt", [16], 1, true);*/
			maxVelocity.x = 120;
			maxVelocity.y = 120;
			drag.x = maxVelocity.x * 4;
			drag.y = maxVelocity.y * 4;
			goingDown = true;
			this.play("walkS", true);
		}
		
		override public function postConstruct(addDependency:Function):void
		{
			timer.start(timeToSkate, 1, timerUp);
			SoundPlayer.skaterStart.play();
			addDependency(progress);
		}
		
		override public function preUpdate():void
		{
			super.preUpdate();
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
					tilemap.setTile(xTile, yTile, LevelLoader.TRAIL_TILE_INDEX, true);
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
				}
			}
		}
		
		override public function update():void
		{
			super.update();
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
			else
			{
				progressTime = timeToSkate;
				if (this.pathSpeed == 0)
				{
					exists = false;
					progress.exists = false;
					PlayState(FlxG.state).skaterComplete(this, false);
				}
			}
		
		}
		
		private function timerUp(t:FlxTimer):void
		{
			endStuck();
			SoundPlayer.skaterSuccess.play();
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
		
		private function skaterDeathHandler(timer:FlxTimer = null):void
		{
			SoundPlayer.skaterDeath.play();
			exists = false;
			progress.exists = false;
			PlayState(FlxG.state).skaterComplete(this, true);
		}
		
		override public function onCollision(other:FlxObject):void
		{
			var curTile:FlxPoint = getMidpoint();
			// Check tiles around current tile to see if skater is stuck
			if (checkNumObstacles(curTile.x / LevelLoader.TILE_SIZE, curTile.y / LevelLoader.TILE_SIZE) == 4)
			{
				if (!skaterStuck)
				{
					skaterStuck = true;
					this.flicker(SKATER_DEATH_SLACK);
					deathTimer.start(SKATER_DEATH_SLACK, 1, skaterDeathHandler);
					skaterStuckSnd = SoundPlayer.skaterStuck.play(0, (int)(SKATER_DEATH_SLACK / (SoundPlayer.skaterStuck.length / 1000)));
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
				skaterDeathHandler();
			}
		}
		
		//Function called when skater gets free from being stuck
		private function endStuck():void
		{
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
			if (tileMap.getTile(curPosX, curPosY - 1) >= LevelLoader.DOWN_ARROW_BLOCK || tileMap.getTile(curPosX, curPosY - 1) == LevelLoader.ENTRANCE_TILE_INDEX)
				numObstacles++;
			if (tileMap.getTile(curPosX, curPosY + 1) >= LevelLoader.DOWN_ARROW_BLOCK || tileMap.getTile(curPosX, curPosY + 1) == LevelLoader.ENTRANCE_TILE_INDEX)
				numObstacles++;
			if (tileMap.getTile(curPosX - 1, curPosY) >= LevelLoader.DOWN_ARROW_BLOCK || tileMap.getTile(curPosX - 1, curPosY) == LevelLoader.ENTRANCE_TILE_INDEX)
				numObstacles++;
			if (tileMap.getTile(curPosX + 1, curPosY) >= LevelLoader.DOWN_ARROW_BLOCK || tileMap.getTile(curPosX + 1, curPosY) == LevelLoader.ENTRANCE_TILE_INDEX)
				numObstacles++;
			return numObstacles;
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
	}

}