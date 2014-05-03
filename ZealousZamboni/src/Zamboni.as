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
		[Embed(source = '../media/zamboni.png')] private var zamboniPNG:Class;
		public function Zamboni(startX:Number, startY:Number) {
			super(startX, startY);
			//place holder stuff
			//makeGraphic(10,12,0xffaa1111);
			loadGraphic(zamboniPNG, true, true, 32, 64, true);
			addAnimation("walk", [0], 6, true);
			maxVelocity.x = 80;
			maxVelocity.y = 80;
			drag.x = maxVelocity.x * 4;
			drag.y = maxVelocity.y * 4;
			play("walk");
		}
		
		override public function update() : void {
			if(FlxG.mouse.pressed){
				this.angle = 180 / Math.PI * Math.atan2(FlxG.mouse.x - x, y - FlxG.mouse.y);
			}
		}
		
		override public function onCollision(other:FlxObject) : void {
			
		}
	}
	
}