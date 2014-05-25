package  
{
	import org.flixel.*;
	/**
	 * ...
	 * @author Dana Van Aken
	 */
	public class PlayerPoints extends FlxGroup
	{
		public static const CLEAR_TRAIL_REWARD:uint = 1;
		public static const PICKUP_POWERUP_REWARD:uint = 10;
		public static const STAR_CONVERSION:uint = 500;
		public static const KILL_ZOMBIE_REWARD:uint = 20;
		public static const NUM_STAR_PARTICLES:uint = 400;
		private static const BIG_STAR_START:FlxPoint = new FlxPoint(FlxG.width / 2, FlxG.height / 2);
		private static const PATH_VELOCITY:uint = 900;
		private var playerBigStarGoal:uint;
		private var numSmallStars:uint;
		private var numBigStars:uint;
		private var starEmitter:FlxEmitter;
		private var bigStar:BigStar;
		private var bigStarPath:FlxPath;
		
		public function PlayerPoints(maxSize:uint=12, playerBigStarGoal:uint=1) {
			//super(maxSize);
			super();
			numSmallStars = 0;
			numBigStars = 0;
			if (playerBigStarGoal > 5)
				this.playerBigStarGoal = 1;
			else
				this.playerBigStarGoal = playerBigStarGoal;
			starEmitter = new FlxEmitter();
			setupEmitter();
			add(starEmitter);
			setupBigStarPath();
		}
		
		public function generateReward(location:FlxPoint, points:uint, isBigStar:Boolean, finished:Boolean):void {
			if (isBigStar) {
				bigStarAnimation();
				numBigStars++;
			} else {
				numSmallStars += points;
				starEmitter.x = location.x;
				starEmitter.y = location.y;
				starEmitter.emitParticle();
			}
			
			if (numSmallStars >= STAR_CONVERSION) {
				numBigStars += numSmallStars / STAR_CONVERSION;
				numSmallStars %= STAR_CONVERSION;
				bigStarAnimation();
				//add(new Shoutout("SUPER!", shoutoutCallback));
			}
		}
		
		/*public function shoutoutCallback(shoutout:Shoutout):void {
			bigStarAnimation();
			shoutout = null;
		}*/
		
		private function bigStarAnimation():void {
			bigStar.x = BIG_STAR_START.x;
			bigStar.y = BIG_STAR_START.y;
			if (numBigStars > 1) {
				var tail:FlxPoint = bigStarPath.tail();
				tail.x += 50;
			}
			bigStar.exists = true;
			bigStar.visible = true;
			bigStar.followPath(bigStarPath, PATH_VELOCITY);
		}
		
		private function setupBigStarPath():void {
			bigStar = new BigStar(BIG_STAR_START.x, BIG_STAR_START.y);
			add(bigStar);
			bigStarPath = new FlxPath();
			bigStarPath.addPoint(BIG_STAR_START, true);
			bigStarPath.add(30, FlxG.height / 4 + 20);
			bigStarPath.add(FlxG.width, FlxG.height / 4);
			bigStarPath.addPoint(ZzHUD.bigStarXY, true);
		}
		
		private function setupEmitter():void {
			for (var i:uint = 0; i < NUM_STAR_PARTICLES; ++i) {
				var star:StarParticle = new StarParticle();
				starEmitter.add(star);
			}
			starEmitter.particleClass = StarParticle;
			starEmitter.setSize(50, 20);
			starEmitter.lifespan = 0;
		}
		
		public function getBigStars():uint {
			return numBigStars;
		}
		
		public function getSmallStars():uint {
			return numSmallStars;
		}
		
		public function getBigStarGoal():uint {
			return playerBigStarGoal;
		}
		
		public function checkWin():Boolean {
			if (numBigStars >= playerBigStarGoal)
				return true;
			return false;
		}
		
	}

}