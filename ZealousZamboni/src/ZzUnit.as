package 
{
	import org.flixel.FlxGroup;
	import org.flixel.FlxObject;
	import org.flixel.FlxSprite;
	import org.flixel.FlxTilemap;
	import org.flixel.*;
	import org.flixel.system.FlxTile;
	
	/**
	 * ...
	 * @author Kenny
	 * 
	 * Parent class for anything that has special collision and/or path finding logic
	 */
	public class ZzUnit extends FlxSprite implements ICollidable
	{
		
		private static var nextZId:int = 0;
		
		public function ZzUnit(X:Number, Y:Number) {
			super(X, Y);
			ID = nextZId++;
		}
		
		/**
		 * FUnction to be called upon creation of a ZzUnit
		 * This takes a function that adds other units to the stage
		 * @param	addDependency
		 */
		public function postConstruct(addDependency:Function) : void {
			
		}
		
		public function setNextMove(level:FlxTilemap, entities:FlxGroup) : void {
			
		}
		
		public function onCollision(other:FlxObject) : void {
			
		}
		
		/**
		 * Checks if this object is over a pit and makes it fall if it is.
		 * Calls the finalDeath function when the object has fallen all the way
		 * Will instantly set alive to false if the object is over a pit
		 * @param	finalDeath
		 */
		public function checkPit(finalDeath:Function) : void {
			if (!alive) return;
			// Clears Ice Tiles surrounding zamboni current position
			//trace("Check pit");
			var overPit:Boolean = true;
			this.stopFollowingPath();
			var pitCounter:Number = 0;
			var self:FlxObject = this;
			//Here we get the property level instead of using the . notation because both startState and PlayState have levels
			FlxTilemap(FlxG.state["level"]).overlapsWithCallback(this, function(tile:FlxTile, e1:FlxObject) : void {
				if (tile.index == LevelLoader.PIT_INDEX) {
					pitCounter++;
				}
			});
			var fallCounter:int = 8;
			//If we're over a pit, we fall in
			//This calculation looks super weird. What we're doing is basically
			//considering how many pixels are overlapping pits vs how many aren't
			//The exact numbers are totally arbitrary, and this should probably be done in a different way
			if (pitCounter*Math.pow(LevelLoader.TILE_SIZE,2) >= ((width)*(height)) ) {
				LevelLoader.SOUND_PLAYER.play("fall");
				alive = false;
				new FlxTimer().start(.2, fallCounter, function(t:FlxTimer) : void {
					if (t.finished) {
						finalDeath();
					}else {
						scale.x /= 1.5;
						scale.y /= 1.5;
						velocity.x = 0;
						velocity.y = 0;
						angle += 45;
					}
				});
			}
		}
	}
}