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
		
		// Tile index of ice tiles
		public static const ICE_TILE_INDEX:uint = 0;
		
		//Tile index of entrance tiles
		public static const ENTRANCE_TILE_INDEX:uint = 3;
		
		// Tile index of trail tiles
		public static const TRAIL_TILE_INDEX:uint = 4;
		
		//Embed level assets-- this should probably be moved to another file later
		[Embed(source = "../res/tiles_new.png")] public var TileSheet:Class;
		[Embed(source = '../res/level0.txt', mimeType = "application/octet-stream")] public var Level1Csv:Class;
		[Embed(source = "../res/level_0.xml", mimeType = "application/octet-stream")] public var Level1XML:Class;
		[Embed(source = "../res/xml_test.xml", mimeType = "application/octet-stream")] public var XmlTest:Class;
		
		private var level:FlxTilemap;
		
		private var name:String;
		
		private var skaters:FlxGroup;
		
		private var player:Zamboni;
		
		private var DEBUG:Boolean;
		
		private var fAddUnitDelayed:Function;
		
		/**
		 * Loads the specified level into memory
		 * @param	level_name the name of the level to load. This should be the prefix name used for both the level XML
		 * 			as well as the csv
		 * @param fAddUnitDelayed a function for adding units to the PlayState after a certain number of seconds
		 * 			The function format should be the following: addUnitDelayed(z:ZzUnit, time:Number)
		 */
		public function loadLevel(level_name:String, fAddUnitDelayed:Function, debugEnabled:Boolean=false) : void {
			this.fAddUnitDelayed = fAddUnitDelayed;
			level = new FlxTilemap();
			level.loadMap(new Level1Csv(), TileSheet, TILE_SIZE, TILE_SIZE, FlxTilemap.OFF, 0, 0, 1);
			//Set entrances as non-collidable
			level.setTileProperties(ENTRANCE_TILE_INDEX, 0);
			skaters = new FlxGroup();
			name = level_name;
			parseXML();
		}
		
		public function getPlayer() : Zamboni {
			return player;
		}
		
		//TODO: Figure out what type this should return
		public function getSkaters() : FlxGroup {
			return skaters;
		}
		
		//TODO: Figure out what type this should return
		public function getZombies() : FlxGroup {
			return new FlxGroup();
		}
		
		public function getTilemap() : FlxTilemap {
			return level;
		}
		
		//Helper function for parsing xml data associated with a level
		private function parseXML():void {
			var xml:XML = new XML(new Level1XML());
			
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
			player = new Zamboni(zamboniX, zamboniY);
			//addUnit(player);
			
			// Skaters: coordinates and time
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
				var skater:Skater = new Skater(skaterX, skaterY, skateTime);
				skaters.add(skater);
				fAddUnitDelayed(skater, startTime);
			}
			
			// Powerups: coordinates, time, and type
			for each (var p:XML in xml.powerup) {
				var powerupX:int = p.@x;
				var powerupY:int = p.@y;
				if (DEBUG)
					trace("powerup x = " + powerupX + ", powerup y = " + powerupY);
				if (resize) {
					powerupX *= resizeX;
					powerupY *= resizeY;
				}
				var powerupTime:int = p.time;
				if (DEBUG)
					trace("Powerup time on ice: " + powerupTime);
					
				var powerupType:String = p.type;
				if (DEBUG)
					trace("Powerup type: " + powerupType);
			}
			
			// Zombies: coordinates
			for each (var z:XML in xml.zombie) {
				var zombieX:int = z.@x;
				var zombieY:int = z.@y;
				if (DEBUG)
					trace("zombie x = " + zombieX + ", zombie y = " + zombieY);
				if (resize) {
					zombieX *= resizeX;
					zombieY *= resizeY;
				}
			}
			
		}
		
	}
	
}