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
		//Handles  death splash
		private var splashEmitter:FlxEmitter;
		
		public function ZzUnit(X:Number, Y:Number) {
			super(X, Y);
			setupSplash();
			ID = nextZId++;
		}
		
		/**
		 * FUnction to be called upon creation of a ZzUnit
		 * This takes a function that adds other units to the stage
		 * @param	addDependency
		 */
		public function postConstruct(addDependency:Function) : void {
			addDependency(splashEmitter);
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
				if (LevelLoader.isPit(tile.index)) {
					pitCounter++;
				}
			});
			var fallCounter:int = 8;
			//If we're over a pit, we fall in
			//This calculation looks super weird. What we're doing is basically
			//considering how many pixels are overlapping pits vs how many aren't
			//The exact numbers are totally arbitrary, and this should probably be done in a different way
			if (pitCounter * Math.pow(LevelLoader.TILE_SIZE, 2) > ((width + 8) * (height)) ) {
				splash();
				maxVelocity.x = 0;
				maxVelocity.y = 0;
				ZzLog.logAction(ZzLog.ACTION_UNIT_FALL, getLoggableObject());
				LevelLoader.SOUND_PLAYER.play("fall");
				alive = false;
				new ZzTimer().start(.2, fallCounter, function(t:ZzTimer) : void {
					if (t.finished) {
						finalDeath();
					}else {
						scale.x /= 1.5;
						scale.y /= 1.5;
						velocity.x = 0;
						velocity.y = 0;
						flicker(1);
					}
				});
			}
		}
		
		public function splash():void {
			splashEmitter.at(this);
			splashEmitter.gravity = 20;
			splashEmitter.start(true, 1);
		}
		private function setupSplash():void {
			splashEmitter = new FlxEmitter(4, 4, 50);
			var color:Array = new Array( 0xff0055ff, 0xff0077ff, 0xff0021df );
			for (var i:uint = 0; i < 50; ++i) {
				var particle:FlxParticle = new FlxParticle();
				particle.makeGraphic(4, 4, color[i%3]);
				particle.exists = false;
				splashEmitter.add(particle);
			}
		}
		
		/**
		 * Returns a loggable summary of this object's state
		 * @return
		 */
		public function getLoggableObject() : Object {
			return { 
					"ZzUnitType" : String(this),
					"x" : x, 
					"y" : y, 
					"id" : this.ID 
					};
		}
	}
}