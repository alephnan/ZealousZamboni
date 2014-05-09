package 
{
	import flash.media.Sound;
	/**
	 * ...
	 * @author Kenny
	 */
	public class SoundPlayer 
	{
		[Embed(source='../media/skaterdeath.mp3')] 		 
		private static var SkaterDeath : Class; 		 
		public static var skaterDeath : Sound = (new SkaterDeath) as Sound;	 
		
		[Embed(source='../media/skaterstuck.mp3')] 		 
		private static var SkaterStuck : Class; 		 
		public static var skaterStuck : Sound = (new SkaterStuck) as Sound;	
		
		[Embed(source='../media/skaterstart.mp3')] 		 
		private static var SkaterStart : Class; 		 
		public static var skaterStart : Sound = (new SkaterStart) as Sound;	
		
		[Embed(source='../media/skatersuccess.mp3')] 		 
		private static var SkaterSuccess : Class; 		 
		public static var skaterSuccess : Sound = (new SkaterSuccess) as Sound;	
		
		[Embed(source='../media/zombiedeath.mp3')] 		 
		private static var ZombieDeath : Class; 		 
		public static var zombieDeath : Sound = (new ZombieDeath) as Sound;
	}
	
}