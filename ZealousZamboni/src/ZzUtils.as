package 
{
	import org.flixel.*;
	/**
	 * ...
	 * @author Kenny
	 */
	public class ZzUtils 
	{
		
		private static var level:FlxTilemap;
		
		//The one and only place the starting level should be defined
		//This in general is 1, but can be set to others for debugging porpoises (they have a lot of bugs in them, I guess)
		public static var STARTING_LEVEL:uint = 10;
		
		private static var TIMERS:Array = new Array();
		
		/**
		 * Returns a point on a random entrance.
		 * @param	level
		 * @return
		 */
		public static function getRandomEntrance():FlxPoint {
			return FlxPoint(FlxU.getRandom(level.getTileCoords(LevelLoader.ENTRANCE_TILE_INDEX, false)));
		}
		
		/**
		 * Returns the nearest entrance to the given point
		 * @param	p the point to check near
		 * @return the coordinates of the upper-left corner of the entrance tile
		 */
		public static function getNearestEntrance(p:FlxPoint) : FlxPoint {
			var dist:Function = function(a:FlxPoint) : Number{
				return Math.sqrt(Math.pow(p.x - a.x, 2) + Math.pow(p.y - a.y, 2));
			}
			var tiles:Array = level.getTileCoords(LevelLoader.ENTRANCE_TILE_INDEX, false);
			var i:int;
			var minTile:FlxPoint = tiles[0];
			var minDist:Number = dist(minTile);
			tiles.forEach(function (t:FlxPoint, index:int, arr:Array) : void{
				if (dist(t) < minDist) {
					minTile = t;
					minDist = dist(t);
				}
			});
			return minTile;
		}
		
		public static function getAllEntrances() : Array {
				return level.getTileCoords(LevelLoader.ENTRANCE_TILE_INDEX, false);
		}
		
		public static function dist(p:FlxPoint, a:FlxPoint) : Number{
			return Math.sqrt(Math.pow(p.x - a.x, 2) + Math.pow(p.y - a.y, 2));
		}
		
		public static function setLevel(curlevel:FlxTilemap):void {
			level = curlevel;
		}
		
		// There should be 2 entrance tile blocks to make up each entrance
		public static function entranceBlocked(p:FlxPoint):Boolean {
			var entrance1:FlxPoint = new FlxPoint(p.x, p.y);
			entrance1.x /= LevelLoader.TILE_SIZE;
			entrance1.y /= LevelLoader.TILE_SIZE;
			var entrance2:FlxPoint;
			if (level.getTile(entrance1.x + 1, entrance1.y) == LevelLoader.ENTRANCE_TILE_INDEX) {
				entrance2 = new FlxPoint(entrance1.x + 1, entrance1.y);
			} else if (level.getTile(entrance1.x - 1, entrance1.y) == LevelLoader.ENTRANCE_TILE_INDEX) {
				entrance2 = new FlxPoint(entrance1.x - 1, entrance1.y);
			} else if (level.getTile(entrance1.x, entrance1.y + 1) == LevelLoader.ENTRANCE_TILE_INDEX) {
				entrance2 = new FlxPoint(entrance1.x, entrance1.y + 1);
			} else {
				entrance2 = new FlxPoint(entrance1.x, entrance1.y - 1);
			}
			return entranceTileNotBlocked(entrance1) || entranceTileNotBlocked(entrance2);
		}
		
		private static function entranceTileNotBlocked(entrance:FlxPoint): Boolean {
			return level.getTile(entrance.x + 1, entrance.y) < LevelLoader.ICE_TILE_INDEX_END ||
			       level.getTile(entrance.x - 1, entrance.y) < LevelLoader.ICE_TILE_INDEX_END ||
				   level.getTile(entrance.x, entrance.y + 1) < LevelLoader.ICE_TILE_INDEX_END ||
				   level.getTile(entrance.x, entrance.y - 1) < LevelLoader.ICE_TILE_INDEX_END;
		}
		
		public static function copyArray(orig:Array):Array {
			var copy:Array = new Array(orig.length);
			for (var i:uint = 0; i < orig.length; ++i) {
				copy[i] = orig[i];
			}
			return copy;
		}
		
		public static function registerTimer(timer:ZzTimer):void {
			TIMERS.push(timer);
		}
		
		public static function destroy():void {
			TIMERS.forEach(destroyTimers, null);
			TIMERS = new Array();
			level = null;
		}
		
		private static function destroyTimers(timer:ZzTimer, index:Number, arr:Array):void {
			timer = null;
		}
		
		public static function pause():void {
			TIMERS.forEach(pauseTimers, null);
		}
		
		private static function pauseTimers(timer:ZzTimer, index:Number, arr:Array):void {
			if (timer != null) {
				timer.paused = true;
			}
		}
		
		public static function unpause():void {
			TIMERS.forEach(unpauseTimers, null);
		}
		
		private static function unpauseTimers(timer:ZzTimer, index:Number, arr:Array):void {
			if (timer != null) {
				timer.paused = false;
			}
		}
	}
	
}