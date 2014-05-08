package
{
	import org.flixel.FlxState;
	import org.flixel.*;
	
	/**
	 * ...
	 * @author Kenny
	 * 
	 * This state is the menu that the player sees upon losing a level
	 */
	public class LevelWinState extends FlxState 
	{
		private var state:PlayState;
		
		private var nextLevel:uint;
		/**
		 * Constructs a levelFailedState
		 * @param state the previous PlayState
		 */
		public function LevelWinState(state:PlayState) {
			super();
			this.state = state;
			nextLevel = state.levelNum + 1;
			if (nextLevel > LevelLoader.NUM_LEVELS) {
				//end game
			}
		}
		
		override public function create() : void {
			var sucTxt:FlxText = new FlxText(FlxG.width / 2 - 50, 50, 100, "Success");
			sucTxt.scale = new FlxPoint(3, 3);
			add(sucTxt);
			var lvlTxt:FlxText = new FlxText(FlxG.width / 2 - 50, 100, 100, "Next level: "+nextLevel);
			lvlTxt.scale = new FlxPoint(3, 3);
			add(lvlTxt);
			add(new FlxText(FlxG.width / 2 - 50, 190, 100, "Press S to start"));
		}
		
		override public function update():void {
			if (FlxG.keys.pressed("S")) {
				FlxG.flash(0xffffffff, 0.75);
				FlxG.fade(0xff000000, 1, onFade);
			}
			super.update();
		}
		
		private function onFade() : void {
			state.destroy();
			FlxG.switchState(new PlayState(nextLevel));
		}
	}
	
}