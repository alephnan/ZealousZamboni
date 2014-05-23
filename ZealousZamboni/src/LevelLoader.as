package 
{
	import org.flixel.FlxGroup;
	import org.flixel.FlxTilemap;
	import org.flixel.*;
	
	/**
	 * ...
	 * This class contains all the necessary functions for loading a level
	 * Once a level is loaded, various pieces of info about the level can be accessed through
	 * accessors
	 */
	public class LevelLoader 
	{
		//Size of tiles in pixels
		public static const TILE_SIZE:int = 8;
		
		/* TILE INDICES */
		public static const ICE_TILE_INDEX:uint = 0;
		public static const ICE_TILE_INDEX_END:uint = 1024; //non-inclusive
		public static const ENTRANCE_TILE_INDEX:uint = 1052;	// Skater entrance
		public static const DOWN_ARROW_BLOCK:uint = 1024;		// Arrow block -- DOWN
		public static const UP_ARROW_BLOCK:uint = 1025;		// Arrow block -- UP
		public static const LEFT_ARROW_BLOCK:uint = 1026;		// Arrow block -- LEFT
		public static const RIGHT_ARROW_BLOCK:uint = 1027;		// Arrow block -- RIGHT
		public static const SOLID_BLOCK:uint = 1053;
		public static const WALL_INDEX:uint = 1054;
		public static const TRAIL_TILE_INDEX:uint = 1078; // starting index of first trail color, that skater leaves
		public static const NUM_COLORS:uint = 10; // number of different trail colors
		
		// Index range for north / south walls (including corners) (inclusive)
		public static const NORTH_WALL_LOW:uint = 1089;
		public static const NORTH_WALL_HIGH:uint = 1100;
		public static const SOUTH_WALL_LOW :uint = 1057;
		public static const SOUTH_WALL_HIGH	:uint = 1068;
		// East and west walls only have 2 pieces each
		public static const	WEST_WALL_A:uint = 1103;
		public static const WEST_WALL_B:uint = 1103 + 32;
		public static const EAST_WALL_A:uint = 1106;
		public static const EAST_WALL_B:uint = 1106 + 32;
		
		public static const NUM_TILES:uint = 1184;
		
		public static const DEFAULT_GOAL_POINTS:uint = 1;
	
		public static const DEFAULT_LEVEL_TIME:Number = 30;
		//level specific assets
		
		// music player
		public static const SOUND_PLAYER:SoundPlayer = new SoundPlayer();
		
		
		// Tuan's Level testing
		/*public const Level1QId:uint = 1;
		[Embed(source = '../res/tuanlevels/one.txt', mimeType = "application/octet-stream")] public const Level1Csv:Class;
		[Embed(source = "../res/tuanlevels/one.xml", mimeType = "application/octet-stream")] public const Level1XML:Class;
		
		public const Level2QId:uint = 2;
		[Embed(source = '../res/tuanlevels/two.txt', mimeType = "application/octet-stream")] public const Level2Csv:Class;
		[Embed(source = "../res/tuanlevels/two.xml", mimeType = "application/octet-stream")] public const Level2XML:Class;
		
		public const Level1QId:uint = 1;
		[Embed(source = '../res/tuanlevels/three.txt', mimeType = "application/octet-stream")] public const Level1Csv:Class;
		[Embed(source = "../res/tuanlevels/three.xml", mimeType = "application/octet-stream")] public const Level1XML:Class; */

		
<<<<<<< HEAD
		public const Level1QId:uint = 206;
		[Embed(source = '../res/level206.txt', mimeType = "application/octet-stream")] public const Level1Csv:Class;
		[Embed(source = "../res/level206.xml", mimeType = "application/octet-stream")] public const Level1XML:Class;
		[Embed(source = "../res/level206_ruts.txt", mimeType = "application/octet-stream")] public const Level1Ruts:Class; 
	
		public const Level2QId:uint = 207;
		[Embed(source = '../res/level207.txt', mimeType = "application/octet-stream")] public var Level2Csv:Class;
		[Embed(source = "../res/level207.xml", mimeType = "application/octet-stream")] public var Level2XML:Class;
		[Embed(source = "../res/level207_ruts.txt", mimeType = "application/octet-stream")] public var Level2Ruts:Class; 
		
		public const Level3QId:uint = 208;
		[Embed(source = '../res/level208.txt', mimeType = "application/octet-stream")] public var Level3Csv:Class;
		[Embed(source = "../res/level208.xml", mimeType = "application/octet-stream")] public var Level3XML:Class;
		[Embed(source = "../res/level208_ruts.txt", mimeType = "application/octet-stream")] public var Level3Ruts:Class; 
		
		/**/
		public const Level4QId:uint = 209;
		[Embed(source = '../res/level209.txt', mimeType = "application/octet-stream")] public var Level4Csv:Class;
		[Embed(source = "../res/level209.xml", mimeType = "application/octet-stream")] public var Level4XML:Class;
		[Embed(source = "../res/level209_ruts.txt", mimeType = "application/octet-stream")] public var Level4Ruts:Class; 
		
		public const Level5QId:uint = 101;
		[Embed(source = '../res/level101.txt', mimeType = "application/octet-stream")] public var Level5Csv:Class;
		[Embed(source = "../res/level101.xml", mimeType = "application/octet-stream")] public var Level5XML:Class;
		
		public const Level6QId:uint = 102;
		[Embed(source = '../res/level102.txt', mimeType = "application/octet-stream")] public var Level6Csv:Class;
		[Embed(source = "../res/level102.xml", mimeType = "application/octet-stream")] public var Level6XML:Class;
		
		public const Level7QId:uint = 211;
		[Embed(source = '../res/level211.txt', mimeType = "application/octet-stream")] public var Level7Csv:Class;
		[Embed(source = "../res/level211.xml", mimeType = "application/octet-stream")] public var Level7XML:Class;
		[Embed(source = "../res/level211_ruts.txt", mimeType = "application/octet-stream")] public var Level7Ruts:Class; 
		
		public const Level8QId:uint = 203;
		[Embed(source = '../res/level203.txt', mimeType = "application/octet-stream")] public var Level8Csv:Class;
		[Embed(source = "../res/level203.xml", mimeType = "application/octet-stream")] public var Level8XML:Class;
		
		public const Level9QId:uint = 204;
		[Embed(source = '../res/level204.txt', mimeType = "application/octet-stream")] public var Level9Csv:Class;
		[Embed(source = "../res/level204.xml", mimeType = "application/octet-stream")] public var Level9XML:Class;
		
		public const Level10QId:uint = 205;
		[Embed(source = '../res/level205.txt', mimeType = "application/octet-stream")] public var Level10Csv:Class;
		[Embed(source = "../res/level205.xml", mimeType = "application/octet-stream")] public var Level10XML:Class;
		
		public static const NUM_LEVELS:uint = 10;
		
		private var level:FlxTilemap;
		
		//A copy of the unchanged level for the zamboni to use when reseting tiles
		//private var levelCopy:FlxTilemap;
		
		private var name:String;
		
		private var queues:Array;
		
		private var player:Zamboni;
		
		private var DEBUG:Boolean;
		
		public var goalPoints:uint;
		/**
		 * The qId for the current level.
		 */
		public var levelQId:uint;
		
		public var levelTime:Number;
		
		public function LevelLoader(debugEnabled:Boolean = false) {
			this.DEBUG = debugEnabled;
		}
		
		/**
		 * Loads the specified level into memory
		 * @param	level_num the level number to load
		 * @param fAddUnitDelayed a function for adding units to the PlayState after a certain number of seconds
		 * 			The function format should be the following: addUnitDelayed(z:ZzUnit, time:Number)
		 */
		public function loadLevel(level_num:uint) : void {
			level = new FlxTilemap();
			level.loadMap(new this["Level" + level_num + "Csv"](), Media.TileSheet, TILE_SIZE, TILE_SIZE, FlxTilemap.OFF, 0, 0, 6);
			levelQId = this["Level" + level_num + "QId"];
			ZzUtils.setLevel(level);
			queues = new Array();
			// parseXML MUST be called before addRutsToMap
			parseXML(this["Level" + level_num + "XML"]);
			var rutNm:String = "Level" + level_num + "Ruts";
			if(rutNm in this)
				addRutsToMap(new this[rutNm]());
			
			level.setTileProperties(ICE_TILE_INDEX, 0, null, null, 1053);
			
			level.setTileProperties(1054, FlxObject.ANY, null, null);
			//levelCopy = new FlxTilemap();
			//levelCopy.loadMap(new this["Level" + level_num + "Csv"](), TileSheet, TILE_SIZE, TILE_SIZE, FlxTilemap.OFF, 0, 0, 6);
			//levelCopy.setTileProperties(ICE_TILE_INDEX, 0, null, null, 1053);
			//Set entrances as non-collidable
			level.setTileProperties(ENTRANCE_TILE_INDEX, 0);
			
			
		}
		
		public function getPlayer() : Zamboni {
			return player;
		}
		
		public function getTilemap() : FlxTilemap {
			return level;
		}
		
		public function getSpriteQueues():Array {
			return queues;
		}
		
		
		public static function isSolid(tileIndex:uint) : Boolean {
			if (isWall(tileIndex))
				return true;
			if (tileIndex >= SOLID_BLOCK && ICE_TILE_INDEX < + SOUTH_WALL_LOW)
				return true;
				
			return false;
			
		};
		
		// return true if the given tileIndex is a wall, false otherwise
		public static function isWall(tileIndex:uint) : Boolean {
			if ( tileIndex >= NORTH_WALL_LOW && tileIndex <= NORTH_WALL_HIGH)
				return true;
			if ( tileIndex >= SOUTH_WALL_LOW && tileIndex <= SOUTH_WALL_HIGH)
				return true;
			if (tileIndex == EAST_WALL_A || tileIndex == EAST_WALL_B)
				return true;
			if (tileIndex == WEST_WALL_A || tileIndex == WEST_WALL_B)
				return true;
			return false;
		}
		
		// returns true if the given tileIndex is a trail, false otherwise
		public static function isTrail(tileIndex:uint) : Boolean {
			return ((tileIndex >= LevelLoader.TRAIL_TILE_INDEX) &&
				(tileIndex < LevelLoader.TRAIL_TILE_INDEX + LevelLoader.NUM_COLORS));
		}
		
		public function addRutsToMap(csv:String):void {
			var columns:Array;
			var rows:Array = csv.split("\n");
			level.heightInTiles = rows.length;
			var data:Array = new Array();
			var row:uint = 0;
			var column:uint;
			while(row < level.heightInTiles)
			{
				columns = rows[row++].split(",");
				if(columns.length <= 1)
				{
					level.heightInTiles = level.heightInTiles - 1;
					continue;
				}
				if(level.widthInTiles == 0)
					level.widthInTiles = columns.length;
				column = 0;
				while(column < level.widthInTiles)
					data.push(uint(columns[column++]));
			}
			for (var i:uint = 0; i < data.length; ++i) {
				if (data[i] != 0) {
					level.setTileByIndex(i, data[i], true);
				}
			}
		}
		
		
		
		//Helper function for parsing xml data associated with a level
		private function parseXML(clazz:Class):void {
			var xml:XML = new XML(new clazz());
			// Get assumed framewidth and frameheight
			var assumedWidth:int = parseInt(xml.@width);
			var assumedHeight:int = parseInt(xml.@height);
			
			levelTime = parseInt(xml.@time);
			if (levelTime < 1 || isNaN(levelTime)) levelTime = DEFAULT_LEVEL_TIME;
			if (DEBUG)
				trace("assumed framewidth = " + assumedWidth + ", assumed frameheight = " + assumedHeight);
			
			// If actual w/h != assumed, "resize" level
			var resize:Boolean = (assumedWidth != FlxG.width) || (assumedHeight != FlxG.height);
			var resizeX:Number = 1;
			var resizeY:Number = 1;
			if (resize) {
				resizeX = Number(FlxG.width) / Number(assumedWidth);
				resizeY = Number(FlxG.height) / Number(assumedHeight);
			}
			
			// Player lives
			var lives:int = parseInt(xml.@lives, 10);
			if (isNaN(lives) || lives == 0) lives = 1;
			if (DEBUG)
				trace("Number of player lives: " + lives);
				
			goalPoints = parseInt(xml.@goal);
			if (goalPoints == 0) goalPoints = DEFAULT_GOAL_POINTS;

			// Zamboni starting coordinates
			var zamboniX:int = parseInt(xml.zamboni.@x);
			var zamboniY:int = parseInt(xml.zamboni.@y);
			if (DEBUG)
				trace("zamboni x = " + zamboniX + ", zamboni y = " + zamboniY);
			if (resize) {
				zamboniX *= resizeX;
				zamboniY *= resizeY;
			}
			player = new Zamboni(zamboniX, zamboniY, level);
			//addUnit(player);
			
			player.health = lives;
			// Skaters: coordinates, start time, skate time
			var skaters:SkaterQueue = new SkaterQueue();
			for each (var s:XML in xml.skater) {
				var skaterX:int = s.@x;
				var skaterY:int = s.@y;
				var skaterTX:int = s.@toX;
				var skaterTY:int = s.@toY;
				if (DEBUG)
					trace("skater x = " + skaterX + ", skater y = " + skaterY);
				if (resize) {
					skaterX *= resizeX;
					skaterY *= resizeY;
				}
				var skateTime:int = s.time;
				var startTime:int = s.start;
				var startDir:String = "DOWN";
				if (s.@dir) {
					startDir = s.@dir;
				}
				if (DEBUG)
					trace("Skater time on ice: " + skateTime);
				skaters.addSpriteData(new SpriteData(skaterX, skaterY, startTime, skateTime, null, skaterTX, skaterTY, startDir));
			}
			queues.push(skaters);
			
			// Powerups: coordinates, time, and type
			var powerups:PowerupQueue = new PowerupQueue();
			for each (var p:XML in xml.powerup) {
				var powerupX:int = p.@x;
				var powerupY:int = p.@y;
				if (DEBUG)
					trace("powerup x = " + powerupX + ", powerup y = " + powerupY);
				if (resize) {
					powerupX *= resizeX;
					powerupY *= resizeY;
				}	
				var powerupType:String = p.type;
				startTime = p.start;
				if (DEBUG) {
					trace("power up start = " + startTime);
					trace("Powerup type: " + powerupType);
				}
				powerups.addSpriteData(new SpriteData(powerupX, powerupY, startTime, 0, powerupType));
			}
			queues.push(powerups);
			
			// Zombies: coordinates
			// TODO: add start time 
			var zombies:WalkingDeadQueue = new WalkingDeadQueue();
			for each (var z:XML in xml.zombie) {
				var zombieX:int = z.@x;
				var zombieY:int = z.@y;
				if (DEBUG)
					trace("zombie x = " + zombieX + ", zombie y = " + zombieY);
				if (resize) {
					zombieX *= resizeX;
					zombieY *= resizeY;
				}
				zombies.addSpriteData(new SpriteData(zombieX, zombieY, int(z.start)));
			}
			queues.push(zombies);
		}
		
		public function destroy():void {
			level = null;
			player = null;
			queues = null;
		}
		
	}
	
}