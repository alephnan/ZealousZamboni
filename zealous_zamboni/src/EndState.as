package  
{
	import org.flixel.*;
	/**
	 * ...
	 * @author Dana Van Aken
	 */
	public class EndState extends FlxState
	{	
		override public function create() : void {
			
			FlxG.bgColor = 0xFFFFFF;
			var txt1:FlxText = new FlxText(FlxG.width / 2 + 15, 70, FlxG.width, "Congratulations!");
			txt1.size = 30;
			txt1.scale = new FlxPoint(2, 2);
			txt1.color = 0xE8E8E8;
			txt1.shadow = 0x808080;
			add(txt1);
			
			var txt2:FlxText = new FlxText(FlxG.width / 2 + 50, 175, FlxG.width, "You have beat all of the levels");
			txt2.size = 14;
			txt2.scale = new FlxPoint(2, 2);
			txt2.color = 0xE8E8E8;
			add(txt2);
			
			
			
			var button:FlxButton = new FlxButton(FlxG.width / 2 - 40, 350, "Restart game", onClick);
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
		
		private function onFade() : void {
			FlxG.level = 1;
			FlxG.switchState(new PlayState());
		}
		
	}

}