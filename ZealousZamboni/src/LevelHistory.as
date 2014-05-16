package 
{
	
	/**
	 * A collection of stuff we want to log when the level ends
	 * currently (and perhaps always) only includes mouse coordinates and whether or not it was a loss
	 * Keep in mind that most of the stuff that happens should be logged when it happens. This is just stuff that makes sense to give at the level end
	 */
	public class LevelHistory 
	{
		public var mouseHistory:Array;
		public var isLoss:Boolean;
		public var finalScore:int;
		
		public function LevelHistory(isLoss:Boolean, mHistory:Array, finalScore:int) {
			this.mouseHistory = mHistory;
			this.isLoss = isLoss;
			this.finalScore = finalScore;
		}
	}
	
}