package  
{
	import org.flixel.*;
	/**
	 * ...
	 * @author Dana Van Aken
	 */
	public class PlayerPoints extends FlxGroup
	{
		public static const PLAYER_MAX_HEALTH:Number = 100;
		public static const CLEAR_TRAIL_REWARD:Number = 0.05;
		public static const PICKUP_POWERUP_REWARD:Number = 10;
		public static const SKATER_REWARD_PENALTY:Number = 60;
		
		/*public static function getRef():PlayerPoints {
			if (playerPoints != null) {
				return playerPoints;
			}
			return new PlayerPoints();
		}
		
		public static function destroyRef():void {
			playerPoints = null;
		}*/
		
		public function PlayerPoints(maxSize:uint=12) {
			super(maxSize);
			PlayState(FlxG.state).addDep(this);
		}
		
		public function generateRewardOrPenalty(location:FlxPoint, points:Number, penalty:Boolean):void {
			//trace("points = " + points + " x = " + location.x + " y = " + location.y);
			var pointStr:String;
			var size:uint;
			var color:uint; 
			var scale:FlxPoint;
			if (points > 1) {
				pointStr = "" + points;
				size = 60;
				scale = new FlxPoint(2, 2);
			} else {
				pointStr = "1";
				size = 10;
				scale = new FlxPoint(1, 1);
			}
			if (penalty) {
				pointStr = "-" + pointStr;
				color = 0xffdf013a;	// red
			} else {
				pointStr = "+" + pointStr;
				color = 0xff4ddc34;	// green
			}
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
		
	}

}