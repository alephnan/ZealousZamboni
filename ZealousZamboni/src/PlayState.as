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
		
		public var finishedSkaters:uint = 0;
		
		//Set of all sprites active in the level (including the player)
		public var activeSprites:Array;
		
		//The player sprite. This is ALSO contained in activeSprites but we maintain a handle here too
		public var player:Zamboni;
		
		private var hud:ZzHUD;
		
		private var startTxt:FlxText;
		
		//public function PlayState(levelNum:uint = 1) {
		/*public function PlayState() {
			super();
			levelLoader = new LevelLoader();
			this.levelNum = levelNum;
		}*/
		
		override public function create() : void {
			FlxG.bgColor = 0xffaaaaaa;
			levelLoader = new LevelLoader();
			activeSprites = new Array();
			levelLoader.loadLevel(FlxG.level);
			level = levelLoader.getTilemap();
			add(level);
			
			player = levelLoader.getPlayer();
			activeSprites.push(player);
			add(player);
			startSprites(levelLoader.getSpriteQueues());
			hud = new ZzHUD(player, this);
			add(hud);
			FlxG.mouse.show();
			
			/*if (FlxG.level == 1) {
				startTxt = new FlxText(FlxG.width / 2 + 25, FlxG.height / 2 - 200, FlxG.width, "Don't let skaters\n     get stuck!");
				startTxt.size = 30;
				startTxt.scale = new FlxPoint(2, 2);
				startTxt.color = 0x0101DF;
				startTxt.shadow = 0xA4A4A4;
				startTxt.alpha = 1;
				var timer:FlxTimer = new FlxTimer();
				add(startTxt);
				timer.start(.5, 7, onStart);
			}*/
		}
		
		/*public function onStart(timer:FlxTimer):void {
			
			if (timer.finished) {
				startTxt.kill();
			} else {
				if (timer.loopsLeft % 2 == 0) {
					startTxt.alpha = 0;
				} else {
					startTxt.alpha = 1;
				}
			}
		}*/
		
		private function startSprites(queues:Array):void {
			for (var i:uint = 0; i < queues.length; ++i) {
				activeSprites.push(queues[i]);
				SpriteQueue(queues[i]).startTimer();
				add(queues[i]);
			}
		}
		
		/**
		 * Function called when a skater successfully comes back
		 * @param	s
		 */
		public function skaterComplete(s:Skater, killed:Boolean = false) : void {
			if (killed) {
				player.hurt(1);
				if (player.alive == false) {
					FlxG.switchState(new LevelFailedState());
					return;
				}
			}
			if (SkaterQueue(activeSprites[SKATERS_INDEX]).skatersFinished()) {
				if (FlxG.level + 1 > LevelLoader.NUM_LEVELS) {
					winGame();
				} else {
					winLevel();
				}
			}
		}
		
		/**
		 * Function invoked when the player wins the level
		 */
		public function winLevel() : void {
			FlxG.switchState(new LevelWinState());
		}
		
		/**
		 * Function invoked when the player wins the level and
		 * there are no more levels (they win the game)
		 */
		public function winGame() : void {
			FlxG.switchState(new EndState());
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
			super.update();
			
			// Collide all sprites with eachother and with the tilemap
			collideGroups();
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
		}
	}
	
}