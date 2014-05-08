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
	public class LevelFailedState extends FlxState 
	{
		private var state:PlayState;
		/**
		 * Constructs a levelFailedState
		 * @param state the previous PlayState
		 */
		public function LevelFailedState(state:PlayState) {
			super();
			this.state = state;
		}
		
		override public function create() : void {
			var failTxt:FlxText = new FlxText(FlxG.width / 2 - 50, 50, 100, "Failure");
			failTxt.scale = new FlxPoint(3, 3);
			add(failTxt);
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
			var lvlNum:uint = state.levelNum;
			state.destroy();
			FlxG.switchState(new PlayState(lvlNum));
		}
	}
	
}