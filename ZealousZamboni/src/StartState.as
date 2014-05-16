package
{
	import org.flixel.FlxState;
	import org.flixel.*;
	import flash.media.Sound;
	import org.flixel.system.FlxTile;
	
	/**
	 * ...
	 * @author Kenny
	 * This state is the menu that the player sees upon starting up the flash game.
	 */
	public class StartState extends FlxState 
	{
		[Embed(source = '../res/start.txt', mimeType = "application/octet-stream")] public var StartCsv:Class;
		
		private var map:FlxTilemap;
		private var player:Zamboni;
		private var start:FlxSprite;
		private var firstClick:Boolean = true;
		
		override public function create() : void {
			ZzLog.logLevelStart(ZzLog.PREGAME_QID);
			
			map = new FlxTilemap();
			map.loadMap(new StartCsv(), Media.StartTilesheet, LevelLoader.TILE_SIZE, LevelLoader.TILE_SIZE, FlxTilemap.OFF, 0, 0, LevelLoader.ICE_TILE_INDEX_END);
			map.setTileProperties(LevelLoader.WALL_INDEX, FlxObject.ANY, tileCollision, null, LevelLoader.NUM_TILES - LevelLoader.WALL_INDEX);
			add(map);
			player = new Zamboni(255, 340, map);
			add(player);
			start = new FlxSprite(72, 293, Media.StartImg);
			start.immovable = true;
			add(start);
			
			var txt1:FlxText = new FlxText(FlxG.width / 2 + 215, 50, FlxG.width, "Level 1");
			txt1.size = 24;
			txt1.scale = new FlxPoint(2, 2);
			txt1.color = 0xE8E8E8;
			txt1.shadow = 0x808080;
			add(txt1);
			
			var txt2:FlxText = new FlxText(FlxG.width / 2 - 200, 150, FlxG.width, "Drive to the START banner to begin!");
			txt2.size = 18;
			txt2.color = 0x33CCFF;
			add(txt2);
			
			add(new FlxSprite(400, 250, Media.MouseImg));
			FlxG.mouse.show();
			
			LevelLoader.SOUND_PLAYER.startPlaylist();
		}
		
		override public function update():void {
			if (firstClick && FlxG.mouse.justPressed()) {
				firstClick = false;
				var data:Object = {"mouseX":FlxG.mouse.x, "mouseY":FlxG.mouse.y };
				ZzLog.logAction(ZzLog.ACTION_FIRST_MOUSE_CLICK, data);
			}
			super.update();
			FlxG.collide(map, player, tileCollision);
			FlxG.collide(player, start, startCollision);
		}
		
		private function onFade() : void {
			player.kill();
			ZzLog.logLevelEnd(false, null, 0);
			FlxG.level = 3;
			FlxG.switchState(new PlayState());
		}
		
		public function startCollision(object1:FlxObject, object2:FlxObject):void {
			FlxG.flash(0xffffffff, 0.75);
			FlxG.fade(0xff000000, 1, onFade);
		}
		
		public function tileCollision(object1:FlxObject, object2:FlxObject):void {
		}
		
		override public function destroy():void {
			super.destroy();
			map = null;
			player = null;
			start = null;
		}
	}
	
}