package
{
	import adobe.utils.CustomActions;
	import org.flixel.*;
	import org.as3commons.collections.ArrayList;
	import org.flixel.system.FlxTile;
	/**
	 * ...
	 * @author Kenny
	 * This is the actual in-game playing state that controls most of the game
	 * Other components can access it via the field FlxG.state when this is the current state
	 */
	public class PlayState extends FlxState
	{ 
		public static const DEBUG:Boolean = true;
		
		public static const ZAMBONI_INDEX:uint = 0;
		public static const SKATERS_INDEX:uint = 1;
		public static const POWERUPS_INDEX:uint = 2;
		public static const ZOMBIES_INDEX:uint = 3;
		
		private var levelLoader:LevelLoader;
   
		//Set of all blocks in the level
		public var level:FlxTilemap;
		
		//public var levelNum:uint = 1;
		
		//public var skatersFinished:Boolean = false;
		
		//Set of all sprites active in the level (including the player)
		public var activeSprites:Array;
		
		//The player sprite. This is ALSO contained in activeSprites but we maintain a handle here too
		public var player:Zamboni;
		
		public var hud:ZzHUD;
		
		private var startTxt:FlxText;
		
		public var playerPoints:PlayerPoints;
		
		public var pauseGroup:FlxGroup;
		
		private static const MOUSE_CURRENTLY_PRESSED:int = 0;
		private static const MOUSE_NOT_PRESSED:int = 1;
		private static const MOUSE_JUST_CLICKED:int = 2;
		
		//A hetrogenous array consisting of (Timestamp, Coordinate, Int) tuples
		private var mouseHistory:Array = new Array();
		
		private var mouseTimer:FlxTimer;
		
		//Track mouse every .25 seconds
		private static const MOUSE_LOG_INTERVAL:Number = .25;
		
		private var levelEnded : Boolean;
		
		//Minimum number of points player must achieve by time limit to win level
		//private var playerGoalPoints:uint = 50;
		
		//Time that the level lasts for
		private var levelTime:Number = 30;
		
		override public function create() : void {
			FlxG.bgColor = 0xffaaaaaa;
			levelLoader = new LevelLoader();
			activeSprites = new Array();
			
			levelLoader.loadLevel(FlxG.level);
			level = levelLoader.getTilemap();
			levelTime = levelLoader.levelTime;
			playerPoints = new PlayerPoints(14, levelLoader.goalPoints);
			add(level);
			player = levelLoader.getPlayer();
			activeSprites.push(player);
			add(player);
			startSprites(levelLoader.getSpriteQueues());
			hud = new ZzHUD(player, levelTime, playerPoints);
			add(hud);
			ZzLog.logLevelStart(levelLoader.levelQId);
			
			pauseGroup = new FlxGroup();
			add(pauseGroup);
			
			FlxG.mouse.show();
			//First element in mouseHistory is a header containing metadata
			mouseHistory.push( { "interval" : MOUSE_LOG_INTERVAL, "start" : new Date().time} );
			mouseTimer = new FlxTimer();
			mouseTimer.start(MOUSE_LOG_INTERVAL, 0, logMouse);
			
			levelEnded = false;
			
			
			onStart();
			
		}
		
		public function onStart():void {
			var images:Array = levelLoader.getPopupImages();
			var popup : LevelStartPopup;
			
			var version:int = ZzLog.ABversion();
			
			
			if ( version == 0) { // level goal popup + tip
				if (images.length != 2) {
					popup = new LevelStartPopup(Media.cleanIcePop, Media.tipStarConversionPNG);
				} else {
					popup = new LevelStartPopup(images[0], images[1]);
				}
			} else if (version == 1) { // just level goal popup
				if (images.length != 2) {
					popup = new LevelStartPopup(images[0]);
				} else {
					popup = new LevelStartPopup(images[0]);
				}
			} else { // version == 2
				// don't load any popups
			}
			
			pauseGroup.add(popup);
		}
		
		private function logMouse(t:FlxTimer) : void {
			var state:int;
			if (FlxG.mouse.justPressed()) {
				state = MOUSE_JUST_CLICKED;
			}else if (FlxG.mouse.pressed()) {
				state = MOUSE_CURRENTLY_PRESSED;
			}else {
				state = MOUSE_NOT_PRESSED;
			}
			mouseHistory.push( { "x":FlxG.mouse.screenX, "y":FlxG.mouse.screenY, "state" :state} );
		}
		
		private function startSprites(queues:Array):void {
			for (var i:uint = 0; i < queues.length; ++i) {
				activeSprites.push(queues[i]);
				SpriteQueue(queues[i]).startTimer();
				add(queues[i]);
			}
		}
		
		public function pause():void {
			if (!FlxG.paused) {
				FlxG.paused = true;
				ZzUtils.pause();
			}
		}
		
		public function unpause():void {
			if (FlxG.paused) {
				FlxG.paused = false;
				ZzUtils.unpause();
			}
		}
		
		/**
		 * Ends the level, checking for victory/loss conditions
		 */
		public function endLevel() : void {
			if (!levelEnded) {
				levelEnded = true;
				levelEnded = true;
			}else {
				return;
			}
			if (playerPoints.checkWin()) {
				winLevel();
			}else {
				loseLevel();
			}
		}
		
		
		/**
		 * Function invoked when the player wins the level
		 */
		private function winLevel() : void {
			mouseTimer.stop();
			ZzLog.logLevelEnd(false, mouseHistory, 0);
			if (FlxG.level + 1 > LevelLoader.NUM_LEVELS) {
				FlxG.switchState(new EndState());
			} else {
				//FlxG.switchState(new LevelWinState());
				
				// load level complete popup
				pauseGroup.add(new LevelCompletePopup());
			}
		}
		
		private function loseLevel():void {
			mouseTimer.stop();
			//TODO: Set final score
			ZzLog.logLevelEnd(true, mouseHistory, player.health);
			//FlxG.switchState(new LevelFailedState());
			pauseGroup.add(new LevelIncompletePopup());
		}
		
		public function restartLevel():void {
			mouseTimer.stop();
			ZzLog.logLevelEnd(true, mouseHistory, playerPoints.getBigStars());
			FlxG.resetState();
		}
		
		/**
		 * Function for adding a sprite to be displayed
		 * Probably needs to be modified to add sprites to appropriate collision groups later
		 * @param	o
		 */
		public function addDep(o:FlxBasic) : void {
			//problem: adds before tilemap
			add(o);
		}
		
		//This is the main function that causes stuff to actually happen in the game
		//It is called periodically by some higher power
		override public function update():void
		{
			if (!FlxG.paused) {
				super.update();
			
				cheatCode();
			
				// Collide all sprites with eachother and with the tilemap
				collideGroups();
			} else {
				pauseGroup.update();
			}
		}
		
		
		public function cheatCode() : void {
			if (FlxG.keys.Q && FlxG.keys.P) {
				winLevel();
			}
		}
		
		
		private function collideGroups():void {
			for (var i:uint = 0; i < activeSprites.length; ++i) {
				FlxG.collide(level, activeSprites[i], onCollision);
				for (var j:uint = 0; j < activeSprites.length; ++j) {
					FlxG.collide(activeSprites[i], activeSprites[j], onCollision);
				}
			}
		}
		
		//Callback function for when two sprites collide
		//The purpose of this function is to call a function on the objects in question
		//if they implement the right interface
		private function onCollision(a:FlxObject, b:FlxObject) : void {
			if (a is ICollidable) {
				ICollidable(a).onCollision(b);
			}
			if (b is ICollidable) {
				ICollidable(b).onCollision(a);
			}
		}
		
		private function getObjectTile(obj: FlxObject):FlxPoint {
			return new FlxPoint(obj.getMidpoint().x / LevelLoader.TILE_SIZE, obj.getMidpoint().y / LevelLoader.TILE_SIZE);
		}
		
		public function getNearestSkater(p:FlxPoint) : FlxPoint {
			var skaters:Array = SkaterQueue(activeSprites[SKATERS_INDEX]).members;
			var i:int;
			var minTile:FlxPoint = new FlxPoint(320,280);
			var minDist:Number = Number.MAX_VALUE;
			skaters.forEach(function(s:Skater, index:int, arr:Array): void {
				if (s == null || !s.exists) return;
				var t:FlxPoint = s.getMidpoint();
				if (ZzUtils.dist(p, t) < minDist) {
					minTile = t;
					minDist = ZzUtils.dist(p, t);
				}
			});
			return minTile;
		}
		
		override public function destroy():void {
			levelLoader.destroy();
			levelLoader = null;
			super.destroy();
			this.members = null;
			activeSprites = null;
			level = null;
			player = null;
			hud = null;
			startTxt = null;
			ZzUtils.destroy();
		}
	}
	
}