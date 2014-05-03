package
{
	import adobe.utils.CustomActions;
	import org.flixel.*;
	import org.as3commons.collections.ArrayList;
	/**
	 * ...
	 * @author Kenny
	 * This is the actual in-game playing state that controls most of the game
	 */
	public class PlayState extends FlxState
	{
		[Embed(source = "../res/tiles.jpg")] public var TileSheet:Class;
		[Embed(source = '../res/level0.txt', mimeType = "application/octet-stream")] public var Level1Csv:Class;
		[Embed(source = "../res/level_0.xml", mimeType = "application/octet-stream")] public var Level1XML:Class;
		[Embed(source = "../res/xml_test.xml", mimeType = "application/octet-stream")] public var XmlTest:Class;
		
		private static const DEBUG:Boolean = true;
		
		//Size of tiles in pixels
		private static const TILE_SIZE:int = 8;

		//Set of all blocks in the level
		private var level:FlxTilemap;
		
		//Set of all sprites active in the level (including the player)
		private var activeSprites:FlxGroup;
		private var player:Zamboni;
		private var movables:ArrayList;
		
		public function PlayState() {
			
		}
		
		override public function create() : void {
			FlxG.bgColor = 0xffaaaaaa;
			level = new FlxTilemap();
			level.loadMap(new Level1Csv(), TileSheet, TILE_SIZE, TILE_SIZE, FlxTilemap.OFF, 0, 0, 1);
			add(level);
			activeSprites = new FlxGroup();
			movables = new ArrayList();
			parseXML();
			FlxG.mouse.show();
		}
		
		//Adds a ZzUnit to the appropriate lists
		//This should be called only when the target unit should be placed in the game
		public function addUnit(z:ZzUnit) : void {
			movables.add(z);
			activeSprites.add(z);
			add(z);
			if (z is Skater) {
				add(Skater(z).getTrail());
				activeSprites.add(Skater(z).getTrail());
			}
		}
		
		override public function update():void
		{
			/*player.acceleration.x = 0;
			player.acceleration.y = 0;
			FlxG.mouse.getWorldPosition
			if(FlxG.keys.LEFT)
				player.acceleration.x = -player.maxVelocity.x*4;
			if(FlxG.keys.RIGHT)
				player.acceleration.x = player.maxVelocity.x*4;
			if (FlxG.keys.UP)
				player.acceleration.y = -player.maxVelocity.y * 4;
			if (FlxG.keys.DOWN)
				player.acceleration.y = player.maxVelocity.y * 4;*/
			var mouse:FlxPoint = FlxG.mouse.getWorldPosition(); //mouse coordinates
			
			var z:FlxPoint = player.getMidpoint();	//player coordinates
			var n:Number = 5;	//tolerance in pixels
			if(FlxG.mouse.pressed()){
				if (mouse.x < z.x - n) {
					player.velocity.x = -player.maxVelocity.x;
				}else if (mouse.x - n > z.x) {
					player.velocity.x = player.maxVelocity.x;
				}else {
					player.velocity.x = 0;
				}
				if (mouse.y < z.y - n) {
					player.velocity.y = -player.maxVelocity.y;
				}else if (mouse.y - n > z.y) {
					player.velocity.y = player.maxVelocity.y;
				}else {
					player.velocity.y = 0;
				}
			}else {
				player.velocity.x = 0;
				player.velocity.y = 0;
			}
			
			super.update();
			for each(var m:FlxBasic in members) {
				if (!m.exists) {
					remove(m);
				}
			}
			FlxG.collide(level, activeSprites, onCollision);
			FlxG.collide(activeSprites, activeSprites, onCollision);
		}
		
		private function onCollision(a:FlxObject, b:FlxObject) : void {
			if (a is ICollidable) {
				ICollidable(a).onCollision(b);
			}
			if (b is ICollidable) {
				ICollidable(b).onCollision(a);
			}
		}
		
		private function parseXML():void {
			var xml:XML = new XML(new Level1XML());
			
			// Get assumed framewidth and frameheight
			var assumedWidth:int = parseInt(xml.@width);
			var assumedHeight:int = parseInt(xml.@height);
			if (DEBUG)
				trace("assumed framewidth = " + assumedWidth + ", assumed frameheight = " + assumedHeight);
			
			// If actual w/h != assumed, "resize" level
			var resize:Boolean = (assumedWidth != FlxG.width) || (assumedHeight != FlxG.height);
			var resizeX:Number = 1;
			var resizeY:Number = 1;
			if (resize) {
				resizeX = Number(FlxG.width) / Number(assumedWidth);
				resizeY = Number(FlxG.height) / Number(assumedHeight);
			}
			
			// Player lives
			var lives:int = parseInt(xml.@lives, 10);
			if (DEBUG)
				trace("Number of player lives: " + lives);
			
			// Zamboni starting coordinates
			var zamboniX:int = parseInt(xml.zamboni.@x);
			var zamboniY:int = parseInt(xml.zamboni.@y);
			if (DEBUG)
				trace("zamboni x = " + zamboniX + ", zamboni y = " + zamboniY);
			if (resize) {
				zamboniX *= resizeX;
				zamboniY *= resizeY;
			}
			player = new Zamboni(zamboniX, zamboniY);
			addUnit(player);
			
			// Skaters: coordinates and time
			for each (var s:XML in xml.skater) {
				var skaterX:int = s.@x;
				var skaterY:int = s.@y;
				if (DEBUG)
					trace("skater x = " + skaterX + ", skater y = " + skaterY);
				if (resize) {
					skaterX *= resizeX;
					skaterY *= resizeY;
				}
				var skateTime:int = s.time;
				if (DEBUG)
					trace("Skater time on ice: " + skateTime);
				addUnit(new Skater(skaterX, skaterY));
			}
			
			// Powerups: coordinates, time, and type
			for each (var p:XML in xml.powerup) {
				var powerupX:int = p.@x;
				var powerupY:int = p.@y;
				if (DEBUG)
					trace("powerup x = " + powerupX + ", powerup y = " + powerupY);
				if (resize) {
					powerupX *= resizeX;
					powerupY *= resizeY;
				}
				var powerupTime:int = p.time;
				if (DEBUG)
					trace("Powerup time on ice: " + powerupTime);
					
				var powerupType:String = p.type;
				if (DEBUG)
					trace("Powerup type: " + powerupType);
			}
			
			// Zombies: coordinates
			for each (var z:XML in xml.zombie) {
				var zombieX:int = z.@x;
				var zombieY:int = z.@y;
				if (DEBUG)
					trace("zombie x = " + zombieX + ", zombie y = " + zombieY);
				if (resize) {
					zombieX *= resizeX;
					zombieY *= resizeY;
				}
			}
			
		}
	}
	
}