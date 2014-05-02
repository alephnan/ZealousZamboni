package
{
	import org.flixel.FlxSprite;
	
	/**
	 * ...
	 * @author Kenny
	 */
	public class Zamboni extends FlxSprite 
	{
		public function Zamboni(startX:Number) {
			super(startX);
			//place holder stuff
			makeGraphic(10,12,0xffaa1111);
			maxVelocity.x = 80;
			maxVelocity.y = 80;
			drag.x = maxVelocity.x * 4;
			drag.y = maxVelocity.y*4;
		}
	}
	
}