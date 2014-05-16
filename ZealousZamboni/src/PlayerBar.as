package  
{
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	/**
	 * ...
	 * @author Dana Van Aken
	 */
	public class PlayerBar extends FlxBar
	{
		private static const gradient:Array = new Array(0xfffe0101, 0xfffe8401, 0xfffefe01, 0xff27fe01, 0xff4d9540);
		private static const background:uint = 0xff0b0b61;
		private static const border:uint = 0xff848484;
		
		private var goalPoint:Point;
		private var goalData:BitmapData;
		
		public function PlayerBar(x:uint, y:uint, playerGoal:uint, player:Zamboni) 
		{
			super(x, y, FILL_LEFT_TO_RIGHT, 150, 30, player, "health", 0, PlayerPoints.PLAYER_MAX_HEALTH, true);
			
			goalPoint = new Point(barWidth / PlayerPoints.PLAYER_MAX_HEALTH * playerGoal + 1, 1);
			goalData = new BitmapData(2, barHeight, true, border);
			createGradientBar(new Array(background, background), gradient, 1, 0, true, border);
		}
		
		override public function update():void {
			super.update();
			canvas.copyPixels(goalData, new Rectangle(0, 0, 2, barHeight), goalPoint);
		    pixels = canvas;
		}
	}

}