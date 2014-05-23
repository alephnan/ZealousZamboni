package  
{
	import org.flixel.*;
	/**
	 * ...
	 * @author Dana Van Aken
	 */
	public class PlayerPoints extends FlxGroup
	{
		public static const CLEAR_TRAIL_REWARD:uint = 1;
		public static const PICKUP_POWERUP_REWARD:uint = 10;
		public static const STAR_CONVERSION:uint = 550;
		public static const KILL_ZOMBIE_REWARD:uint = 20;
		private var playerBigStarGoal:uint;
		private var numSmallStars:uint;
		private var numBigStars:uint;
		
		public function PlayerPoints(maxSize:uint=12, playerBigStarGoal:uint=1) {
			super(maxSize);
			numSmallStars = 0;
			numBigStars = 0;
			this.playerBigStarGoal = playerBigStarGoal;
			trace(playerBigStarGoal);
			PlayState(FlxG.state).addDep(this);
		}
		
		public function generateReward(location:FlxPoint, points:Number, bigStar:Boolean):void {
			//trace("points = " + points + " x = " + location.x + " y = " + location.y);
			if (bigStar)
				numBigStars++;
			else
				numSmallStars += points;
			var pointStr:String = "+" + points;
			var size:uint = 14;
			var color:uint = 0xff4ddc34;
			var scale:FlxPoint = new FlxPoint(1, 1);
			var txt:PointText = recycle() as PointText;
			if (txt == null) {
				txt = new PointText(location.x, location.y, pointStr, size, color, scale);
				add(txt);
			}else{
				txt.resetText(location.x, location.y, pointStr, size, color, scale);
				txt.visible = true;
				txt.exists = true;
			}
		}
		
		override public function update():void {
			super.update();
			if (numSmallStars >= STAR_CONVERSION) {
				numBigStars += numSmallStars / STAR_CONVERSION;
				numSmallStars %= STAR_CONVERSION;
			}
		}
		
		public function getBigStars():uint {
			return numBigStars;
		}
		
		public function getSmallStars():uint {
			return numSmallStars;
		}
		
		public function getBigStarGoal():uint {
			return playerBigStarGoal;
		}
		
		public function checkWin():Boolean {
			if (numBigStars >= playerBigStarGoal)
				return true;
			return false;
		}
		
	}

}