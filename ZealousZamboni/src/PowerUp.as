package 
{
	import org.flixel.FlxSprite;
	
	/**
	 * ...
	 * @author Kenny
	 */
	public class PowerUp extends ZzUnit
	{
		[Embed(source = '../media/rocket.png')] 
		private static var boosterPNG:Class;
		
		/**
		 * Type for Speed boost power up
		 */
		public static const BOOSTER:* = "booster";
		
		//Amount that booster speeds up zamboni by
		public static const BOOSTER_SPEED_AMT:Number = 2;
		
		public static const BOOSTER_TIME_LENGTH:Number = 8;
		
		/**
		 * The type of this PowerUp
		 */
		public var type:*;
		
		public function PowerUp(x:Number = 0, y:Number = 0, type:* = BOOSTER) {
			super(x, y);
			this.type = type;
			this.width = LevelLoader.TILE_SIZE;
			this.height = LevelLoader.TILE_SIZE;
			loadGraphic(boosterPNG, false, true, 16, 16);
		}
	}
	
}