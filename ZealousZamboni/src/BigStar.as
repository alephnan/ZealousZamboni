package  
{
	import org.flixel.*;
	/**
	 * ...
	 * @author Dana Van Aken
	 */
	public class BigStar extends FlxSprite
	{
		private static const SCALAR:Number = 0.999;
		
		public function BigStar(X:uint=0, Y:uint=0) 
		{
			super();
			exists = false;
			loadGraphic(Media.bigStarPng);
			elasticity = 1;
		}
		
		override public function update():void {
			/*scale.x *= SCALAR;
			scale.y *= SCALAR;
			width *= SCALAR;
			height *= SCALAR;
			centerOffsets();*/
			
			super.update();
		}
		
		override public function postUpdate():void {
			if (FlxG.paused)
				return;
			super.postUpdate();
			if (overlapsPoint(ZzHUD.bigStarXY)) {
				stopFollowingPath(false);
				exists = false;
				PlayState(FlxG.state).hud.fillStar();
			}
		}
		
	}

}