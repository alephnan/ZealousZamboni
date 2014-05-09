package 
{
	import org.flixel.FlxPoint;
	/**
	 * ...
	 * @author Kenny
	 */
	public class ZzUtils 
	{
		public static function dist(p:FlxPoint, a:FlxPoint) : Number{
			return Math.sqrt(Math.pow(p.x - a.x, 2) + Math.pow(p.y - a.y, 2));
		}
	}
	
}