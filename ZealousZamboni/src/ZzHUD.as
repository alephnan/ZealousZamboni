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
		// A ref to the player health bar group at the top of the level
		//private var playerBar:PlayerBar;
		private var playerGoal:PlayerGoal;
		
		private var restartButton:FlxButton;
		private var muteButton:FlxButton;
		
		private var player:Zamboni;
		private var timerTxt:FlxText;
		private var timer:FlxTimer;
		
		
		/**
		 * @param   player 		a reference to the player of the game
		 * @param   levelTime	the length of the level in seconds
		 */
		public function ZzHUD(player:Zamboni, levelTime:uint, playerPoints:PlayerPoints) {
			
			this.player = player;
			
			restartButton = new FlxButton(FlxG.width - FlxG.width / 4 + 90, 30, null, onRestart);
			restartButton.loadGraphic(Media.restartPNG);
			add(restartButton);
			
			playerGoal = new PlayerGoal(restartButton.x - 60, 5, playerPoints);
			add(playerGoal);
			
			//playerBar = new PlayerBar(restartButton.x - 150, 20, playerGoal, player);
			//add(playerBar);
			var playerStarGoal:uint = 1; //playerPoints.getBigStarGoal();
			
			timerTxt = new FlxText(restartButton.x - playerStarGoal * 15 - playerStarGoal * 20 - 140, 20, 50, getTimeString(levelTime), false);
			timerTxt.size = 14;
			timerTxt.scale = new FlxPoint(2, 2);
			add(timerTxt);
			
			timer = new FlxTimer();
			timer.start(levelTime, 1, endLevel);
			
			
			// mute button
			muteButton = new FlxButton(FlxG.width - FlxG.width / 4 + 90, 80, null, toggleMute);
			muteButton.loadGraphic(Media.mutePng);
			add(muteButton);
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
			timerTxt.text = getTimeString(timer.timeLeft);
			super.update();
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
		
		public function updateStars():void {
			
		}
		
	}
	
}