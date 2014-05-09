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
		
		private var levelLoader:LevelLoader;

		//Set of all blocks in the level
		public var level:FlxTilemap;
		
		public var levelNum:uint = 1;
		
		public var finishedSkaters:uint = 0;
		
		public var queues:Array;
		
		//Set of all sprites active in the level (including the player)
		//TODO Decide if we should just add sprites directly to this?
		public var activeSprites:FlxGroup;
		
		//The player sprite. This is ALSO contained in activeSprites but we maintain a handle here too
		private var player:Zamboni;
		
		private var hud:ZzHUD;
		
		public function PlayState(levelNum:uint=2) {
			levelLoader = new LevelLoader();
			this.levelNum = levelNum;
		}
		
		override public function create() : void {
			FlxG.bgColor = 0xffaaaaaa;
			activeSprites = new FlxGroup();
			levelLoader.loadLevel(levelNum);
			level = levelLoader.getTilemap();
			add(level);
			
			activeSprites.add(levelLoader.getPlayer());
			add(activeSprites);
			player = levelLoader.getPlayer();
			queues = levelLoader.getSpriteQueues();
			hud = new ZzHUD(player, this);
			add(hud);
			
			startQueues();
			FlxG.mouse.show();
		}
		
		private function startQueues():void {
			for (var i:uint = 0; i < queues.length; ++i) {
				SpriteQueue(queues[i]).startTimer();
			}
		}
		
		public function addUnit(s:ZzUnit):void {
			addActiveUnit(s);
			s.postConstruct(addDep);
		}
		
		/**
		 * Function called when a skater successfully comes back
		 * @param	s
		 */
		public function skaterComplete(s:Skater, killed:Boolean = false) : void {
			if (killed) {
				player.hurt(1);
				if (player.alive == false) {
					FlxG.switchState(new LevelFailedState(this));
					return;
				}
			}
			
			finishedSkaters++;
			if (finishedSkaters == SkaterQueue(
					queues[LevelLoader.SKATER_QUEUE_INDEX]).getInitialNumSkaters()) {
				winLevel();
			}
		}
		
		/**
		 * Function invoked when the player wins the level
		 */
		public function winLevel() : void {
			FlxG.switchState(new LevelWinState(this));
		}
		/**
		 * Function for adding a sprite to be displayed
		 * Probably needs to be modified to add sprites to appropriate collision groups later
		 * @param	o
		 */
		private function addDep(o:FlxBasic) : void {
			//problem: adds before tilemap
			add(o);
		}
		
		//Adds a unit to the active set of sprites
		//This is provided as a convenience for any sprites that have "sub sprites" such as skaters that have trails
		public function addActiveUnit(u:FlxBasic) : void {
			activeSprites.add(u);
		}
		
		//This is the main function that causes stuff to actually happen in the game
		//It is called periodically by some higher power
		override public function update():void
		{
			super.update();
			var mouse:FlxPoint = FlxG.mouse.getWorldPosition(); //mouse coordinates
			
			var z:FlxPoint = player.getMidpoint();	//player coordinates
			var n:Number = 5;	//tolerance in pixels
			//Logic for causing player fo follow mouse
			if(FlxG.mouse.pressed()){
				if (mouse.x < z.x - n) {
					player.velocity.x = -player.maxVelocity.x;
				}else if (mouse.x - n > z.x) {
					player.velocity.x = player.maxVelocity.x;
				}else {
					player.velocity.x = 0;
				}
				if (mouse.y < z.y - n) {
					player.velocity.y = -player.maxVelocity.y;
				}else if (mouse.y - n > z.y) {
					player.velocity.y = player.maxVelocity.y;
				}else {
					player.velocity.y = 0;
				}
			}else {
				player.velocity.x = 0;
				player.velocity.y = 0;
			}
			//Collide all sprites with the level tiles
			FlxG.collide(level, activeSprites, onCollision);
			//Collide all sprites with each other
			FlxG.collide(activeSprites, activeSprites, onCollision);
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
		
		override public function destroy() : void {
			super.destroy();
			this.members = null;
			levelLoader = null;
			player = null;
		}
		
		public function getNearestSkater(p:FlxPoint) : FlxPoint {
			var skaters:Array = activeSprites.members;
			var i:int;
			var minTile:FlxPoint = new FlxPoint(320,280);
			var minDist:Number = Number.MAX_VALUE;
			skaters.forEach(function (o:FlxObject, index:int, arr:Array) : void {
				if (Skater == null || !(o is Skater) || !o.exists) return;
				var t:FlxPoint = o.getMidpoint();
				if (ZzUtils.dist(p, t) < minDist) {
					minTile = t;
					minDist = ZzUtils.dist(p, t);
				}
			});
			return minTile;
		}
	}
	
}