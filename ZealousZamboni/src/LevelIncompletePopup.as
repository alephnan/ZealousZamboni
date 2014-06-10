package  
{
	import org.flixel.*;
	/**
	 * ...
	 * @author Dana Van Aken
	 */
	public class LevelIncompletePopup extends FlxGroup
	{
		public static const PITFALL:String = "Your zamboni fell into the water!";
		public static const TIMER_UP:String = "Time is up";
		
		public static var LEVEL_LOST_REASON:String = TIMER_UP;
		private var popGraphic:FlxSprite;
		private var button:FlxButton;
		
		public function LevelIncompletePopup() 
		{
			// popup
			popGraphic = new FlxSprite(0, 0, Media.levelIncompletePNG);
			popGraphic.x = FlxG.width / 2 - popGraphic.width / 2;
			popGraphic.y = FlxG.height / 2 - popGraphic.height / 2;
			
			// button (green arrow)
			button = new FlxButton(FlxG.width / 2 - 30, FlxG.height / 2 + 55, null, onClick);
			button.loadGraphic(Media.retryPNG);
			
			// level lost text
			var textSize:uint = 32;
			var lostTxt:FlxText = new FlxText(button.getMidpoint().x - (LEVEL_LOST_REASON.length * (textSize / 2)), 
					button.getMidpoint().y - 100, LEVEL_LOST_REASON.length * textSize, LEVEL_LOST_REASON, true);
			lostTxt.setFormat("thys", textSize, 0x000000, "center");

			var skipTxt:FlxText = new FlxText(FlxG.width / 2 - 150, FlxG.height - 35, 300, "Press Enter to Continue", true);
			skipTxt.setFormat("coolvetica", 20, 0x000000, "center");
			
			add(skipTxt);
			add(popGraphic);
			add(lostTxt);
			add(button)
			
			PlayState(FlxG.state).pause();
		}
		
		override public function update():void {
			if (FlxG.keys.justPressed("ENTER")) {
				ZzLog.logAction(ZzLog.ACTION_SKIP_STARTINCOMPLETE , { } );
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