package
{
	import cgs.CgsApi;
	import cgs.server.logging.GameServerData;
	import cgs.server.logging.CGSServerProps;
	import cgs.server.logging.actions.QuestAction;
	import cgs.user.CgsUserProperties;
	import cgs.user.ICgsUser;
	
	import com.adobe.crypto.MD5;
	
	public class Logger
	{
		private var api:CgsApi;
		private var cgsUser:ICgsUser;
		private var lastQid:int = -1;
		private var levelStartTime:Number;
		
		/**
		 * Initializes the logger for a new user. Pass in the gameName, gameId, skey,
		 * versionId, and categoryId for this version of your game. The gameName, gameId,
		 * and skey can be found at /projects/instr/14sp/cse481d/<your_game_name>/logging.txt. 
		 * The versionId should always be 1, and the categoryId will change for each new
		 * release that you make to a game portal. When a new cgsUser is created, this will
		 * automatically log a new pageload with information such as their OS, language 
		 * settings, etc.
		 */
		public function Logger(gameName:String, gameId:int, skey:String, versionId:int, categoryId:int) {
			
			if (gameId <= 0 || gameName == null || skey == null || versionId <=0 || categoryId <=0) {
				throw new ArgumentError("invalid game info");
			}
			
			var skeyHash:int = GameServerData.UUID_SKEY_HASH;
			var serverTag:String = CGSServerProps.DEVELOPMENT_SERVER;			
			var userProps:CgsUserProperties = new CgsUserProperties(skey, skeyHash, gameName, gameId, versionId, categoryId, serverTag);			
			var cgsApi:CgsApi = new CgsApi();
			cgsUser = cgsApi.initializeUser(userProps);
		}
		
		/**
		 * Logs the start of a level with the given level qid. You should guarantee each level 
		 * in you game has a distict qid, or you won't be able to tell which actions belong to
		 * which level. The data object passed in as a parameter can be an arbitrary AS object, 
		 * which will be converted to JSON and stored with the log. A dqid will be automatically 
		 * generated for this trace (playthrough of the level). Call logLevelEnd at the end of the
		 * level to end the trace. Note that even if the player closes the browser during a level,
		 * your level start and actions will still be logged.
		 */
		public function logLevelStart(qid:int, data:Object):void {
			if (qid <= 0) throw new ArgumentError("qid must be positive");
			
			lastQid = qid;
			levelStartTime = new Date().time;
			var questHash:String = MD5.hash("level_data");			
			cgsUser.logQuestStart(qid, questHash, data);			
		}
		
		/**
		 * Logs an action of the given action type aid. The action will be associated with the 
		 * current trace, so make sure to call logLevelStart before logging actions. The data 
		 * object passed in as a parameter can be an arbitrary AS object, which will be converted 
		 * to JSON and stored with the log.
		 */
		public function logAction(aid:int, data:Object):void {
			if (aid <= 0) throw new ArgumentError("aid must be positive");
			
			var actionTime:Number = new Date().time - levelStartTime;			
			var action:QuestAction = new QuestAction(aid, actionTime);
			action.setDetail(data);
			cgsUser.logQuestAction(action);
		}
		
		/**
		 * Logs the end of a level, which ends the trace. You must have first called logLevelStart.
		 * The data object passed in as a parameter can be an arbitrary AS object, which will be 
		 * converted to JSON and stored with the log.
		 */
		public function logLevelEnd(data:Object):void {
			if (lastQid == -1) throw new ArgumentError("no active level");
			
			lastQid = -1;
			cgsUser.logQuestEnd(data);
		}
		
		
		

	}
}