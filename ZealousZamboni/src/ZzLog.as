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
		
		// This can change (acts like an actual version ID)
		// generate either version A_CID, B_CID, or C_CID, randomly
		//private static const CID:int = (Math.floor(Math.random() * 999999) % 3) + 2;
		//private static const CID:int = 11;	//hardcoded to 2 since we didn't have time to put in proper a/b testing
		//private static const CID:int = (Math.floor(Math.random() * 3) + 2);  // old way to compute random number. but it seems to require RNG be 'warmed up'. not sure on this
		private static const CID:int = A_CID;// int(FlxG.random() * 100) % 2 + 23;
		private static const A_CID:int = 33;
		private static const B_CID:int = 34;
		private static const C_CID:int = -1;
		
		// a/b release on 5/27: 10
		// a/b release on 5/27: 11
		// a/b release on 5/28: 13
		// a/b release on 5/28: 14
		// a/b release on 6/4: 23
		// a/b release on 6/4: 24
		
		public static const PREGAME_QID:int = 31338;
		
		// CID = 1	5pm release on 5/16
		
		
		/* Release on Memoral Day 5/26
		 * 
		 * CID = 2 A/B testing: version with level goal popup + tips
		 * CID = 3 A/B testing: version with level goal popup (no tips) 
		 * CID = 4 A/B testing: version without level goal popup, nor tips
		*/
		/**
		 * If set to true, calls to log will not have any effect
		 */
		public static var DEBUG:Boolean = true;
		
		private static const logger:Logger = new Logger(GAME_NAME, GAME_ID, SKEY, VID, CID);
		
		/******************************* Action IDs *******************************************/

		// DONT CHANGE THESE WITHOUT A REALLY GOOD REASON
		
		// Tells us how long it took the user to figure out to use the mouse
		//  and the coordinates that they first clicked (logging test)
		public static const ACTION_FIRST_MOUSE_CLICK:int = 1;
		public static const ACTION_LOSE:int = 17;
		public static const ACTION_WIN:int = 13;
		public static const ACTION_SKATER_ENTER:int = 2;
		public static const ACTION_SKATER_EXIT:int = 3;
		public static const ACTION_SKATER_DIE:int = 4;
		public static const ACTION_SKATER_STUCK:int = 5;
		public static const ACTION_SKATER_UNSTUCK:int = 6;
		public static const ACTION_ZOMBIE_ENTER:int = 7;
		public static const ACTION_ZOMBIE_DIE:int = 8;
		public static const ACTION_SKATER_EATEN_BY_ZOMBIE:int = 9;
		public static const ACTION_ZOMBIE_LUNGE:int = 10;
		public static const ACTION_GAIN_POWER_UP:int = 11;
		public static const ACTION_RESTART_BUTTON_CLICKED:int = 12;
		public static const ACTION_WIN_GAME:int = 14;
		public static const ACTION_MOUSE_HISTORY:int = 15;
		public static const ACTION_POWER_UP_APPEAR:int = 16;
		public static const ACTION_UNIT_FALL:int = 18;
		public static const ACTION_SKIP_STARTPOPUP:int = 19;
		public static const ACTION_SKIP_STARTPOPUP_TIP:int = 20;
		public static const ACTION_SKIP_STARTINCOMPLETE:int = 21;
		public static const ACTION_SKIP_LEVELCOMPLETE:int = 22;
		public static const ACTION_QUIT_TO_MAIN_MENU:int = 23;
		
		public static function logAction(aid:int, data:Object = null):void {
			if (!DEBUG) {
				try {
					logger.logAction(aid, data);
				} catch (e:Error) {
					trace(e.message);
				}
			}
		}
		

		// return 0 to indicate A
		// return 1 to indicate  B
		// return 2 to indicate C
		// ... open for expansion to multiple versions
		public static function ABversion() : int {
			//trace(CID);
			if (CID == A_CID) {
				return 0;
			} else if (CID == B_CID) { 
				return 1;
			} else { // CID == C_CID
				return 2;
			}
			return 0;
		}
		
		
		public static function logLevelStart(qId:int, data:Object = null):void 
		{
			if (!DEBUG) {
				try {
					logger.logLevelStart(qId, data);
				} catch (e:Error) {
					trace(e.message);
				}
			}
		}
		
		public static function logLevelEnd(isLoss:Boolean,mouseHistory:Array, finalScore:Number):void 
		{	if (!DEBUG) {
				try {
					if (isLoss)
						logger.logAction(ACTION_LOSE, "lose");
					else
						logger.logAction(ACTION_WIN, "win");
					logger.logLevelEnd(new LevelHistory(isLoss, mouseHistory, finalScore));
				} catch (e:Error) {
					trace(e.message);
				}
			}
		}
		
	}

}
