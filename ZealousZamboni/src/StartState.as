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
		
		//private static const WALL_INDEX:uint = 512;
		//private static const ICE_TILE_INDEX_END:uint = 1024;
		//private static const NUM_TILES:uint = 2048;
		
		private var map:FlxTilemap;
		private var player:Zamboni;
		private var start:FlxSprite;
		private var firstClick:Boolean = true;
		public var level:FlxTilemap;
		
		override public function create() : void {
			ZzLog.logLevelStart(ZzLog.PREGAME_QID);
			
			map = new FlxTilemap();
			level = map;
			//map.loadMap(new StartCsv(), Media.StartTilesheet, LevelLoader.TILE_SIZE, LevelLoader.TILE_SIZE, FlxTilemap.OFF, 0, 0, LevelLoader.ICE_TILE_INDEX_END);
			map.loadMap(new StartCsv(), Media.TileSheet, LevelLoader.TILE_SIZE, LevelLoader.TILE_SIZE, FlxTilemap.OFF, 0, 0, LevelLoader.ICE_TILE_INDEX_END);
			//map.setTileProperties(LevelLoader.WALL_INDEX, FlxObject.ANY, tileCollision, null, LevelLoader.NUM_TILES - LevelLoader.WALL_INDEX);
			map.setTileProperties(LevelLoader.ICE_TILE_INDEX_END, FlxObject.ANY, tileCollision, null, LevelLoader.NUM_TILES - LevelLoader.ICE_TILE_INDEX_END);
			add(new FlxSprite(0, 0, Media.snowBackgroundPNG));
			add(map);
			player = new Zamboni(255, 340, map);
			add(player);
			start = new FlxSprite(75, 293, Media.StartImg);
			start.width += 10;
			start.immovable = true;
			add(start);
			
			var txt1:FlxText = new FlxText(FlxG.width / 2 - 330, 40, FlxG.width, "Controls");
			//txt1.scale = new FlxPoint(2, 2);
			txt1.setFormat("poster", 64, 0xE8E8E8, "center", 0x808080);
			//txt1.setFormat(null, 44, 0xE8E8E8, "center");
			add(txt1);
			
			var txt2:FlxText = new FlxText(FlxG.width / 2 - 330, 140, FlxG.width, "Drive to START to begin!");
			txt2.setFormat("coolvetica", 40, 0x33CCFF, "center");
			add(txt2);
			
			var txt3:FlxText = new FlxText(410, 350, 100, "OR", true);
			txt3.setFormat("coolvetica", 40, 0xb8b8b8, "center");
			add(txt3);
			
			add(new FlxSprite(280, 240, Media.MouseImg));
			add(new FlxSprite(500, 310, Media.wasdPNG));
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
			FlxG.level = ZzUtils.STARTING_LEVEL;
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