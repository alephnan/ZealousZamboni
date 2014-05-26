package  
{
	import org.flixel.*;
	/**
	 * ...
	 * @author Dana Van Aken
	 */
	public class LevelIncompletePopup extends FlxGroup
	{
		private var popGraphic:FlxSprite;
		private var button:FlxButton;
		
		public function LevelIncompletePopup() 
		{
			// popup
			popGraphic = new FlxSprite(0, 0, Media.levelIncompletePNG);
			popGraphic.x = FlxG.width / 2 - popGraphic.width / 2;
			popGraphic.y = FlxG.height / 2 - popGraphic.height / 2;
			
			// button (green arrow)
			button = new FlxButton(FlxG.width / 2 - 20, FlxG.height / 2 + 40, null, onClick);
			button.loadGraphic(Media.retryPNG);
			
			add(popGraphic);
			add(button)
			
			PlayState(FlxG.state).pause();
		}
		
		override public function update():void {
			if (FlxG.keys.justPressed("ENTER")) {
				onClick();
			}
			
			switch(button.status) {
				case FlxButton.HIGHLIGHT:
					button.alpha = 1.0;
					break;
				case FlxButton.PRESSED:
					button.alpha = 0.5;
					break;
				case FlxButton.NORMAL:
				default:
					button.alpha = 0.8;
					break;
			}
			super.update();
		}
		
		private function onClick():void {
			kill();
			PlayState(FlxG.state).unpause();
			FlxG.switchState(new PlayState());
		}
		
	}

}