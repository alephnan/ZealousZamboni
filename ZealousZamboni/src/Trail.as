package
{
	import org.flixel.FlxGroup;
	import org.flixel.FlxSprite;
	import org.flixel.FlxTileblock;
	import org.flixel.*;
	
	/**
	 * ...
	 * @author Kenny
	 * 
	 * Trails left behind by skaters. These are supposed to be solid to skaters, but disappear when a zamboni runs over them
	 */
	public class Trail extends FlxGroup
	{
		public function addTile(X:Number, Y:Number) : void {
			add(new TrailTile(X, Y));
		}
		
		override public function update() : void {
			super.update();
			for each(var m:FlxBasic in members) {
				if (!m.exists) {
					remove(m);
				}
			}
		}
	}
	
}