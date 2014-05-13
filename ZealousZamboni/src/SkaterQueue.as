package  
{
	import org.flixel.*;
	/**
	 * ...
	 * @author Dana Van Aken
	 */
	public class SkaterQueue extends FlxGroup implements SpriteQueue
	{
		private var skaters:Array;
		private var initialNumSkaters:uint;
		private var updateSkatersLeft:Function;
		
		public function SkaterQueue() {
			skaters = new Array();
			initialNumSkaters = 0;
		}
		
		public function addSpriteData(sd:SpriteData):void {
			skaters.push(sd);
		}
		
		public function skatersFinished():Boolean {
			return skaters.length == 0 && countLiving() == 0;
		}
		
		public function startTimer():void {
			initialNumSkaters = skaters.length;
			this.skaters.sortOn("startTime", Array.NUMERIC | Array.DESCENDING);
			for each (var skater:SpriteData in skaters) {
				var timer:FlxTimer = new FlxTimer();
				timer.start(skater.startTime, 1, startSprite);
			}
		}
		
		private function startSprite(timer:FlxTimer):void {
			var next:SpriteData = skaters.pop();
			var p:FlxPoint;
			var count:int = 10;
			while (entranceBlocked(p = ZzUtils.getRandomEntrance()) && count > 0) {
				count--;
			}
			var skater:Skater = new Skater(p.x, p.y, next.iceTime);
			add(skater);
			skater.postConstruct(PlayState(FlxG.state).addDep);
			updateSkatersLeft(skaters.length);
		}
		
		public function setUpdateSkatersFunction(updateSkatersLeft:Function):uint {
			this.updateSkatersLeft = updateSkatersLeft;
			return skaters.length;
		}
		
		private function entranceBlocked(p:FlxPoint):Boolean {
			var map:FlxTilemap = PlayState(FlxG.state).level;
			var entrance:FlxPoint = new FlxPoint(p.x, p.y);
			entrance.x /= LevelLoader.TILE_SIZE;
			entrance.y /= LevelLoader.TILE_SIZE;
			return !(map.getTile(entrance.x + 1, entrance.y) < LevelLoader.ICE_TILE_INDEX_END ||
			         map.getTile(entrance.x - 1, entrance.y) < LevelLoader.ICE_TILE_INDEX_END ||
					 map.getTile(entrance.x, entrance.y + 1) < LevelLoader.ICE_TILE_INDEX_END ||
					 map.getTile(entrance.x, entrance.y - 1) < LevelLoader.ICE_TILE_INDEX_END);
		}
		
		/**
		 * Call this function to find out how many members of the group are dead.
		 * 
		 * @return	The number of <code>FlxBasic</code>s flagged as dead.  Returns -1 if group is empty.
		 */
		public function countNotExists():int
		{
			var count:int = -1;
			var basic:FlxBasic;
			var i:uint = 0;
			while(i < length)
			{
				basic = members[i++] as FlxBasic;
				if(basic != null)
				{
					if(count < 0)
						count = 0;
					if(!basic.exists)
						count++;
				}
			}
			return count;
		}
	}

}