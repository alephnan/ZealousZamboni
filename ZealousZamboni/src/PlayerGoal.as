package  
{
	import org.flixel.*;
	/**
	 * ...
	 * @author Dana Van Aken
	 */
	public class PlayerGoal extends FlxGroup
	{
		private static const GOLD:uint = 0xffffcc00;
		private static const GRAY:uint = 0xffa0a0a0;
		private static const BLUE:uint = 0xff0000ff;
		
		private var playerPoints:PlayerPoints;
		private var goalStars:Array;
		private var numFilledBigStars:uint;
		private var subGoalStar:FlxSprite;
		private var subGoalText:FlxText;
		
		public function PlayerGoal(X:uint, Y:uint, playerPoints:PlayerPoints) 
		{
			super();
			this.playerPoints = playerPoints;
			numFilledBigStars = 0;
			var bigStarGoal:uint = playerPoints.getBigStarGoal();
			goalStars = new Array();
			trace(bigStarGoal);
			for (var i:uint = 0; i < bigStarGoal; ++i) {
				var goalStar:FlxSprite = new FlxSprite(X + (i + 1) * 20, Y);
				goalStar.loadGraphic(Media.bigStarOutlinePng);
				add(goalStar);
				goalStars.push(goalStar);
			}
			subGoalStar = new FlxSprite(X - 60, Y + 10);
			subGoalStar.loadGraphic(Media.smallStarPng);
			add(subGoalStar);
			subGoalText = new FlxText(X - 10, Y, 50, "0", false);
			subGoalText.size = 12;
			add(subGoalText);
		}
		
		override public function update():void {
			super.update();
			// reset small star text
			subGoalText.text = String(playerPoints.getSmallStars());
			var numBigStars:uint = playerPoints.getBigStars();
			//trace("numBigStars = " + numBigStars + ", filled big stars = " + numFilledBigStars);
			// redraw any new gold stars
			while (numFilledBigStars < numBigStars) {
				var sprite:FlxSprite = FlxSprite(goalStars[numFilledBigStars]);
				sprite.loadGraphic(Media.bigStarPng);
				numFilledBigStars++;
			}
			
			// check to see if player has won yet
			//if (playerPoints.checkWin()) {
				//PlayState(FlxG.state).endLevel();
			//}
		}
		
		
		
	}
}