package 
{
	import org.flixel.*;
	import flash.utils.getQualifiedClassName;
	/**
	 * ...
	 * @author Kenny
	 */
	public class TrailTile extends FlxTileblock implements ICollidable {
		public function TrailTile(X:Number, Y:Number) {
			super(X-4, Y-4, 8, 8);
			//place holder stuff
			makeGraphic(8,8,0xff002177);
			maxVelocity.x = 0;
			maxVelocity.y = 0;
		}
		
		public function onCollision(other:FlxObject) : void {
			if (other is Zamboni) {
				this.kill();
			}
		}
		
		
	}
}