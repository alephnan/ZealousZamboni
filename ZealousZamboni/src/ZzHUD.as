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
		private var restartButton:FlxButton;
		private var muteButton:FlxButton;
		
		private var player:Zamboni;
		private var timerTxt:FlxText;
		private var timer:FlxTimer;
		
		private var playerPoints:PlayerPoints;
		private var goalStars:Array;
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
			numFilledBigStars = 0;

			// restart button
			restartButton = new FlxButton(FlxG.width - FlxG.width / 4 + 90, 30, null, onRestart);
			restartButton.loadGraphic(Media.restartPNG);
			add(restartButton);
			
			// mute button
			muteButton = new FlxButton(FlxG.width - FlxG.width / 4 + 90, 80, null, toggleMute);
			muteButton.loadGraphic(Media.mutePng);
			add(muteButton);
			
			// big stars
			var bigStarGoal:uint = playerPoints.getBigStarGoal();
			goalStars = new Array();
			for (var i:uint = 0; i < bigStarGoal; ++i) {
				var goalStar:FlxSprite = new FlxSprite(restartButton.x - (i+1)*50, 5);
				goalStar.loadGraphic(Media.bigStarOutlinePng);
				add(goalStar);
				goalStars.push(goalStar);
			}
			
			// number of small stars
			subGoalText = new FlxText(FlxSprite(goalStars[0]).x - 100, 22, 40, "0", false);
			subGoalText.size = 12;
			subGoalText.scale = new FlxPoint(2, 2);
			add(subGoalText);
			
			// small star
			subGoalStar = new FlxSprite(subGoalText.x - 70, 5);
			subGoalStar.loadGraphic(Media.smallStarIconPng);
			add(subGoalStar);
			
			
			// level timer
			timerTxt = new FlxText(100, 7, 50, getTimeString(levelTime), false);
			timerTxt.size = 12;
			timerTxt.scale = new FlxPoint(3, 3);
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
			var numBigStars:uint = playerPoints.getBigStars();
			//trace("numBigStars = " + numBigStars + ", filled big stars = " + numFilledBigStars);
			// redraw any new gold stars
			while (numFilledBigStars < numBigStars) {
				var sprite:FlxSprite = FlxSprite(goalStars[numFilledBigStars]);
				sprite.loadGraphic(Media.bigStarPng);
				numFilledBigStars++;
			}
			// reset small star text
			subGoalText.text = String(playerPoints.getSmallStars());
			timerTxt.text = getTimeString(timer.timeLeft);
			super.update();
			
			if (playerPoints.checkWin()) {
				PlayState(FlxG.state).endLevel();
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