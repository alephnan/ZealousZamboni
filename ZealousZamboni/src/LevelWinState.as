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
		//private var state:PlayState;
		
		//private var nextLevel:uint;
		/**
		 * Constructs a levelFailedState
		 * @param state the previous PlayState
		 */
		/*public function LevelWinState(state:PlayState) {
			super();
			this.state = state;
			nextLevel = state.levelNum + 1;
		}*/
		
		override public function create() : void {
			FlxG.bgColor = 0xFFFFFF;
			var txt1:FlxText = new FlxText(FlxG.width / 2 + 100, 100, FlxG.width, "Success!!!");
			txt1.size = 40;
			txt1.scale = new FlxPoint(2, 2);
			txt1.color = 0xE8E8E8;
			txt1.shadow = 0x808080;
			add(txt1);
			
			var button:FlxButton = new FlxButton(FlxG.width / 2 - 40, 350, "Start level " + (FlxG.level+1), onClick);
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
		
		/*override public function update():void {
		if (FlxG.keys.pressed("S")) {
				FlxG.flash(0xffffffff, 0.75);
				FlxG.fade(0xff000000, 1, onFade);
			}
			super.update();
		}*/
		
		public function onClick():void {
			FlxG.flash(0xffffffff, 0.75);
			FlxG.fade(0xff000000, 1, onFade);
		}
		
		private function onFade() : void {
			//state.destroy();
			FlxG.level++;
			FlxG.switchState(new PlayState());
		}
	}
	
}