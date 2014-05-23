package
{
	import flash.events.SoftKeyboardTrigger;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	import org.flixel.*;
	import org.flixel.system.FlxAnim;
	import org.flixel.system.FlxTile;
	
	/**
	 * ...
	 * @author Kenny
	 */
	public class Zamboni extends ZzUnit 
	{	
		private static var NS_ANGLE:int = 90;	//angle to rotate North, south sprites to correct their rotation
		
		private static var QUAD_OFFSET:int = 45;		//angle offset of quadrant selection for specifying sprite anim
		
		private var level:FlxTilemap;
		private var levelCopy:Array;
		//param level is supposed to be a pristine copy of the current tilemap
		
		// constants for sliding motion on ice.
		// variable names "acceleration" and "friction" already inherited used by ZzUnit
		private var CUSTOM_ACCELERATION:Number = 50;
		private static const CUSTOM_FRICTION:Number = 5;
		private var tireChains:Boolean = false;
		// how far a trail can be away from zamboni boundary area, and still be considered overlap
		private static const ZAMBONI_TRAIL_CLEANING_TOLERANCE : uint = 6;
		
		// true if zamboni is in horizontal orientation, false for vertical
		private var horizontal:Boolean;
		
		/* Flags to show bounding box */
		// FlxG.debug = true;
		// FlxG.visualDebug = true;
		
		public function Zamboni(startX:Number, startY:Number, level:FlxTilemap) {
			super(startX, startY);
			levelCopy = ZzUtils.copyArray(level.getData(false));
			this.level = level;
			//place holder stuff
			//makeGraphic(10,12,0xffaa1111);
			loadGraphic(Media.zamboniPNG, true, true, 64, 32, true);
			addAnimation("walkW", [0, 1, 2, 3], 4, true);
			addAnimation("walkE", [4,5,6,7], 4, true);
			addAnimation("walkN", [8, 9, 10, 11], 4, true);
			addAnimation("walkS", [12,13,14,15], 4, true);
			maxVelocity.x = 170;
			maxVelocity.y = 170;
			velocity.x = 0;
			velocity.y = 0;
			
			// initial bounding box of zamboni
			horizontal = true;
			orientboundingBoxHorizontal();
			play("walkWest");
		}
		
		/*
		 * Function used to melt ice BEFORE the zamboni collides with it (which would slow it down)
		 */
		private function meltIce() : void {
			var oldx:Number = x;
			var oldy:Number = y;
			
			//this.updateMotion();
			
			// Unfortunately, Flixel's default box based collision handling isn't working to well with our tiles.
			// It would occasionally get stuck and unable to clear a trail in front of it.  This has something to do
			// with the zamboni's velocity such that the zamboni wont overlap the trails.
			// The solution is to "teleport" the zamboni a little bit a head, north / west / east / south, in which
			// case, it'll forcefully overlap the trails to clear. Then we return the zamboni to its prior position.
			// This is inefficient because it calls trailSweep 4 times, each time iterating through the
			// FlxTileMap checking for overlap. An optimization would to be to calculate a small grid area 
			// around the zamboni, and only check tiles in this region for overlap. 
			
			// sweeps to east of zamboni
			x = oldx + ZAMBONI_TRAIL_CLEANING_TOLERANCE;
			trailSweep();
			
			// sweeps to west ofzamboni
			x = oldx - ZAMBONI_TRAIL_CLEANING_TOLERANCE;
			trailSweep();
			
			// sweep to south of zamboni
			x = oldx;
			y = oldy + ZAMBONI_TRAIL_CLEANING_TOLERANCE;
			trailSweep();
		
			// sweep to north of zamboni
			y = oldy - ZAMBONI_TRAIL_CLEANING_TOLERANCE;
			trailSweep();
			
			y = oldy;
			x = oldx;
		}
		
		// Clears Ice Tiles surrounding zamboni current position
		private function trailSweep() : void {
			
			level.overlapsWithCallback(this, function(tile:FlxTile, e1:FlxObject) : void {
				if (LevelLoader.isTrail(tile.index)) {
					var tx:Number = tile.x / LevelLoader.TILE_SIZE;
					var ty:Number = tile.y / LevelLoader.TILE_SIZE;
					var tileIndex:uint = ty * level.widthInTiles + tx;
					if (tileIndex < levelCopy.length) {
						var origTile:uint = levelCopy[ty * level.widthInTiles + tx];
						level.setTileByIndex(tileIndex, origTile, true);
					}
					// add point to player health
					//updatePlayerHealth(PlayerPoints.CLEAR_TRAIL_REWARD, false);
					//PlayerPoints.getRef().generateRewardOrPenalty(tile.getMidpoint(), PlayerPoints.CLEAR_TRAIL_REWARD, false);
					PlayState(FlxG.state).playerPoints.generateReward(getMidpoint(), PlayerPoints.CLEAR_TRAIL_REWARD, false);
				}
			})
		}
		
		// decides orientation of zamboni, based on mouse relative to zamboni
		private function updateOrientation() : void {
			// Remembers orientation and position before trying to rotate
			var oldhorizontal:Boolean = horizontal;
			
			//Old code that rotated in 360 degree coords
			//this.angle = 180 / Math.PI * Math.atan2(FlxG.mouse.x - x, y - FlxG.mouse.y);
			//new code: update animation as necessary and rotate sprite
			//angle between zamboni and mouse in degrees
			var ang:Number = (180 / Math.PI) * Math.atan2(y - FlxG.mouse.y, FlxG.mouse.x - x);
			if (ang < QUAD_OFFSET)
				ang += 360;
			
			
			if (0+QUAD_OFFSET <= ang && ang < 90 +QUAD_OFFSET) {
				faceNorth();
			} else if (90 + QUAD_OFFSET <= ang && ang < 180 + QUAD_OFFSET) {
				faceWest();
			} else if (180 + QUAD_OFFSET <= ang && ang < 270 + QUAD_OFFSET) {
				faceSouth();
			} else {
				faceEast();
			}
			
			// checks for rotation along wall
			wallHug(oldhorizontal);
		}
		
		/*public function updatePlayerHealth(updateAmount:Number, penalty:Boolean = true):void {
			if (updateAmount <= 0)
				return;
			if (penalty) {
				hurt(updateAmount);
			} else {
				if (health + updateAmount > PlayerPoints.PLAYER_MAX_HEALTH) {
					health = PlayerPoints.PLAYER_MAX_HEALTH;
				} else {
					health += updateAmount;
				}
			}
		}
		
		override public function hurt(damage:Number):void {
			if (health - damage < 0) {
				health = 0;
			} else {
				health -= damage;
			}
		}*/
		
		/*  Prevents zamboni from rotating when next to wall.  This would cause a glitch where
			zamboni can "rotate out" of wall, and drive off the rink! 
			
			Forces Zamboni to hug wall
			
			 @oldhorizontal
				whether zamboni was in horizontal or vertical orientation, prior to trying to rotation
		*/
		private function wallHug(oldhorizontal:Boolean) : void {
			// Check for rotation into wall
			var wallRotation:Boolean = false;
			level.overlapsWithCallback(this, function(tile:FlxTile, e1:FlxObject) : void {
				if (LevelLoader.isSolid(tile.index)) {
					wallRotation = true;
					
				} 
			})
			
			// hugs wall by undoing rotation
			if (wallRotation) {
				// tried rotating from horizontal to vertical along N/S wall. Hug wall in direction of x velocity
				if (oldhorizontal) {
					if (velocity.x < 0) {
						faceWest();
					} else {
						faceEast();
					}
				} else { // tried rotating from vertical to horizontal along W/E wall. Hug wall in direction of y velocity
					if (velocity.y < 0) {
						faceNorth();
					} else {
						faceSouth();
					}
				}
			}
		}
		
		// face boundary box and sprite, West
		private function faceWest() : void {
			play("walkW");
			facing = FlxObject.RIGHT;
			
			orientboundingBoxHorizontal();
	
			// offset the west sprite, with respect to the bounding box
			offset.x = 0;
			offset.y = 0;
		}

		// face boundary box and sprite, East
		private function faceEast() : void {
			play("walkE");
			facing = FlxObject.RIGHT;
			orientboundingBoxHorizontal();
			
			// offset the east sprite, with respect to bounding box
			offset.x = 14;
			offset.y = 0;
		}
		
		// face boundary box and sprite, North
		private function faceNorth() : void {
			play("walkN");
			facing = FlxObject.UP;
			
			orientBoundingBoxVertical();
			
			// offset the north sprite, with respect to the bounding box
			offset.x = 15;
			offset.y = -15;
		}
		
		// face boundary box and sprite, South
		private function faceSouth() : void {
			facing = FlxObject.DOWN;
			play("walkS");
			orientBoundingBoxVertical();
			
			// offset the south sprite, with respect to the bounding box
			offset.x = 15;
			offset.y = -5;
		}
		
		// rotate boundary box into horizontal orientation
		private function orientboundingBoxHorizontal() : void {
			this.angle = 0;
			
			// un-offset the rotated bounding box
			if (!horizontal) {
				x = x - 9;
				y = y + 9;
			} 
				
			width = 50;
			height = 32;
			horizontal = true;
				
		}
		
		// rotate bounding box into vertical orientation
		private function orientBoundingBoxVertical() : void {
			this.angle = NS_ANGLE;
			
			// offset the rotated bounding box
			if (horizontal) {
				x = x + 9;
				y = y - 9;
			}
				
			width = 32;
			height = 50;
			horizontal = false;
		}
		
		/* accelerate vehicle in direction of cursor relative to zamboni
			@xDirection, 
				scalar with value (-1, 0, or 1) to indicate direction 
				of acceleration to (west, stationary, east) respectively
			@yDirection:
				scalar with value (-1, 0, or 1) to indicate direction 
				of acceleration to (south, stationary, north) respectively
		*/	
		private function activeMotion(xDirection:int, yDirection:int, xDist:Number, yDist:Number) : void {
			if (tireChains) {
				if (Math.abs(xDist) > 16) {
					velocity.x = maxVelocity.x * xDirection;
				}else {
					velocity.x = 0;
				}
				if (Math.abs(yDist) > 16) {
					velocity.y = maxVelocity.y * yDirection;
				}else {
					velocity.y = 0;
				}
				return;
			}
			velocity.x += (xDirection * CUSTOM_ACCELERATION) * (Math.abs(xDist) / FlxG.width);
			velocity.y += (yDirection * CUSTOM_ACCELERATION) * (Math.abs(yDist) / FlxG.height);
		}
		
		/* Passive slow down zamboni by CUSTOM_FRICTION constant in direction zamboni
			is currently moving */
		private function passiveMotion() : void{
			if (tireChains) {
				velocity.x = 0;
				velocity.y = 0;
				return;
			}
			// first two cases: decelerate in direction zamboni is going
			if (velocity.x > CUSTOM_FRICTION) {
				velocity.x -= CUSTOM_FRICTION;
			} else if (velocity.x < -CUSTOM_FRICTION) {
				velocity.x += CUSTOM_FRICTION;
			} else { // vehicle is slow enough, round to 0
				velocity.x = 0;
			} 
			
			// symmetrical logic, but for Y-axis
			if (velocity.y > CUSTOM_FRICTION) {
				velocity.y -= CUSTOM_FRICTION;
			} else if (velocity.y < -CUSTOM_FRICTION) {
				velocity.y += CUSTOM_FRICTION;
			} else {
				velocity.y = 0;
			} 
		}
		
		override public function update() : void {
			meltIce();
			if (FlxG.mouse.pressed() || (FlxG.keys.SPACE && FlxG.mouse != null)) {
				updateOrientation();
				 
				// logic to determine direction of mouse relative to zamboni
				var mouse:FlxPoint = FlxG.mouse.getWorldPosition(); //mouse coordinates
				var z:FlxPoint = getMidpoint();
				var dx:Number = mouse.x - z.x;
				var dy:Number = mouse.y - z.y;
				// maps positive dx to 1, negative to -1, and 0 to 0
				var xDirection:Number = (dx == 0) ? 0 : 1;
				xDirection = (dx >= 0) ? xDirection : -1 * xDirection;
				// maps positive dy to 1, negative to -1, and 0 to 0
				var yDirection:Number = (dy == 0) ? 0 : 1;
				yDirection = (dy >= 0) ? yDirection : -1 * yDirection;
				
				// accelerate zamboni in direction of mouse
				activeMotion(xDirection, yDirection, dx, dy);
			} else {
				// mouse not pressed, passively slow down zamboni
				passiveMotion();
			}
		}
		
		override public function onCollision(other:FlxObject) : void {
			var t:FlxTimer = new FlxTimer();
			if (other is PowerUp) {
				//updatePlayerHealth(PlayerPoints.PICKUP_POWERUP_REWARD, false);
				PlayState(FlxG.state).playerPoints.generateReward(other.getMidpoint(), PlayerPoints.PICKUP_POWERUP_REWARD, false);
				ZzLog.logAction(ZzLog.ACTION_GAIN_POWER_UP,
					{ "type" : PowerUp(other).type, "x" : other.x, "y" : other.y, "id" : other.ID});
				if (PowerUp(other).type == PowerUp.BOOSTER) {
					maxVelocity.y *= PowerUp.BOOSTER_SPEED_AMT;
					maxVelocity.x *= PowerUp.BOOSTER_SPEED_AMT;
					t.start(PowerUp.BOOSTER_TIME_LENGTH, 1, function(timer:*) : void { 
						maxVelocity.x /= PowerUp.BOOSTER_SPEED_AMT; 
						maxVelocity.y /= PowerUp.BOOSTER_SPEED_AMT; 
					} );
					other.kill();
				}else if (PowerUp(other).type == PowerUp.STOP_WATCH) {
					var tdiff:Number = PowerUp.BOOSTER_SPEED_AMT * 4;
					maxVelocity.y *= tdiff;
					maxVelocity.x *= tdiff;
					FlxG.timeScale /= tdiff;
					t = new FlxTimer();
					t.start(PowerUp.BOOSTER_TIME_LENGTH/tdiff, 1, function(timer:*) : void { 
						maxVelocity.x /= tdiff; 
						maxVelocity.y /= tdiff; 
						FlxG.timeScale *= tdiff;
					} );
					other.kill();
				}else if (PowerUp(other).type == PowerUp.TIRE_CHAINS) {
					tireChains = true;
					var tm:FlxTimer = new FlxTimer();
					tm.start(PowerUp.TIRE_CHAINS_TIME_LENGTH, 1, function(timer:*) : void { 
						tireChains = false;
					} );
					other.kill();
				}
			}
		}
		
		override public function destroy():void {
			super.destroy();
			level = null;
			levelCopy = null;
		}
	}
	
}