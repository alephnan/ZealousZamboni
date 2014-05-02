package
{
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	import org.flixel.*;
	import flash.utils.getQualifiedClassName;
	
	/**
	 * ...
	 * @author Kenny
	 */
	public class Zamboni extends ZzUnit 
	{
		public function Zamboni(startX:Number) {
			super(startX, 0);
			//place holder stuff
			makeGraphic(10,12,0xffaa1111);
			maxVelocity.x = 80;
			maxVelocity.y = 80;
			drag.x = maxVelocity.x * 4;
			drag.y = maxVelocity.y * 4;
		}
		
		override public function onCollision(other:FlxObject) : void {
			
		}
	}
	
}