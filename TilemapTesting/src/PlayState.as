package
{
	import org.flixel.*;

	public class PlayState extends FlxState
	{
		[Embed(source = "tiles.jpg")] public var TilesImg:Class;
		[Embed(source = 'level1.txt', mimeType = "application/octet-stream")] public var Level1Csv:Class;
		
		private static var TILE_SIZE:int = 8;
		
		private var levelMap:FlxTilemap;
		private var data:String;

		override public function create():void
		{	
			//Create a new tilemap using our level data
			levelMap = new FlxTilemap();
			levelMap.loadMap(new Level1Csv, TilesImg,TILE_SIZE,TILE_SIZE,FlxTilemap.OFF, 0, 0, 1);

			add(levelMap);
			/*for (var i:String in levelMap.getTileInstances(3)) {
				trace(i);
			}*/
		}
	}
}