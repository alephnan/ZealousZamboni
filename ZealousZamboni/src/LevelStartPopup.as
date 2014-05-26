package  
{
	import org.flixel.*;
	/**
	 * ...
	 * @author Dana Van Aken
	 */
	public class LevelStartPopup extends FlxGroup
	{
		private var popGraphic:FlxSprite;
		private var button:FlxButton;
		private var imageMessage:Class;
	
		private var tipScreen: Boolean;
		// reference to timer, so we can stop it if we skip end screen
		private var timer : FlxTimer;
		
		public function LevelStartPopup(imagePopup:Class=null, imageMessage:Class=null) 
		{
			
			tipScreen = false;
			super();
			if (imagePopup == null)
				imagePopup = Media.cleanIcePop;

			if (imageMessage == null)
				this.imageMessage = Media[LevelLoader.getTip(3)];
			else
				this.imageMessage = imageMessage;
			
			// overlay graphic
			popGraphic = new FlxSprite(0, 0, imagePopup);
			popGraphic.x = FlxG.width / 2 - popGraphic.width / 2;
			popGraphic.y = FlxG.height / 2 - popGraphic.height / 2;
			
			// button (green arrow)
			button = new FlxButton(FlxG.width / 2 + 90, FlxG.height / 2 - 22, null, onClick);
			button.loadGraphic(Media.goArrowPNG);
			
			// level text
			var lvlTxt:FlxText = new FlxText(FlxG.width / 2 - 140, FlxG.height / 2 - 105, 300, "Level " + FlxG.level, true);
			lvlTxt.setFormat("poster", 45, 0x000000, "center");
			
			// goal text
			var goalTxt:FlxText = new FlxText(FlxG.width / 2 - 150, FlxG.height / 2 - 20, 100, "Goal:", true);
			goalTxt.setFormat("challenge", 50, 0x000000, "center");
			
			var stamp:FlxSprite = new FlxSprite(0, 0, Media.bigStarPng);
			var goal:uint = PlayState(FlxG.state).playerPoints.getBigStarGoal();
			var widthOffset:uint = goalTxt.x + goalTxt.width + 10;
			var heightOffset:uint = goalTxt.y - 38;
			popGraphic.stamp(stamp, widthOffset, heightOffset);
			
			var numTxt:FlxText = new FlxText(widthOffset + stamp.width - 25, heightOffset + stamp.height - 2, 100, "x " + goal, true);
			numTxt.setFormat("coolvetica", 44, 0x000000, "center");
			
			add(popGraphic);
			add(button);
			add(lvlTxt);
			add(goalTxt);
			add(numTxt);
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
			if (imageMessage == null) {
				onComplete(null);
			} else {
				if(tipScreen == false) {
					setAll("exists", false, false);
					timer = new FlxTimer().start(2, 1, onComplete);
					popGraphic.loadGraphic(imageMessage);
					popGraphic.exists = true;
					
					tipScreen = true;
				} else {
					timer.stop();
					onComplete(null);
				}
			}
		}
		
		private function onComplete(timer:FlxTimer):void {
			PlayState(FlxG.state).unpause();
			kill();
			timer = null;
		}
	}
	
	

}