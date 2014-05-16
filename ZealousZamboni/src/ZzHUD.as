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
		private var playerBar:PlayerBar;
		
		private var restartButton:FlxButton;
		
		private var player:Zamboni;
		private var playerGoal:uint;
		private var timerTxt:FlxText;
		private var timer:FlxTimer;
		
		/**
		 * @param   player 		a reference to the player of the game
		 * @param   levelTime	the length of the level in seconds
		 */
		public function ZzHUD(player:Zamboni, levelTime:uint, playerGoal:uint) {
			this.player = player;
			this.playerGoal = playerGoal;
			
			restartButton = new FlxButton(FlxG.width - FlxG.width / 4 + 80, 0, null, onRestart);
			restartButton.loadGraphic(Media.restartPNG);
			restartButton.scale = new FlxPoint(.6, .6);
			restartButton.width = .6*88;
			restartButton.height = .6*79;
			add(restartButton);
			
			playerBar = new PlayerBar(restartButton.x - 150, 20, playerGoal, player);
			add(playerBar);
			
			timerTxt = new FlxText(playerBar.x - 50, 20, 50, getTimeString(levelTime), false);
			timerTxt.size = 14;
			timerTxt.scale = new FlxPoint(2, 2);
			add(timerTxt);
			
			timer = new FlxTimer();
			timer.start(levelTime, 1, endLevel);
		}
		
		override public function update() : void {
			timerTxt.text = getTimeString(timer.timeLeft);
			super.update();
		}
		
		private function getTimeString(timeLeft:uint):String {
			return uint(timeLeft / 60) + ":" + uint(timeLeft % 60);
		}
		
		public function endLevel(timer:FlxTimer):void {
			if (playerBar.currentValue >= playerGoal) {
				PlayState(FlxG.state).winLevel();
			} else {
				PlayState(FlxG.state).loseLevel();
			}
		}
		
		public function onRestart():void {
			PlayState(FlxG.state).restartLevel();
		}
		
		override public function destroy():void {
			super.destroy();
			playerBar = null;
			player = null;
		}
		
	}
	
}