package
{
	import flash.events.SoftKeyboardTrigger;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	import org.flixel.*;
	import flash.utils.getQualifiedClassName;
	import org.flixel.system.FlxTile;
	
	/**
	 * ...
	 * @author Kenny
	 */
	public class Zamboni extends ZzUnit 
	{	
		[Embed(source = '../media/zamboni_4way.png')] private var zamboniPNG:Class;
		private static var NS_ANGLE:int = 90;	//angle to rotate North, south sprites to correct their rotation
		
		private static var QUAD_OFFSET:int = 45;		//angle offset of quadrant selection for specifying sprite anim
		
		public function Zamboni(startX:Number, startY:Number) {
			super(startX, startY);
			//place holder stuff
			//makeGraphic(10,12,0xffaa1111);
			loadGraphic(zamboniPNG, true, true, 64, 32, true);
			addAnimation("walkW", [0, 1, 2, 3], 4, true);
			addAnimation("walkE", [4,5,6,7], 4, true);
			addAnimation("walkN", [8, 9, 10, 11], 4, true);
			addAnimation("walkS", [12,13,14,15], 4, true);
			maxVelocity.x = 120;
			maxVelocity.y = 120;
			drag.x = maxVelocity.x * 4;
			drag.y = maxVelocity.y * 4;
			
			// This makes the path erasing a little more realistic
			width = 60;
			height = 28;
		}
		
		/*
		 * Function used to melt ice BEFORE the zamboni collides with it (which would slow it down)
		 */
		private function meltIce() : void {
			var tileMap:FlxTilemap = PlayState(FlxG.state).level;
			var oldx:Number = x;
			var oldy:Number = y;
			this.updateMotion();
			tileMap.overlapsWithCallback(this, function(tile:FlxTile, e1:FlxObject) : void {
				if (tile.index == LevelLoader.TRAIL_TILE_INDEX) {
					tileMap.setTile(tile.x / LevelLoader.TILE_SIZE, tile.y / LevelLoader.TILE_SIZE, 0, true);
				}
			})
			y = oldy;
			x = oldx;
		}
		
		override public function update() : void {
			meltIce();
			if (FlxG.mouse.pressed()) {
				//Old code that rotated in 360 degree coords
				//this.angle = 180 / Math.PI * Math.atan2(FlxG.mouse.x - x, y - FlxG.mouse.y);
				//new code: update animation as necessary and rotate sprite
				//angle between zamboni and mouse in degrees
				var ang:Number = (180 / Math.PI) * Math.atan2(y - FlxG.mouse.y, FlxG.mouse.x - x);
				if (ang < QUAD_OFFSET)
					ang += 360;
				if (0+QUAD_OFFSET <= ang && ang < 90 +QUAD_OFFSET) {
					play("walkN");
					this.angle = NS_ANGLE;
					facing = FlxObject.UP;
				}else if (90 + QUAD_OFFSET <= ang && ang < 180 + QUAD_OFFSET) {
					this.angle = 0;
					play("walkW");
					facing = FlxObject.RIGHT;
				}else if (180 + QUAD_OFFSET <= ang && ang < 270 + QUAD_OFFSET) {
					this.angle = NS_ANGLE;
					play("walkS");
					facing = FlxObject.DOWN;
				}else {
					this.angle = 0;
					play("walkE");
					facing = FlxObject.RIGHT;
				}
			}
			
			
		}
		
		override public function onCollision(other:FlxObject) : void {
			if (other is FlxTile && FlxTile(other).index == LevelLoader.TRAIL_TILE_INDEX) {
				PlayState(FlxG.state).level.setTile(other.x / LevelLoader.TILE_SIZE, other.y / LevelLoader.TILE_SIZE, 0, true);
			} else if (other is Skater) {
				
			}
		}
	}
	
}