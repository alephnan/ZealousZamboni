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
		
		[Embed(source = "../res/level2_ruts.txt", mimeType = "application/octet-stream")] public var TestRuts:Class;
		
		//level specific assets
		[Embed(source = '../res/level1.txt', mimeType = "application/octet-stream")] public var Level1Csv:Class;
		[Embed(source = "../res/level1.xml", mimeType = "application/octet-stream")] public var Level1XML:Class;
		[Embed(source = '../res/level2.txt', mimeType = "application/octet-stream")] public var Level2Csv:Class;
		[Embed(source = "../res/level2.xml", mimeType = "application/octet-stream")] public var Level2XML:Class;
		[Embed(source = '../res/level3.txt', mimeType = "application/octet-stream")] public var Level3Csv:Class;
		[Embed(source = "../res/level3.xml", mimeType = "application/octet-stream")] public var Level3XML:Class;
		[Embed(source = '../res/level4.txt', mimeType = "application/octet-stream")] public var Level4Csv:Class;
		[Embed(source = "../res/level4.xml", mimeType = "application/octet-stream")] public var Level4XML:Class;
		[Embed(source = '../res/level5.txt', mimeType = "application/octet-stream")] public var Level5Csv:Class;
		[Embed(source = "../res/level5.xml", mimeType = "application/octet-stream")] public var Level5XML:Class;
		[Embed(source = '../res/level6.txt', mimeType = "application/octet-stream")] public var Level6Csv:Class;
		[Embed(source = "../res/level6.xml", mimeType = "application/octet-stream")] public var Level6XML:Class;
		//[Embed(source = '../res/level7.txt', mimeType = "application/octet-stream")] public var Level7Csv:Class;
		//[Embed(source = "../res/level7.xml", mimeType = "application/octet-stream")] public var Level7XML:Class;
		public static const NUM_LEVELS:uint = 6;
		
		private var level:FlxTilemap;
		
		//A copy of the unchanged level for the zamboni to use when reseting tiles
		//private var levelCopy:FlxTilemap;
		
		private var name:String;
		
		private var queues:Array;
		
		private var player:Zamboni;
		
		private var DEBUG:Boolean;
		
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
			ZzUtils.setLevel(level);
			queues = new Array();
			// parseXML MUST be called before addRutsToMap
			parseXML(this["Level" + level_num + "XML"]);
			if (level_num == 2)
				addRutsToMap(new TestRuts());
			
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
			if (DEBUG)
				trace("Number of player lives: " + lives);

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
				if (DEBUG)
					trace("skater x = " + skaterX + ", skater y = " + skaterY);
				if (resize) {
					skaterX *= resizeX;
					skaterY *= resizeY;
				}
				var skateTime:int = s.time;
				var startTime:int = s.start;
				if (DEBUG)
					trace("Skater time on ice: " + skateTime);
				skaters.addSpriteData(new SpriteData(skaterX, skaterY, startTime, skateTime));
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
		
	}
	
}