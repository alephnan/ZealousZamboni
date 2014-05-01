package 
{
	import org.flixel.FlxGroup;
	import org.flixel.FlxObject;
	import org.flixel.FlxSprite;
	import org.flixel.FlxTilemap;
	
	/**
	 * ...
	 * @author Kenny
	 * 
	 * Parent class for anything that has special collision and/or path finding logic
	 */
	public class ZzUnit extends FlxSprite implements ICollidable
	{
		public function ZzUnit(X:Number, Y:Number) {
			super(X, Y);
		}
		
		public function setNextMove(level:FlxTilemap, entities:FlxGroup) : void {
			
		}
		
		public function onCollision(other:FlxObject) : void {
			
		}
	}
}