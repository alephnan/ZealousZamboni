package
{
	import org.flixel.*;
	
	/**
	 * ...
	 * @author Kenny
	 * 
	 * This state is the menu that the player sees upon losing a level
	 */
	public class LevelFailedState extends FlxState 
	{
		//private var state:PlayState;
		/**
		 * Constructs a levelFailedState
		 * @param state the previous PlayState
		 */
		/*public function LevelFailedState(state:PlayState) {
			super();
			this.state = state;
		}*/
		
		override public function create() : void {
			/*var failTxt:FlxText = new FlxText(FlxG.width / 2 - 50, 50, 100, "Failure");
			failTxt.scale = new FlxPoint(3, 3);
			add(failTxt);
			add(new FlxText(FlxG.width / 2 - 50, 190, 100, "Press S to start"));*/
			
			FlxG.bgColor = 0xFFFFFF;
			var txt1:FlxText = new FlxText(FlxG.width / 2 + 5, 50, FlxG.width, "You didn't collect enough stars");
			txt1.size = 28;
			txt1.scale = new FlxPoint(2, 2);
			txt1.color = 0xE8E8E8;
			txt1.shadow = 0x808080;
			add(txt1);
			
			var button:FlxButton = new FlxButton(FlxG.width / 2 - 40, 350, "Retry Level " + FlxG.level, onClick);
			button.color = 0x33CCFF;
			button.width *= 5;
			button.height *= 5;
			button.scale = new FlxPoint(5, 6);
			button.label.scale = new FlxPoint(5, 5);
			button.labelOffset.x = 150;
			button.labelOffset.y = 20;
			button.centerOffsets(true);
			add(button);
		}
		
		public function onClick():void {
			FlxG.flash(0xffffffff, 0.75);
			FlxG.fade(0xff000000, 1, onFade);
		}
		
		/*override public function update():void {
			if (FlxG.keys.pressed("S")) {
				FlxG.flash(0xffffffff, 0.75);
				FlxG.fade(0xff000000, 1, onFade);
			}
			super.update();
		}*/
		
		private function onFade() : void {
			//var lvlNum:uint = state.levelNum;
			//state.destroy();
			FlxG.switchState(new PlayState());
		}
	}
	
}