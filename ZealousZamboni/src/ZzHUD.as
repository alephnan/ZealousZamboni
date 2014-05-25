package 
{
	import org.flixel.FlxGroup;
	import org.flixel.*;
	
	/**
	 * ...
	 * @author Kenny
	 * A container class for stuff related to the in-game heads up display
	 * Suggested usage is add it to your top level state
	 */
	public class ZzHUD extends FlxGroup 
	{
		
		public static var smallStarXY:FlxPoint = new FlxPoint(0, 0);
		public static var bigStarXY:FlxPoint = new FlxPoint(0, 0);
		
		private var restartButton:FlxButton;
		private var muteButton:FlxButton;
		
		private var player:Zamboni;
		private var timerTxt:FlxText;
		private var timer:FlxTimer;
		
		private var playerPoints:PlayerPoints;
		private var goalStars:Array;
		private var goalText:FlxText;
		private var numFilledBigStars:uint;
		private var subGoalStar:FlxSprite;
		private var subGoalText:FlxText;
		
		
		/**
		 * @param   player 		a reference to the player of the game
		 * @param   levelTime	the length of the level in seconds
		 */
		public function ZzHUD(player:Zamboni, levelTime:uint, playerPoints:PlayerPoints) {
			super();
			this.player = player;
			this.playerPoints = playerPoints;
			add(playerPoints);
			numFilledBigStars = 0;

			// restart button
			restartButton = new FlxButton(FlxG.width - FlxG.width / 4 + 90, 30, null, onRestart);
			restartButton.loadGraphic(Media.restartPNG);
			add(restartButton);
			
			// mute button
			muteButton = new FlxButton(FlxG.width - FlxG.width / 4 + 90, 80, null, toggleMute);
			muteButton.loadGraphic(Media.mutePng);
			add(muteButton);
			
			// big star text ("0/1")
			var bigStarGoal:uint = playerPoints.getBigStarGoal();
			trace("goal = " + bigStarGoal);
			/*goalText = new FlxText(restartButton.x - 70, 22, 40, "0/" + bigStarGoal, false);
			goalText.size = 12;
			goalText.scale = new FlxPoint(2, 2);
			add(goalText);*/
			
			// big stars
			goalStars = new Array();
			for (var i:uint = 0; i < bigStarGoal; ++i) {
				var goalStar:FlxSprite = new FlxSprite(restartButton.x - (i+1)*50 - 100, 5);
				goalStar.loadGraphic(Media.bigStarOutlinePng);
				add(goalStar);
				goalStars.push(goalStar);
			}
			var lastStar:FlxPoint = FlxSprite(goalStars[goalStars.length - 1]).getMidpoint();
			bigStarXY.x = lastStar.x;
			bigStarXY.y = lastStar.y;
			subGoalText = new FlxText(FlxSprite(goalStars[goalStars.length - 1]).x - 100, 12, 70, "0", true);
			subGoalText.setFormat("coolvetica", 40, 0xffffff);
			add(subGoalText);
			
			// small star
			subGoalStar = new FlxSprite(subGoalText.x - 50, 5);
			subGoalStar.loadGraphic(Media.smallStarIconPng);
			smallStarXY.x = subGoalStar.getMidpoint().x;
			smallStarXY.y = subGoalStar.getMidpoint().y;
			add(subGoalStar);
			
			
			// level timer
			timerTxt = new FlxText(40, 10, 100, getTimeString(levelTime), true);
			timerTxt.setFormat("coolvetica", 50, 0xffffff);
			add(timerTxt);
			timer = new FlxTimer();
			timer.start(levelTime, 1, endLevel);
		}
		
		
		public function toggleMute() : void {
			var s : SoundPlayer = LevelLoader.SOUND_PLAYER;
			if (s.isMute()) {
				s.unmute();
				muteButton.loadGraphic(Media.mutePng);
			} else {
				muteButton.loadGraphic(Media.unmutePng);
				s.mute();
			}
		}
		
		override public function update() : void {
			// reset small star text
			subGoalText.text = String(playerPoints.getSmallStars());
			timerTxt.text = getTimeString(timer.timeLeft);
			super.update();
			
			if ((playerPoints.checkWin() || PlayState(FlxG.state).skatersFinished) && timer.timeLeft > 3) {
				timer.stop();
				timer.start(3, 1, endLevel);
				timerTxt.exists = false;
			}
		}
		
		public function fillStar():void {
			var numBigStars:uint = playerPoints.getBigStars();
			// prevents null pointer exception on goalStars array, when
			// player achieves more than required stars for a level
			if (goalStars.length - numFilledBigStars >= 1) {
				while (numFilledBigStars < numBigStars) {
					var sprite:FlxSprite = FlxSprite(goalStars[goalStars.length - 1 - numFilledBigStars]);
					sprite.loadGraphic(Media.bigStarPng);
					numFilledBigStars++;
				}
			}
		}
		
		private function getTimeString(timeLeft:uint):String {
			var seconds:String = String(uint(timeLeft % 60));
			if (seconds.length == 1) {
				seconds = "0" + seconds;
			}
			return uint(timeLeft / 60) + ":" + seconds;
		}
		
		public function endLevel(timer:FlxTimer):void {
			PlayState(FlxG.state).endLevel();
		}
		
		public function onRestart():void {
			PlayState(FlxG.state).restartLevel();
		}
		
		override public function destroy():void {
			super.destroy();
			player = null;
		}
	}
	
}