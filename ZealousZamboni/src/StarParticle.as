package  
{
	import org.flixel.*;
	/**
	 * ...
	 * @author Dana Van Aken
	 */
	public class StarParticle extends FlxParticle
	{
		
		public function StarParticle() {
			super();
			loadGraphic(Media.babyStarPng);
			exists = false;
		}
		
		override public function onEmit():void {
			super.onEmit();
			
			var path:FlxPath = new FlxPath();
			path.addPoint(getMidpoint());
			path.addPoint(ZzHUD.smallStarXY);
			followPath(path, 400);
		}
		
		override public function update():void {
			alpha -= .03;
			super.update();
			if (overlapsPoint(ZzHUD.smallStarXY)) {
				exists = false;
			}
		}
		
		override public function reset(X:Number, Y:Number):void {
			super.reset(X, Y);
			alpha = 1;
		}
	}

}