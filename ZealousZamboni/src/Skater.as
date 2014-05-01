package
{
	import org.flixel.FlxObject;
	import org.flixel.FlxSprite;
	import org.flixel.FlxTilemap;
	import org.flixel.FlxGroup;
	import org.flixel.FlxG;
	
	/**
	 * ...
	 * @author Kenny
	 */
	public class Skater extends ZzUnit
	{
		private var goingLeft:Boolean = false;
		private var goingRight:Boolean = false;
		private var goingUp:Boolean = false;
		private var goingDown:Boolean = false;
		private var isControlled:Boolean = false;
		
		public function Skater(X:Number, Y:Number) {
			super(X, Y);
			//place holder stuff
			makeGraphic(10,12,0xff1111aa);
			maxVelocity.x = 80;
			maxVelocity.y = 80;
			drag.x = maxVelocity.x * 4;
			drag.y = maxVelocity.y * 4;
			goingRight = true;
		}
		
		override public function update() : void {
			if (goingLeft) {
				velocity.x = -maxVelocity.x;
				velocity.y = 0;
			}
			if (goingRight) {
				velocity.x = maxVelocity.x;
				velocity.y = 0;
			}
			if (goingDown) {
				velocity.x = 0;
				velocity.y = maxVelocity.y;
			}
			if (goingUp) {
				velocity.x = 0;
				velocity.y = -maxVelocity.y;
			}
		}
		
		
		override public function setNextMove(level:FlxTilemap, entities:FlxGroup) : void {
			
		}
		
		override public function onCollision(other:FlxObject) : void {
			rotate();
		}
		
		public function rotate() {
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