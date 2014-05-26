package  
{
	import org.flixel.*;
	/**
	 * ...
	 * @author Dana Van Aken
	 */
	public class BigStar extends FlxSprite
	{
		private static const SCALAR:Number = 0.02;
		private var starPath:FlxPath;
		private var end:FlxPoint;
		private var origWidth:uint;
		private var origHeight:uint;
		
		public function BigStar(X:uint=0, Y:uint=0) 
		{
			super();
			exists = false;
			loadGraphic(Media.bigStarOrigPng);
			origWidth = width;
			origHeight = height;
			elasticity = 1;
		}
		
		override public function update():void {
			if (path == null) {
				scale.x -= SCALAR;
				scale.y -= SCALAR;
				if (scale.x <= 0.2) {
					scale.x = 0.2;
					scale.y = 0.2;
				}
				width = origWidth * (1 - SCALAR);
				height = origHeight * (1 - SCALAR);
				centerOffsets();
				x = FlxG.width / 2 - width / 2;
				y = FlxG.height / 2 - height / 2;
			}
			
			super.update();
		}
		
		override public function postUpdate():void {
			if (FlxG.paused)
				return;
			super.postUpdate();
			if (overlapsPoint(end)) {
				stopFollowingPath(true);
				path = null;
				exists = false;
				PlayState(FlxG.state).hud.fillStar();
			}
		}
		
		public function animate(numBigStars:uint=0):void {
			end = new FlxPoint(ZzHUD.bigStarXY.x + numBigStars * 50, ZzHUD.bigStarXY.y);
			
			exists = true;
			visible = true;
			new ZzTimer().start(1, 1, onTimer);
		}
		
		private function onTimer(timer:ZzTimer):void {
			timer = null;
			starPath = new FlxPath()
			starPath.addPoint(getMidpoint());
			starPath.addPoint(end, true);
			followPath(starPath, 800);
		}
		
	}

}