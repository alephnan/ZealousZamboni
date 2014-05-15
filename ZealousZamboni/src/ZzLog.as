package  
{
	import org.flixel.*;
	/**
	 * ...
	 * @author Dana Van Aken
	 */
	public final class ZzLog 
	{
		private static const GAME_NAME:String = "zealous_zamboni";
		private static const GAME_ID:int = 107;
		private static const SKEY:String = "1715d3eb78138f878ef005ea285f0087";
		private static const VID:int = 1;	// This should always be 1
		private static const CID:int = 1;   // This can change (acts like an actual version ID)
		
		private static const logger:Logger = new Logger(GAME_NAME, GAME_ID, SKEY, VID, CID);
		
		/******************************* Action IDs *******************************************/
		
		/////// Action Ids for StartState ////////
		
		// Tells us how long it took the user to figure out to use the mouse
		//  and the coordinates that they first clicked (logging test)
		public static const FIRST_MOUSE_CLICK:int = 1;
		
		
		
		public static function getLogger():Logger 
		{
			return logger;
		}
		
		public static function logLevelStart(data:Object = null):void 
		{
			logger.logLevelStart(FlxG.level, data);
		}
		
		public static function logLevelEnd(data:Object = null):void 
		{
			logger.logLevelEnd(data);
		}
		
	}

}