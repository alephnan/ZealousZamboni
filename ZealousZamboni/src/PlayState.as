package 
{
	import org.flixel.*;
	/**
	 * ...
	 * @author Kenny
	 * This is the actual in-game playing state that controls most of the game
	 */
	public class PlayState extends FlxState
	{
		//Set of all blocks in the level
		var level:FlxTilemap;
		
		//Set of all sprites active in the level (including the player)
		var activeSprites:FlxGroup;
		
		
		public function FlxState() {
			
		}
	}
	
}