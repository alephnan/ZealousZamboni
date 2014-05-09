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
		
		private var y:Number;
		private var state:PlayState;
		
		// A ref to the player health bar group at the top of the level
		private var playerBar:PlayerBar;
		
		private var player:Zamboni;
		
		private var skatersLeft:Function;
		private var skatersLeftTxt:FlxText;
		/**
		 * @param   player a reference to the player of the game
		 * @param   skatersLeft a getter for the number of skaters left (that haven't come on yet)
		 * @param	state The play state to track
		 */
		public function ZzHUD(player:Zamboni, state:PlayState) {
			y = 480;
			this.state = state;
			this.player = player;
			skatersLeft = SkaterQueue(state.queues[LevelLoader.SKATER_QUEUE_INDEX]).skatersLeft;
			playerBar = new PlayerBar(0, y+20, player.health);
			add(playerBar);
			//add skatersLeft counter
			//TODO create real icon instead of string
			var skaterIcon:FlxText = new FlxText(20, y+20, 96, "Skaters left: ", false);
			skaterIcon.setFormat(null, 24, 0xffffff, "center");
			skaterIcon.scale = new FlxPoint(1, 1);
			add(skaterIcon);
			skatersLeftTxt = new FlxText(20+96, y + 16, 20, String(skatersLeft()), false);
			skatersLeftTxt.setFormat(null, 24, 0xffffff, "center");
			skatersLeftTxt.scale = new FlxPoint(2, 2);
			add(skatersLeftTxt);
		}
		
		override public function update() : void {
			playerBar.updatePlayerHealth(player.health);
			skatersLeftTxt.text = String(skatersLeft());
		}
		
	}
	
}