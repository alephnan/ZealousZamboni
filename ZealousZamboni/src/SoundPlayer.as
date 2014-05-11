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
		
		/* [Embed(source='../media/zombiedeath.mp3')] 		 
		private static var ZombieDeath : Class; 		 
		public static var zombieDeath : Sound = (new ZombieDeath) as Sound;
		
			delete file media/zombiedeath.mp3 when removing this line
		*/
		
		[Embed(source='../media//zombiedie.mp3')] 		 
		private static var ZombieDeath : Class; 		 
		public static var zombieDeath : Sound = (new ZombieDeath) as Sound;
		
		[Embed(source='../media/zombiehit.mp3')] 		 
		private static var ZombieHit : Class; 		 
		public static var zombieHit : Sound = (new ZombieHit) as Sound;
		
		
		/* @author Tuan
			
			Code below will allow future ability to mute / unmute game sound universally
			
			...................................................................................
			Currently to play sound, SoundPlayer class fields are called in static context:
				SoundPlayer.zombieDeath.play();
			
			We can add a global boolean variable to indicate mute state, and do this throughout the code:
				if (!IS_MUTED) { SoundPlayer.zombieDeath.play(); }
				
			But we'd have to wrap that if statement for every sound played.
			....................................................................................
			
			The methods below allows SoundPlayer to be used in a nonstatic context.
				GLOBAL_SOUND_PLAYER = new SoundPlayer();
					...
				GLOBAL_SOUND_PLAYER.play("skaterDeath"); // SoundPlayer is not mute by default. so sound plays
					...
				GLOBAL_SOUND_PLAYER.mute();
					...
				GLOBAL_SOUND_PLAYER.play("skaterDeath"); // no sound plays
					...
				GLOBAL_SOUND_PLAYER.unmute();
			
			Instantiating a SoundPlayer object encapsulates the mute / unmute state. 
			...........................................................................
			I did not replace lines of statically playing sounds throughout the code.
			If we want to replace them all, we should have one instance of SoundPlayer constructed and held
			in MainGame.as or some other global location. Since the start menu (StartState.as) might have sounds
			and option to mute sound, and not just during the play state
		*/
				
		// Map name of sound to embedded asset
		private static var sounds : Object = {
			"skaterDeath" : skaterDeath,
			"skaterStuck" : skaterStuck,
			"skaterStart" : skaterStart,
			"skaterSuccess" : skaterSuccess,
			"zombieDeath" : zombieDeath
		};

		private var isMuted:Boolean;
		
		public function SoundPlayer() {
			isMuted = false;
		}
		
		public function mute() : void { isMuted = true; }
		
		public function unmute() : void { isMuted = false; }
		
		// play sound iff SoundPlayer is not muted
		public function play(soundName:String) : void {
			if (!isMuted) {
				sounds[soundName].play();
			}
		}
		
	
	}
	
}