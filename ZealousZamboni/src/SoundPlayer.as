package 
{
	import adobe.utils.ProductManager;
	import flash.events.Event;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import org.as3commons.collections.utils.ArrayUtils;
	/**
	 * ...
	 * @author Kenny
	 */
	public class SoundPlayer 
	{
		/* 
		[Embed(source='../media/skaterdeath.mp3')] 		 
		private static var SkaterDeath : Class; 		 
		public static var skaterDeath : Sound = (new SkaterDeath) as Sound;	 */
		
		/* [Embed(source='../media/skaterstuck.mp3')] 		 
		private static var SkaterStuck : Class; 		 
		public static var skaterStuck : Sound = (new SkaterStuck) as Sound; */
		
		/*
		[Embed(source='../media/skaterstart.mp3')] 		 
		private static var SkaterStart : Class; 		 
		public static var skaterStart : Sound = (new SkaterStart) as Sound;	*/
		
		/*[Embed(source='../media/skatersuccess.mp3')] 		 
		private static var SkaterSuccess : Class; 		 
		public static var skaterSuccess : Sound = (new SkaterSuccess) as Sound;*/
		
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
		
		[Embed(source='../media/soundeffects/two.mp3')] 		 
		private static var SkaterStuck : Class; 		 
		public static var skaterStuck : Sound = (new SkaterStuck) as Sound;	
				
		[Embed(source='../media/soundeffects/three.mp3')] 		 
		private static var SkaterStart : Class; 		 
		public static var skaterStart : Sound = (new SkaterStart) as Sound;

		[Embed(source='../media/soundeffects/ten.mp3')] 		 
		private static var SkaterSuccess : Class; 		 
		public static var skaterSuccess : Sound = (new SkaterSuccess) as Sound;

		[Embed(source='../media/soundeffects/five.mp3')] 		 
		private static var SkaterDeath : Class; 		 
		public static var skaterDeath : Sound = (new SkaterDeath) as Sound;
		
		[Embed(source='../media/soundtracks/soundtrack_1.mp3')] 		 
		private static var SoundtrackOne : Class; 		 
		public static var soundtrackOne : Sound = (new SoundtrackOne) as Sound;
		
		[Embed(source='../media/soundtracks/soundtrack_2.mp3')] 		 
		private static var SoundtrackTwo : Class; 		 
		public static var soundtrackTwo : Sound = (new SoundtrackTwo) as Sound;
		
		[Embed(source='../media/soundtracks/soundtrack_3.mp3')] 		 
		private static var SoundtrackThree : Class; 		 
		public static var soundtrackThree : Sound = (new SoundtrackThree) as Sound;
		
		[Embed(source='../media/soundeffects/fall.mp3')] 		 
		private static var Fall : Class; 		 
		public static var fall : Sound = (new Fall) as Sound;
		
		private var soundSettings: SoundTransform;
		private var playlistSoundSetting : SoundTransform;
		
		// Map name of sound to embedded asset
		private static var sounds : Object = {
			"skaterDeath" : skaterDeath,
			"skaterStuck" : skaterStuck,
			"skaterStart" : skaterStart,
			"skaterSuccess" : skaterSuccess,
			"zombieDeath" : zombieDeath,
			"zombieHit" : zombieHit,
			"fall" : fall
		};
		
		private static var playlist : Array = new Array(
			soundtrackOne,
			soundtrackTwo,
			soundtrackThree
		);
		
		private var playlistIndex:int;
		private var currentSong:SoundChannel;
		
		private var isMuted:Boolean;
		
		public function SoundPlayer() {
			isMuted = false;
			soundSettings = new SoundTransform();
			soundSettings.volume = 1;
			playlistSoundSetting = new SoundTransform();
			playlistSoundSetting.volume = .25;
			
			playlistIndex = 0;
		}
		
		public function mute() : void {
			isMuted = true;
			
			currentSong.stop();
			playlist[playlistIndex].removeEventListener(Event.SOUND_COMPLETE, nextSong);
			playlistIndex = 0;
		}
		
		public function unmute() : void {
			isMuted = false;
		
			startPlaylist();
		}
		
		public function isMute () : Boolean {
			return this.isMuted;
		}
		
		public function startPlaylist() : void { 
			if (playlist.length > 0) {
				if (!isMuted) {
					var currSong : SoundChannel = playlist[0].play( 0, 0, playlistSoundSetting);
					currSong.addEventListener(Event.SOUND_COMPLETE, nextSong);
					
					currentSong = currSong;
				}
			}
		}
	
		private function nextSong(e:Event) : void {
			e.currentTarget.removeEventListener(Event.SOUND_COMPLETE, nextSong);
			currentSong.stop();
			
			// loop back to beginning song
			playlistIndex = playlistIndex + 1 == playlist.length ? 0 : playlistIndex + 1;
			var currSong : SoundChannel = playlist[playlistIndex].play( 0, 0, playlistSoundSetting);
			currentSong = currSong;
			
			currSong.addEventListener(Event.SOUND_COMPLETE, nextSong);
			
		}

		// play sound iff SoundPlayer is not muted
		public function play(soundName:String = null, startTime:Number = 0, loops:int = 0) : SoundChannel {

			if (!isMuted) {
				return sounds[soundName].play(startTime, loops , soundSettings);
			}
			
			return null;
			
			//skaterSuccess.pla
		}	
		
		// returns length of soundName
		public function length(soundName:String ) : Number {
			if (sounds[soundName] != null) {
				return sounds[soundName].length;
			} else {
				return -1;
			}
		}
		
		
	}
}