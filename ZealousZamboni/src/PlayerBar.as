package  
{
	import org.flixel.*;
	/**
	 * ...
	 * @author Dana Van Aken
	 */
	public class PlayerBar extends FlxGroup
	{
		
		
		private var playerLivesTxt:FlxText;
		private var playerHealth:uint;
		
		public function PlayerBar(x:Number, y:Number, playerHealth:uint) 
		{
			// Add heart to player health bar
			var heart:FlxSprite = new FlxSprite(x, y, Media.HeartImg);
			heart.x = FlxG.width - FlxG.width / 8;
			//heart.y = heart.height / 2;
			add(heart);
			this.playerHealth = playerHealth;
			playerLivesTxt = new FlxText(FlxG.width - FlxG.width / 8 + heart.width, 0, 20, String(playerHealth), false);
			playerLivesTxt.setFormat(null, 24, 0xffffff, "center");
			playerLivesTxt.scale = new FlxPoint(2, 2);
			playerLivesTxt.y = heart.getMidpoint().y - playerLivesTxt.height / 2 - 6;
			add(playerLivesTxt);
		}
		
		public function updatePlayerHealth(healthLeft:uint):void {
			playerLivesTxt.text = String(healthLeft);
		}
		
		override public function destroy():void {
			playerLivesTxt = null;
			super.destroy();
		}
		
	}

}