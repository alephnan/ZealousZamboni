package  
{
	import org.flixel.*;
	/**
	 * ...
	 * @author Dana Van Aken
	 */
	public class PlayerBar extends FlxGroup
	{
		[Embed(source = "../media/heart.png")] public var HeartImg:Class;
		
		private var playerLivesTxt:FlxText;
		private var playerHealth:uint;
		
		public function PlayerBar(playerHealth:uint) 
		{
			// Add heart to player health bar
			var heart:FlxSprite = new FlxSprite(0, 0, HeartImg);
			heart.x = FlxG.width - FlxG.width / 6;
			heart.y = heart.height / 2;
			add(heart);
			this.playerHealth = playerHealth;
			playerLivesTxt = new FlxText(FlxG.width - FlxG.width / 6 + heart.width, 0, 20, String(playerHealth), false);
			playerLivesTxt.setFormat(null, 24, 0xffffff, "center");
			playerLivesTxt.scale = new FlxPoint(2, 2);
			playerLivesTxt.y = heart.getMidpoint().y - playerLivesTxt.height / 2 - 6;
			add(playerLivesTxt);
		}
		
		public function updatePlayerHealth(healthLeft:uint):void {
			playerLivesTxt.text = String(healthLeft);
		}
		
	}

}