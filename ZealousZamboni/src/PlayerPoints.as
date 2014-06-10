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
		public static const KILL_ZOMBIE_REWARD:uint = 100;
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
			bigStar = new BigStar();
			add(bigStar);
		}
		
		public function generateReward(location:FlxPoint, points:uint, isBigStar:Boolean):void {
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
				if (PlayState.TUTORIAL) {
					PlayState(FlxG.state).tutorialState.handleConversionCallout();
				}
				numBigStars += numSmallStars / STAR_CONVERSION;
				numSmallStars %= STAR_CONVERSION;
				bigStarAnimation();
			}
		}
		
		private function bigStarAnimation():void {
			bigStar.animate(numBigStars);
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
		
		public function checkLoss():Boolean {
			var numTrailsLeft:uint = 0;
			var data:Array = PlayState(FlxG.state).level.getData();
			for (var i:uint = 0; i < data.length; ++i) {
				if (data[i] >= LevelLoader.TRAIL_TILE_INDEX && data[i] < LevelLoader.TRAIL_TILE_INDEX + LevelLoader.NUM_COLORS)
					numTrailsLeft++;
			}
			var sq:SkaterQueue = SkaterQueue(PlayState(FlxG.state).activeSprites[PlayState.SKATERS_INDEX]);
			var mq:MonsterQueue = MonsterQueue(PlayState(FlxG.state).activeSprites[PlayState.ZOMBIES_INDEX]);
			var outOfSkatersNotEnoughTrails:Boolean = sq.skatersFinished() && (numTrailsLeft + numSmallStars) < STAR_CONVERSION;
			var notEnoughZombiesLeft:Boolean = (mq.activeZombies + mq.zombiesLeft) * KILL_ZOMBIE_REWARD < STAR_CONVERSION;
			var loss:Boolean = !checkWin() && outOfSkatersNotEnoughTrails && notEnoughZombiesLeft;
			if (loss)
				LevelIncompletePopup.LEVEL_LOST_REASON = "Too many skaters died!";
			return loss;
		}
		
	}

}