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
		//public static const ICE_TILE_INDEX_END:uint = 1024; //non-inclusive
		public static const ICE_TILE_INDEX_END:uint = 768; //non-inclusive
		//public static const ENTRANCE_TILE_INDEX:uint = 1052;	// Skater entrance
		public static const ENTRANCE_TILE_INDEX:uint = 1103;	// Skater entrance
		//public static const DOWN_ARROW_BLOCK:uint = 1024;		// Arrow block -- DOWN
		public static const DOWN_ARROW_BLOCK:uint = 768;		// Arrow block -- DOWN
		//public static const UP_ARROW_BLOCK:uint = 1025;		// Arrow block -- UP
		public static const UP_ARROW_BLOCK:uint = 769;		// Arrow block -- UP
		//public static const LEFT_ARROW_BLOCK:uint = 1026;		// Arrow block -- LEFT
		public static const LEFT_ARROW_BLOCK:uint = 770;		// Arrow block -- LEFT
		//public static const RIGHT_ARROW_BLOCK:uint = 1027;		// Arrow block -- RIGHT
		public static const RIGHT_ARROW_BLOCK:uint = 771;		// Arrow block -- RIGHT
		//public static const SOLID_BLOCK:uint = 1053;
		public static const SOLID_BLOCK:uint = 1104;
		//public static const WALL_INDEX:uint = 1054;
		//public static const WALL_INDEX:uint = 512;
		//public static const TRAIL_TILE_INDEX:uint = 1078; // starting index of first trail color, that skater leaves
		public static const TRAIL_TILE_INDEX:uint = 1094; // starting index of first trail color, that skater leaves
		//public static const NUM_COLORS:uint = 10; // number of different trail colors
		public static const NUM_COLORS:uint = 8; // number of different trail tiles
		//public static const PIT_INDEX:uint = 1028;
		public static const PIT_INDEX:uint = 1102;
		
		// Index range for north / south walls (including corners) (inclusive)
		//public static const NORTH_WALL_LOW:uint = 1089;
		public static const NORTH_WALL_LOW:uint = 896;
		//public static const NORTH_WALL_HIGH:uint = 1100;
		//public static const NORTH_WALL_HIGH:uint = 639;
		//public static const SOUTH_WALL_LOW :uint = 1057;
		//public static const SOUTH_WALL_LOW :uint = 640;
		//public static const SOUTH_WALL_HIGH	:uint = 1068;
		public static const SOUTH_WALL_HIGH:uint = 1087;
		
		// East and west walls only have 2 pieces each
		//public static const	WEST_WALL_A:uint = 1103;
		public static const WALL_TILE_WIDTH:uint = 3;
		public static const WALL_TILE_HEIGHT:uint = 8;
		public static const	WEST_WALL_START:uint = 1088;
		//public static const WEST_WALL_B:uint = 1103 + 32;
		//public static const EAST_WALL_A:uint = 1106;
		public static const EAST_WALL_START:uint = 1091;
		//public static const EAST_WALL_B:uint = 1106 + 32;
		
		//public static const NUM_TILES:uint = 1184;
		public static const NUM_TILES:uint = 3072;
		public static const TILESHEET_TILE_WIDTH:uint = 32;
		
		public static const DEFAULT_GOAL_POINTS:uint = 1;
	
		public static const DEFAULT_LEVEL_TIME:Number = 30;
		//level specific assets
		
		// music player
		public static const SOUND_PLAYER:SoundPlayer = new SoundPlayer();
		
		// start popup stuff
		public static const tips:Array = new Array("tipStarConversionPng", "tipHowToWinPNG", "tipCollectMinistarsPNG", 
				"tipResetButtonPNG", "tipControlWasdPNG", "tipSkaterBarPNG", "tipSkatersTurnLeftPNG", "tipSkatersTrappedExplodePNG",
				"tipSkatersTightAreasPNG", "tipRedirectSkatersPNG", "tipZombiesMinistarsPNG", "tipKillZombiesPNG");
				
		private static const TUTORIAL_TIPS_INDEX:uint = 3;
		private static const BEGINNER_TIPS_INDEX:uint = 10;
		private static const INTERMEDIATE_TIPS_INDEX:uint = 12;
		
		
		
		public const Level1QId:uint = 301;
		[Embed(source = '../res/level301.txt', mimeType = "application/octet-stream")] public const Level1Csv:Class;
		//[Embed(source = '../res/test.txt', mimeType = "application/octet-stream")] public const Level1Csv:Class;
		[Embed(source = "../res/level206.xml", mimeType = "application/octet-stream")] public const Level1XML:Class;
		[Embed(source = "../res/level301_ruts.txt", mimeType = "application/octet-stream")] public const Level1Ruts:Class; 
		
		public const Level1BQId:uint = 256;
		[Embed(source = '../res/level256.txt', mimeType = "application/octet-stream")] public const Level1BCsv:Class;
		[Embed(source = "../res/level256.xml", mimeType = "application/octet-stream")] public const Level1BXML:Class;
		[Embed(source = "../res/level256_ruts.txt", mimeType = "application/octet-stream")] public const Level1BRuts:Class; 
	
		public const Level2QId:uint = 302;
		[Embed(source = '../res/level302.txt', mimeType = "application/octet-stream")] public var Level2Csv:Class;
		[Embed(source = "../res/level302.xml", mimeType = "application/octet-stream")] public var Level2XML:Class;
		//[Embed(source = "../res/level208_ruts.txt", mimeType = "application/octet-stream")] public var Level2Ruts:Class; 
		
		public const Level2BQId:uint = 257;
		[Embed(source = '../res/level257.txt', mimeType = "application/octet-stream")] public var Level2BCsv:Class;
		[Embed(source = "../res/level257.xml", mimeType = "application/octet-stream")] public var Level2BXML:Class;
		[Embed(source = "../res/level257_ruts.txt", mimeType = "application/octet-stream")] public var Level2BRuts:Class; 
		
		public const Level3QId:uint = 303;
		[Embed(source = '../res/level303.txt', mimeType = "application/octet-stream")] public var Level3Csv:Class;
		[Embed(source = "../res/level303.xml", mimeType = "application/octet-stream")] public var Level3XML:Class;
		//[Embed(source = "../res/level209_ruts.txt", mimeType = "application/octet-stream")] public var Level3Ruts:Class; 
		
		public const Level3BQId:uint = 258;
		[Embed(source = '../res/level258.txt', mimeType = "application/octet-stream")] public var Level3BCsv:Class;
		[Embed(source = "../res/level258.xml", mimeType = "application/octet-stream")] public var Level3BXML:Class;
		[Embed(source = "../res/level258_ruts.txt", mimeType = "application/octet-stream")] public var Level3BRuts:Class; 
		
		
		/**/
		public const Level4QId:uint = 101;
		[Embed(source = '../res/level101.txt', mimeType = "application/octet-stream")] public var Level4Csv:Class;
		[Embed(source = "../res/level101.xml", mimeType = "application/octet-stream")] public var Level4XML:Class;
		
		public const Level4BQId:uint = 251;
		[Embed(source = '../res/level251.txt', mimeType = "application/octet-stream")] public var Level4BCsv:Class;
		[Embed(source = "../res/level251.xml", mimeType = "application/octet-stream")] public var Level4BXML:Class;
		
		public const Level5QId:uint = 102;
		[Embed(source = '../res/level102.txt', mimeType = "application/octet-stream")] public var Level5Csv:Class;
		[Embed(source = "../res/level102.xml", mimeType = "application/octet-stream")] public var Level5XML:Class;
		
		public const Level5BQId:uint = 252;
		[Embed(source = '../res/level252.txt', mimeType = "application/octet-stream")] public var Level5BCsv:Class;
		[Embed(source = "../res/level252.xml", mimeType = "application/octet-stream")] public var Level5BXML:Class;
		
		public const Level6QId:uint = 211;
		[Embed(source = '../res/level211.txt', mimeType = "application/octet-stream")] public var Level6Csv:Class;
		[Embed(source = "../res/level211.xml", mimeType = "application/octet-stream")] public var Level6XML:Class;
		[Embed(source = "../res/level211_ruts.txt", mimeType = "application/octet-stream")] public var Level6Ruts:Class; 
		
		public const Level6BQId:uint = 253;
		[Embed(source = '../res/level253.txt', mimeType = "application/octet-stream")] public var Level6BCsv:Class;
		[Embed(source = "../res/level253.xml", mimeType = "application/octet-stream")] public var Level6BXML:Class;
		[Embed(source = "../res/level253_ruts.txt", mimeType = "application/octet-stream")] public var Level6BRuts:Class; 
		
		public const Level7QId:uint = 104;
		[Embed(source = '../res/level104.txt', mimeType = "application/octet-stream")] public var Level7Csv:Class;
		[Embed(source = "../res/level104.xml", mimeType = "application/octet-stream")] public var Level7XML:Class;
		
		//Same as original level 7 since it was so hard
		public const Level7BQId:uint = 104;
		[Embed(source = '../res/level104.txt', mimeType = "application/octet-stream")] public var Level7BCsv:Class;
		[Embed(source = "../res/level104.xml", mimeType = "application/octet-stream")] public var Level7BXML:Class;
		
		public const Level8QId:uint = 105;
		[Embed(source = '../res/level105.txt', mimeType = "application/octet-stream")] public var Level8Csv:Class;
		[Embed(source = "../res/level105.xml", mimeType = "application/octet-stream")] public var Level8XML:Class;
		
		public const Level8BQId:uint = 254;
		[Embed(source = '../res/level254.txt', mimeType = "application/octet-stream")] public var Level8BCsv:Class;
		[Embed(source = "../res/level254.xml", mimeType = "application/octet-stream")] public var Level8BXML:Class;
		
		public const Level9QId:uint = 212;
		[Embed(source = '../res/level212.txt', mimeType = "application/octet-stream")] public var Level9Csv:Class;
		[Embed(source = "../res/level212.xml", mimeType = "application/octet-stream")] public var Level9XML:Class;
		
		//Same as original level 9
		public const Level9BQId:uint = 212;
		[Embed(source = '../res/level212.txt', mimeType = "application/octet-stream")] public var Level9BCsv:Class;
		[Embed(source = "../res/level212.xml", mimeType = "application/octet-stream")] public var Level9BXML:Class;
		
		public const Level10QId:uint = 213;
		[Embed(source = '../res/level213.txt', mimeType = "application/octet-stream")] public var Level10Csv:Class;
		[Embed(source = "../res/level213.xml", mimeType = "application/octet-stream")] public var Level10XML:Class;
		
		//same as original level 10
		public const Level10BQId:uint = 213;
		[Embed(source = '../res/level213.txt', mimeType = "application/octet-stream")] public var Level10BCsv:Class;
		[Embed(source = "../res/level213.xml", mimeType = "application/octet-stream")] public var Level10BXML:Class;
		
		public const Level11QId:uint = 214;
		[Embed(source = '../res/level214.txt', mimeType = "application/octet-stream")] public var Level11Csv:Class;
		[Embed(source = "../res/level214.xml", mimeType = "application/octet-stream")] public var Level11XML:Class;
		
		public const Level11BQId:uint = 214;
		[Embed(source = '../res/level214.txt', mimeType = "application/octet-stream")] public var Level11BCsv:Class;
		[Embed(source = "../res/level214.xml", mimeType = "application/octet-stream")] public var Level11BXML:Class;
		
		public const Level12QId:uint = 215;
		[Embed(source = '../res/level215.txt', mimeType = "application/octet-stream")] public var Level12Csv:Class;
		[Embed(source = "../res/level215.xml", mimeType = "application/octet-stream")] public var Level12XML:Class;
		
		public const Level12BQId:uint = 215;
		[Embed(source = '../res/level215.txt', mimeType = "application/octet-stream")] public var Level12BCsv:Class;
		[Embed(source = "../res/level215.xml", mimeType = "application/octet-stream")] public var Level12BXML:Class;
		
		public const Level13QId:uint = 216;
		[Embed(source = '../res/level216.txt', mimeType = "application/octet-stream")] public var Level13Csv:Class;
		[Embed(source = "../res/level216.xml", mimeType = "application/octet-stream")] public var Level13XML:Class;
		
		public const Level13BQId:uint = 216;
		[Embed(source = '../res/level216.txt', mimeType = "application/octet-stream")] public var Level13BCsv:Class;
		[Embed(source = "../res/level216.xml", mimeType = "application/octet-stream")] public var Level13BXML:Class;
		
		public const Level14QId:uint = 220;
		[Embed(source = '../res/level220.txt', mimeType = "application/octet-stream")] public var Level14Csv:Class;
		[Embed(source = "../res/level220.xml", mimeType = "application/octet-stream")] public var Level14XML:Class;
		
		public const Level14BQId:uint = 260;
		[Embed(source = '../res/level260.txt', mimeType = "application/octet-stream")] public var Level14BCsv:Class;
		[Embed(source = "../res/level260.xml", mimeType = "application/octet-stream")] public var Level14BXML:Class;
		
		public const Level15QId:uint = 217;
		[Embed(source = '../res/level217.txt', mimeType = "application/octet-stream")] public var Level15Csv:Class;
		[Embed(source = "../res/level217.xml", mimeType = "application/octet-stream")] public var Level15XML:Class;
		[Embed(source = "../res/level217_ruts.txt", mimeType = "application/octet-stream")] public var Level15Ruts:Class;
		
		public const Level15BQId:uint = 217;
		[Embed(source = '../res/level217.txt', mimeType = "application/octet-stream")] public var Level15BCsv:Class;
		[Embed(source = "../res/level217.xml", mimeType = "application/octet-stream")] public var Level15BXML:Class;
		[Embed(source = "../res/level217_ruts.txt", mimeType = "application/octet-stream")] public var Level15BRuts:Class;
		
		public const Level16QId:uint = 218;
		[Embed(source = '../res/level218.txt', mimeType = "application/octet-stream")] public var Level16Csv:Class;
		[Embed(source = "../res/level218.xml", mimeType = "application/octet-stream")] public var Level16XML:Class;
		
		public const Level16BQId:uint = 218;
		[Embed(source = '../res/level218.txt', mimeType = "application/octet-stream")] public var Level16BCsv:Class;
		[Embed(source = "../res/level218.xml", mimeType = "application/octet-stream")] public var Level16BXML:Class;
		
		public const Level17QId:uint = 219;
		[Embed(source = '../res/level219.txt', mimeType = "application/octet-stream")] public var Level17Csv:Class;
		[Embed(source = "../res/level219.xml", mimeType = "application/octet-stream")] public var Level17XML:Class;
		
		public const Level17BQId:uint = 219;
		[Embed(source = '../res/level219.txt', mimeType = "application/octet-stream")] public var Level17BCsv:Class;
		[Embed(source = "../res/level219.xml", mimeType = "application/octet-stream")] public var Level17BXML:Class;
		
		public const Level18QId:uint = 221;
		[Embed(source = '../res/level221.txt', mimeType = "application/octet-stream")] public var Level18Csv:Class;
		[Embed(source = "../res/level221.xml", mimeType = "application/octet-stream")] public var Level18XML:Class;
		
		public const Level18BQId:uint = 221;
		[Embed(source = '../res/level221.txt', mimeType = "application/octet-stream")] public var Level18BCsv:Class;
		[Embed(source = "../res/level221.xml", mimeType = "application/octet-stream")] public var Level18BXML:Class;
		
		public static const NUM_LEVELS:uint = 18;
		
		private var level:FlxTilemap;
		
		//A copy of the unchanged level for the zamboni to use when reseting tiles
		//private var levelCopy:FlxTilemap;
		
		private var name:String;
		
		private var queues:Array;
		
		private var player:Zamboni;
		
		private var popupImages:Array;
		
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
			var abtestSym:String = "";
			if (ZzLog.ABversion() == 1) {
				//if we're version B, load B levels instead
				abtestSym = "B";
			}
			level.loadMap(new this["Level" + level_num + abtestSym + "Csv"](), Media.TileSheet, TILE_SIZE, TILE_SIZE, FlxTilemap.OFF, 0, 0, 6);
			levelQId = this["Level" + level_num + abtestSym + "QId"];
			ZzUtils.setLevel(level);
			queues = new Array();
			// parseXML MUST be called before addRutsToMap
			parseXML(this["Level" + level_num + abtestSym + "XML"]);
			var rutNm:String = "Level" + level_num + abtestSym + "Ruts";
			if(rutNm in this)
				addRutsToMap(new this[rutNm]());
			
			level.setTileProperties(ICE_TILE_INDEX, 0, null, null, ICE_TILE_INDEX_END);
			
			//level.setTileProperties(1054, FlxObject.ANY, null, null);
			//levelCopy = new FlxTilemap();
			//levelCopy.loadMap(new this["Level" + level_num + "Csv"](), TileSheet, TILE_SIZE, TILE_SIZE, FlxTilemap.OFF, 0, 0, 6);
			//levelCopy.setTileProperties(ICE_TILE_INDEX, 0, null, null, 1053);
			//Set entrances as non-collidable
			level.setTileProperties(ENTRANCE_TILE_INDEX, 0);
			/*trace("East:");
			isVerticalWall(EAST_WALL_START, 0);
			trace("West:");
			isVerticalWall(WEST_WALL_START, 0);*/
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
		
		public function getPopupImages():Array {
			return popupImages;
		}
		
		
		public static function isSolid(tileIndex:uint) : Boolean {
			/*if (isWall(tileIndex))
				return true;
			if (tileIndex >= SOLID_BLOCK && tileIndex <  SOUTH_WALL_LOW)
				return true;*/
			if (tileIndex >= NORTH_WALL_LOW)
				return true;
				
			return false;
			
		};
		
		// return true if the given tileIndex is a wall, false otherwise
		public static function isWall(tileIndex:uint) : Boolean {
			/*if ( tileIndex >= NORTH_WALL_LOW && tileIndex <= NORTH_WALL_HIGH)
				return true;
			if ( tileIndex >= SOUTH_WALL_LOW && tileIndex <= SOUTH_WALL_HIGH)
				return true;
			if (tileIndex == EAST_WALL_A || tileIndex == EAST_WALL_B)
				return true;
			if (tileIndex == WEST_WALL_A || tileIndex == WEST_WALL_B)
				return true;
			return false;*/
			if (tileIndex >= NORTH_WALL_LOW && tileIndex <= SOUTH_WALL_HIGH)
				return true;
			return isVerticalWall(EAST_WALL_START, tileIndex) || isVerticalWall(WEST_WALL_START, tileIndex);
		}
		
		private static function isVerticalWall(wallTileStart:uint, tileIndex:uint):Boolean {
			var checkTile:uint = wallTileStart;
			for (var i:uint = 0; i < WALL_TILE_HEIGHT; ++i) {
				checkTile = wallTileStart + i * 32;
				for (var j:uint = 0; j < WALL_TILE_WIDTH; ++j) {
					//trace("\t" + (checkTile + j));
					if (checkTile + j == tileIndex)
						return true;
				}
			}
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
			
			// Popup stuff
			var popupStr:String = xml.popup.@mainImg;
			var tipType:String = xml.popup.@tip;
			var popupImg:Class = null;
			if (popupStr != null)
				popupImg = Media[popupStr];
				
			var tipIndex:String = null;
			if (tipType == null)
				tipIndex = getTip(BEGINNER_TIPS_INDEX);
			else
				tipIndex = getTip(LevelLoader[tipType]);
			popupImages = new Array(popupImg, Media[tipIndex]);
		}
		
		public static function getTip(tipTypeIndex:uint):String {
			return tips[uint(FlxG.random() * 100) % tipTypeIndex];
		}
		
		public function destroy():void {
			level = null;
			player = null;
			queues = null;
		}
		
	}
	
}