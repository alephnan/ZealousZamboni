package
{
	import org.flixel.FlxState;
	import org.flixel.*;
	
	/**
	 * ...
	 * @author Kenny
	 * This state is the menu that the player sees upon starting up the flash game.
	 */
	public class StartState extends FlxState 
	{
		override public function create() : void {
			add(new FlxText(FlxG.width / 2 - 50, 50, 100, "Zealous Zamboni!"));
			add(new FlxText(FlxG.width / 2 - 50, 70, 100, "Controls"));
			add(new FlxText(FlxG.width / 2, 90, 100, "Click where you want to go"));
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
			FlxG.switchState(new PlayState());
		}
	}
	
}