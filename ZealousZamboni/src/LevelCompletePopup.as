package  
{
	import org.flixel.*;
	/**
	 * ...
	 * @author Dana Van Aken
	 */
	public class LevelCompletePopup extends FlxGroup
	{
		private static var starStart:FlxPoint = new FlxPoint(FlxG.width - FlxG.width / 4 - 10, 5);
		private static var starEnd:FlxPoint = new FlxPoint(FlxG.width / 2 + 60, FlxG.height / 2 + 20);
		private var popGraphic:FlxSprite;
		private var starPath:FlxPath;
		private var goalTxt:FlxText;
		private var starShots:uint;
		private var starGoal:uint;
		private var star:FlxSprite;
		private var timer:FlxTimer;
		
		public function LevelCompletePopup() 
		{
			super();
			
			// popup
			popGraphic = new FlxSprite(0, 0, Media.levelCompletePNG);
			popGraphic.x = FlxG.width / 2 - popGraphic.width / 2;
			popGraphic.y = FlxG.height / 2 - popGraphic.height / 2;
			
			// text
			starShots = 0;
			goalTxt = new FlxText(FlxG.width / 2 + 80, FlxG.height / 2 + 8, 70, "x " + starShots, true);
			goalTxt.setFormat("coolvetica", 40, 0x000000, "center");
			
			// initial path
			starGoal = PlayState(FlxG.state).playerPoints.getBigStarGoal();
			starStart.x -= starGoal * 50;
			starPath = new FlxPath();
			starPath.addPoint(starStart, true);
			starPath.addPoint(starEnd, true);
			
			// shooting star
			star = new FlxSprite(starStart.x, starStart.y, Media.bigStarPng);
			star.followPath(starPath, 400);
			starPath.drawDebug(FlxG.camera);
			timer = new FlxTimer().start(3, starGoal + 1, onTimer);
			
			add(popGraphic);
			add(goalTxt);
			add(star);
			
			PlayState(FlxG.state).pause();
		}
		
		override public function update():void {
			if (star.pixelsOverlapPoint(starEnd)) {
				star.stopFollowingPath(false);
				if (starShots < starGoal) {
					starShots++;
					goalTxt.text = "x " + starShots;
					if (starShots == starGoal) {
						star.exists = false;
						new FlxTimer().start(2, 1, onTimer);
					} else {
						starStart.x += 50;
						star.x = starStart.x;
						star.y = starStart.y;
						star.exists = true;
						star.followPath(starPath, 400);
					}
				}
			}
			
			// player wants to skip screen, stop timer, and immediately go to next level
			if (FlxG.keys.justPressed("ENTER")) {
				timer.stop();
				kill();
				PlayState(FlxG.state).unpause();
				FlxG.level++;
				FlxG.switchState(new PlayState());
			}
			
			super.update();
		}
		
		private function onTimer(timer:FlxTimer):void {
			kill();
			PlayState(FlxG.state).unpause();
			FlxG.level++;
			FlxG.switchState(new PlayState());
		}
		
	}

}