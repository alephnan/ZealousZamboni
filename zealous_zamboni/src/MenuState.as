package  
{
	import org.flixel.*;
	/**
	 * ...
	 * @author Dana Van Aken
	 */
	public class MenuState extends FlxState
	{
		override public function create() : void {
			var background:FlxSprite = new FlxSprite(0, 0, Media.menuPng);
			add(background);
			var playButton:FlxButton = new FlxButton(FlxG.width - FlxG.width / 3 - 50, FlxG.height - FlxG.height / 3 + 60, "PLAY", onPlay);
			var levelSelect:FlxButton = new FlxButton(FlxG.width - FlxG.width / 3 + 90, FlxG.height - FlxG.height / 3 + 60, "SELECT LEVEL", onSelectLevel);
			levelSelect.label.setFormat("challenge", 30);
			playButton.label.setFormat("challenge", 36);
			playButton.width *= 2;
			playButton.height *= 2;
			levelSelect.scale = new FlxPoint(1.5, 5);
			playButton.scale = new FlxPoint(1.5, 5);
			levelSelect.centerOffsets(true);
			playButton.centerOffsets(true);
			playButton.labelOffset.x += 40;
			playButton.labelOffset.y -= 6;
			levelSelect.labelOffset.y -= 28;
			add(playButton);
			add(levelSelect);
		}
		
		public function onPlay():void {
			FlxG.flash(0xffffffff, 0.75);
			FlxG.fade(0xff000000, 1, onFadePlay);
		}
		
		public function onSelectLevel():void {
			FlxG.flash(0xffffffff, 0.75);
			FlxG.fade(0xff000000, 1, onFadeLevelSelect);
		}
		
		public function onFadePlay():void {
			ZzUtils.STARTING_LEVEL = 0;
			FlxG.level = ZzUtils.STARTING_LEVEL;
			FlxG.switchState(new PlayState());
		}
		
		public function onFadeLevelSelect():void {
			FlxG.switchState(new LevelSelectState);
		}
		
	}

}