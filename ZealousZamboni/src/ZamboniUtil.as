package  
{
	import org.flixel.*;
	/**
	 * ...
	 * @author Dana Van Aken
	 */
	public class ZamboniUtil 
	{
		private static var level:FlxTilemap;
		
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
		
		public static function setLevel(curlevel:FlxTilemap):void {
			level = curlevel;
		}
		
	}

}