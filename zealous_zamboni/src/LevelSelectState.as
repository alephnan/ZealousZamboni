package  
{
	import org.flixel.*;
	/**
	 * ...
	 * @author Dana Van Aken
	 */
	public class LevelSelectState extends FlxState
	{
		private var levels:Array;
		
		override public function create() : void {
			add(new FlxSprite(0, 0, Media.snowBackgroundPNG));
			var startX:uint = 80;
			var sideStep:uint = 200;
			var stepInit:uint = 120;
			var step:uint = 60;
			levels = new Array();
			var tutorial:FlxButton = new FlxButton(startX, stepInit - step, "Warm-up");
			tutorial.scale = new FlxPoint(2, 2);
			tutorial.label.setFormat("coolvetica", 20);
			add(tutorial);
			levels.push(tutorial);
			var num:uint = LevelLoader.NUM_LEVELS;
			var levelSelect:uint = 1;
			for (var i:uint = 0; i < 3; ++i) {
				for (var j:uint = 0; j < 6; ++j) {
					var button:FlxButton = new FlxButton(startX + sideStep * i, stepInit + j * step, "Level " + levelSelect++);
					add(button);
					button.scale = new FlxPoint(2, 2);
					button.label.setFormat("coolvetica", 20);
					levels.push(button);
				}
				
			}
			
			
		}
		
		override public function update():void {
			super.update();
			for (var i:uint = 0; i < levels.length; ++i) {
				if (FlxButton(levels[i]).status == FlxButton.PRESSED) {
					levelSelected(i)
				}
			}
		}
		
		public function levelSelected(levelNum:uint=0):void {
			FlxG.level = levelNum;
			ZzUtils.STARTING_LEVEL = levelNum;
			FlxG.flash(0xffffffff, 0.75);
			FlxG.fade(0xff000000, 1, onFade);
		}
		
		private function onFade() : void {
			FlxG.switchState(new PlayState());
		}
		
	}

}