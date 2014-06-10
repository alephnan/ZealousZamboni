package  
{
	import flash.display3D.textures.RectangleTexture;
	import mx.core.FlexSprite;
	import org.flixel.*
	import org.flixel.system.FlxTile;
	/**
	 * ...
	 * @author Dana Van Aken
	 */
	public class Tutorial extends FlxGroup
	{
		public static const IN_FIRST_ROOM:uint = 0;
		public static const IN_SECOND_ROOM:uint = 1;
		public static const IN_THIRD_ROOM:uint = 2;
		public static const IN_FOURTH_ROOM:uint = 3;
		public static const NUM_ROOMS:uint = 4;
		public static const NUM_SKATERS:uint = 2;
		
		private static const doorsStr:String = "11,31,8,4|37,38,4,8|56,33,8,4";
		private static const roomsStr:String = "3,11,44,24|3,35,38,20|41,33,29,22|49,11,21,22";
		private static const respawnPts:Array = new Array(new FlxPoint(112, 288),
														  new FlxPoint(56,  368),
														  new FlxPoint(112, 368),
														  new FlxPoint(216, 312),
														  new FlxPoint(216, 392),
														  new FlxPoint(392, 168),
														  new FlxPoint(512, 168),
														  new FlxPoint(448, 168));
		private static const respawnDirs:Array = new Array("walkE", "walkE", "walkE", "walkS", 
														   "walkN", "walkE", "walkW", "walkE");
		private static const playerSaveSkaterPit:FlxPoint = new FlxPoint(480, 312);
		
		private static const NUM_INTRO_CALLOUTS:uint = 5;
		private static const CALLOUTS:Array = new Array("Complete the level\n   before the timer\n  runs out!",
														"Earn mini-stars\nwhen you clear\nbad ice!",
														"   You win if you\nearn enough big stars\n before the timer\n   runs out!",
														"Use the reset\nbutton if you think\nyou cannot win!",
														"",
														"BEWARE of the\n    thin ice!",
														"  The bar above\nthe skater indicates\n  its time left on\n   the ice!",
														"500 mini stars\nearns 1 big star",
														"When skaters get\n stuck on bad ice,\n  they sink",
														"A skater will\ntry to turn left\nif it can't go\nstraight",
														"Save the skater\nfrom sinking!", 
														"Block the skater\nfrom skating into\nthe lake!",
														"You get 1 gold\nstar for each\nskater that lives!");
												
		
		public static var TIMER_ALERT:Boolean = false;
		public static const TIMER_ALERT_INDEX:uint = 0;
		
		public static var TRAIL_ALERT:Boolean = false;
		public static const TRAIL_ALERT_INDEX:uint = 1;
		
		public static var GOAL_ALERT:Boolean = false;
		public static const GOAL_ALERT_INDEX:uint = 2;
		
		public static var RESET_ALERT:Boolean = false;
		public static const RESET_ALERT_INDEX:uint = 3;
		
		public static var CONTROLS_ALERT:Boolean = false;
		public static const CONTROLS_ALERT_INDEX:uint = 4;
		
		
		private static var MOUSE_ALERT:Boolean = false;
		private static const MOUSE_ALERT_ID:uint = 12;
		
		public static var PIT_ALERT:Boolean = false;
		public static const PIT_ALERT_INDEX:uint = 5;
		
		public static var SKATER_BAR_ALERT:Boolean = false;
		public static const SKATER_BAR_ALERT_INDEX:uint = 6;
		
		private static var CONVERSION_ALERT:Boolean = false;
		private static const CONVERSION_ALERT_INDEX:uint = 7;
		
		public static var SKATER_STUCK_ALERT:Boolean = false;
		public static const SKATER_STUCK_INDEX:uint = 8;

		public static var SKATER_TURN_ALERT:Boolean = false;
		public static const SKATER_TURN_INDEX:uint = 9;
		
		public static var SAVE_SKATER_STUCK_ALERT:Boolean = false;
		public static const SAVE_SKATER_STUCK_INDEX:uint = 10;
		
		public static var SAVE_SKATER_PIT_ALERT:Boolean = false;
		public static const SAVE_SKATER_PIT_INDEX:uint = 11;
		
		public static var SKATER_FINISHES_ALERT:Boolean = false;
		public static const SKATER_FINISHES_INDEX:uint = 12;

		public var currentRoom:uint;
		public var doors:Array;
		public var rooms:Array;
		public var level:FlxTilemap;
		public var player:Zamboni;
		private var respawning:Boolean;
		private var firstSkaterStarted:Boolean;
		private var secondSkaterStarted:Boolean;
		private var skatersComplete:uint;
		private var test:Boolean = false;
		private var calloutText:FlxText;
		private var calloutIndex:uint;
		private var calloutSprite:FlxSprite;
		private var calloutButton:FlxButton;
		private var glow:FlxSprite;
		private var skipTxt:FlxText;
		private var blinkTimer:ZzTimer;
		private var blinkObj:FlxObject;
		
		private var door1Open:Boolean;
		private var door2Open:Boolean;
		private var door3Open:Boolean;
		
		public function Tutorial(level:FlxTilemap) {
			super();
			this.currentRoom = 0;
			this.rooms = ZzUtils.parseRects(roomsStr);
			this.doors = ZzUtils.parseRects(doorsStr);
			this.level = level;
			this.player = PlayState(FlxG.state).player;
			this.respawning = false;
			this.firstSkaterStarted = false;
			this.secondSkaterStarted = false;
			this.skatersComplete = 0;
			this.door1Open = false;
			this.door2Open = false;
			this.door3Open = false;
			for (var i:uint = 0; i < doors.length; ++i) {
				closeDoor(doors[i]);
			}
			calloutSprite = new FlxSprite(80, 45, Media.calloutPng);
			calloutButton = new FlxButton(0, 0, null, onClick);
			calloutButton.loadGraphic(Media.goArrowPNG);
			calloutButton.scale = new FlxPoint(.5, .5);
			calloutButton.width *= .5;
			calloutButton.health *= .5;
			calloutButton.centerOffsets(true);
			skipTxt = new FlxText(FlxG.width / 2 - 150, FlxG.height - 35, 300, "Press Enter to Continue", true);
			skipTxt.setFormat("coolvetica", 20, 0x000000, "center");
			add(skipTxt);
			add(calloutSprite);
			add(calloutButton);
			calloutIndex = 0;
			this.setAll("exists", false, false);
			blinkTimer = new ZzTimer();
		}
		
		
		private function callout(objectXY:FlxPoint = null):void {
			var calloutTextWidth:uint = 0;
			if (objectXY == null)
				objectXY = player.getScreenXY();
			/* Level Timer */
			if (calloutIndex == TIMER_ALERT_INDEX) {
				trace("Timer");
				calloutSprite.x -= 30;
				calloutSprite.y += 10;
				calloutTextWidth = 20 * CALLOUTS[calloutIndex].length;
				calloutText = new FlxText(calloutSprite.getMidpoint().x - (CALLOUTS[calloutIndex].length) - 22, 
						calloutSprite.getMidpoint().y - 15, 
						calloutTextWidth, CALLOUTS[calloutIndex], true);
				calloutText.setFormat("coolvetica", 20, 0x000000);
				add(calloutText);
				calloutButton.x = calloutText.x + CALLOUTS[calloutIndex].length + 40;
				calloutButton.y = calloutText.y + 25;
				setExists(true);
				calloutIndex++;
			
			/* Mini-stars and trail tiles */
			} else if (calloutIndex == TRAIL_ALERT_INDEX) {
				calloutSprite.loadGraphic(Media.calloutPng);
				calloutSprite.x = ZzHUD.smallStarXY.x - calloutSprite.x / 2 + 5;
				calloutSprite.y = ZzHUD.smallStarXY.y + 30;
				checkCoords(calloutSprite);
				calloutTextWidth = 20 * CALLOUTS[calloutIndex].length;
				calloutText = new FlxText(calloutSprite.getMidpoint().x - (CALLOUTS[calloutIndex].length) - 35, 
						calloutSprite.getMidpoint().y - 15, 
						calloutTextWidth, CALLOUTS[calloutIndex], true);
				calloutText.setFormat("coolvetica", 20, 0x000000);
				add(calloutText);
				calloutButton.x = calloutText.x + CALLOUTS[calloutIndex].length + 30;
				calloutButton.y = calloutText.y + 32;
				var blueStars:FlxSprite = new FlxSprite(calloutSprite.getMidpoint().x + 40, 
						calloutSprite.getMidpoint().y - 10, Media.smallStarIconPng);
				blueStars.scale = new FlxPoint(.8, .8);
				add (blueStars);
				setExists(true);
				calloutIndex++;
				
			/* Player goal and gold stars */
			} else if (calloutIndex == GOAL_ALERT_INDEX) {
				calloutSprite.loadGraphic(Media.calloutPng) + 30;
				calloutSprite.x = ZzHUD.bigStarXY.x - 5;
				calloutSprite.y = ZzHUD.bigStarXY.y + 25;
				checkCoords(calloutSprite);
				calloutTextWidth = 20 * CALLOUTS[calloutIndex].length;
				calloutText = new FlxText(calloutSprite.getMidpoint().x - (CALLOUTS[calloutIndex].length) - 9, 
						calloutSprite.getMidpoint().y - 28, 
						calloutTextWidth, CALLOUTS[calloutIndex], true);
				calloutText.setFormat("coolvetica", 20, 0x000000);
				add(calloutText);
				calloutButton.x = calloutText.x + CALLOUTS[calloutIndex].length + 25;
				calloutButton.y = calloutText.y + 44;
				setExists(true);
				calloutIndex++;
			
			/* Use reset when you think you are losing */
			} else if (calloutIndex == RESET_ALERT_INDEX) {
				calloutSprite.loadGraphic(Media.calloutBackwardLeftPng);
				calloutSprite.x = calloutSprite.width / 2 + calloutSprite.width + 60;
				calloutSprite.y = calloutSprite.height / 2  - 40;
				checkCoords(calloutSprite);
				calloutTextWidth = 20 * CALLOUTS[calloutIndex].length;
				calloutText = new FlxText(calloutSprite.getMidpoint().x - (CALLOUTS[calloutIndex].length) - 20, 
						calloutSprite.getMidpoint().y - 24, 
						calloutTextWidth, CALLOUTS[calloutIndex], true);
				calloutText.setFormat("coolvetica", 20, 0x000000);
				add(calloutText);
				calloutButton.x = calloutText.x + CALLOUTS[calloutIndex].length - 2;
				calloutButton.y = calloutText.y + 43;
				setExists(true);
				calloutIndex++;
			
			/* Mouse, WASD, arrow keys */
			} else if (calloutIndex == CONTROLS_ALERT_INDEX) {
				calloutSprite.loadGraphic(Media.calloutControlsPng);
				calloutSprite.x = objectXY.x + calloutSprite.width / 4 - 30;
				calloutSprite.y = objectXY.y - calloutSprite.height / 4 + 60;
				calloutButton.x = calloutSprite.getMidpoint().x + 20;
				calloutButton.y = calloutSprite.getMidpoint().y + 10;
				setExists(false);
				calloutIndex++;
			
			/* Using space bar to follow mouse */
			} else if (calloutIndex == MOUSE_ALERT_ID) {
				calloutSprite.loadGraphic(Media.calloutMousePng);
				calloutSprite.x = player.x + 25;
				calloutSprite.y = player.y + player.height - 5;
				checkCoords(calloutSprite);
				calloutButton.x = calloutSprite.getMidpoint().x + 40;
				calloutButton.y = calloutSprite.getMidpoint().y - 5;
				setExists(false);
			
			/* Pitfalls */
			} else if (calloutIndex == PIT_ALERT_INDEX) {
				calloutSprite.loadGraphic(Media.calloutPng);
				calloutSprite.x = objectXY.x;
				calloutSprite.y = objectXY.y;
				checkCoords(calloutSprite);
				calloutTextWidth = 20 * CALLOUTS[calloutIndex].length;
				calloutText = new FlxText(calloutSprite.getMidpoint().x - (CALLOUTS[calloutIndex].length) - 30, 
						calloutSprite.getMidpoint().y - 15, 
						calloutTextWidth, CALLOUTS[calloutIndex], true);
				calloutText.setFormat("coolvetica", 20, 0x000000);
				add(calloutText);
				calloutButton.x = calloutText.x + CALLOUTS[calloutIndex].length + 5;
				calloutButton.y = calloutText.y + 30;
				setExists(true);
				
			/* Skater progress bar */
			} else if (calloutIndex == SKATER_BAR_ALERT_INDEX) {
				calloutSprite.loadGraphic(Media.calloutLeftPng);
				calloutSprite.x = objectXY.x - calloutSprite.width / 2 - 60;
				calloutSprite.y = objectXY.y - calloutSprite.height - 18;
				checkCoords(calloutSprite);
				calloutTextWidth = 20 * CALLOUTS[calloutIndex].length;
				calloutText = new FlxText(calloutSprite.getMidpoint().x - (CALLOUTS[calloutIndex].length) - 10, 
						calloutSprite.getMidpoint().y - 60, 
						calloutTextWidth, CALLOUTS[calloutIndex], true);
				calloutText.setFormat("coolvetica", 20, 0x000000);
				add(calloutText);
				calloutButton.x = calloutText.x + CALLOUTS[calloutIndex].length + 10;
				calloutButton.y = calloutText.y + 48;
				setExists(true);
				
			/* Small to big star conversion */
			} else if (calloutIndex == CONVERSION_ALERT_INDEX) {
				calloutSprite.loadGraphic(Media.calloutPng);
				calloutSprite.x = objectXY.x- player.width / 2 - calloutSprite.width / 2;
				calloutSprite.y = objectXY.y - player.height / 2 - calloutSprite.height / 2;
				checkCoords(calloutSprite);
				calloutTextWidth = 20 * CALLOUTS[calloutIndex].length;
				calloutText = new FlxText(calloutSprite.getMidpoint().x - (CALLOUTS[calloutIndex].length) - 30, 
						calloutSprite.getMidpoint().y - 15, 
						calloutTextWidth, CALLOUTS[calloutIndex], true);
				calloutText.setFormat("coolvetica", 20, 0x000000);
				add(calloutText);
				calloutButton.x = calloutText.x + CALLOUTS[calloutIndex].length + 5;
				calloutButton.y = calloutText.y + 30;
				setExists(true);
				
			/* Skater stuck */
			} else if (calloutIndex == SKATER_STUCK_INDEX) {
				calloutSprite.loadGraphic(Media.calloutLeftPng);
				calloutSprite.x = objectXY.x - calloutSprite.width / 2 - 60;
				calloutSprite.y = objectXY.y - calloutSprite.height - 18;
				checkCoords(calloutSprite);
				calloutTextWidth = 20 * CALLOUTS[calloutIndex].length;
				calloutText = new FlxText(calloutSprite.getMidpoint().x - (CALLOUTS[calloutIndex].length) - 20, 
						calloutSprite.getMidpoint().y - 47, 
						calloutTextWidth, CALLOUTS[calloutIndex], true);
				calloutText.setFormat("coolvetica", 20, 0x000000);
				add(calloutText);
				calloutButton.x = calloutText.x + CALLOUTS[calloutIndex].length + 15;
				calloutButton.y = calloutText.y + 46;
				setExists(true);
				
			/* Skaters try to turn left */
			} else if (calloutIndex == SKATER_TURN_INDEX) {
				calloutSprite.loadGraphic(Media.calloutLeftPng);
				checkCoords(calloutSprite);
				calloutTextWidth = 20 * CALLOUTS[calloutIndex].length;
				calloutText = new FlxText(calloutSprite.getMidpoint().x - (CALLOUTS[calloutIndex].length) - 10, 
						calloutSprite.getMidpoint().y - 55, 
						calloutTextWidth, CALLOUTS[calloutIndex], true);
				calloutText.setFormat("coolvetica", 20, 0x000000);
				add(calloutText);
				calloutButton.x = calloutText.x + CALLOUTS[calloutIndex].length + 10;
				calloutButton.y = calloutText.y + 42;
				setExists(true);
				
			/* Try to save a stuck skater */
			} else if (calloutIndex == SAVE_SKATER_STUCK_INDEX) {
				calloutSprite.loadGraphic(Media.calloutLeftPng);
				checkCoords(calloutSprite);
				calloutTextWidth = 20 * CALLOUTS[calloutIndex].length;
				calloutText = new FlxText(calloutSprite.getMidpoint().x - (CALLOUTS[calloutIndex].length) - 23, 
						calloutSprite.getMidpoint().y - 50, 
						calloutTextWidth, CALLOUTS[calloutIndex], true);
				calloutText.setFormat("coolvetica", 20, 0x000000);
				add(calloutText);
				calloutButton.x = calloutText.x + CALLOUTS[calloutIndex].length + 12;
				calloutButton.y = calloutText.y + 58;
				setExists(true);
				
			/* Block skater from falling into a pit */
			} else if (calloutIndex == SAVE_SKATER_PIT_INDEX) {
				calloutSprite.loadGraphic(Media.calloutLeftPng);
				calloutSprite.x += 10;
				calloutSprite.y -= 15;
				checkCoords(calloutSprite);
				calloutTextWidth = 20 * CALLOUTS[calloutIndex].length;
				calloutText = new FlxText(calloutSprite.getMidpoint().x - (CALLOUTS[calloutIndex].length) - 35, 
						calloutSprite.getMidpoint().y - 46, 
						calloutTextWidth, CALLOUTS[calloutIndex], true);
				calloutText.setFormat("coolvetica", 20, 0x000000);
				add(calloutText);
				calloutButton.x = calloutText.x + CALLOUTS[calloutIndex].length + 20;
				calloutButton.y = calloutText.y + 40;
				setExists(true);
			
			/* Skater completes and you earn a gold star */
			} else if (calloutIndex == SKATER_FINISHES_INDEX) {
				calloutSprite.loadGraphic(Media.calloutLeftPng);
				//calloutSprite.x += 10;
				//calloutSprite.y -= 15;
				checkCoords(calloutSprite);
				calloutTextWidth = 20 * CALLOUTS[calloutIndex].length;
				calloutText = new FlxText(calloutSprite.getMidpoint().x - (CALLOUTS[calloutIndex].length) - 35, 
						calloutSprite.getMidpoint().y - 46, 
						calloutTextWidth, CALLOUTS[calloutIndex], true);
				calloutText.setFormat("coolvetica", 20, 0x000000);
				add(calloutText);
				calloutButton.x = calloutText.x + CALLOUTS[calloutIndex].length + 20;
				calloutButton.y = calloutText.y + 40;
				setExists(true);
			}
			
			PlayState(FlxG.state).pause();
		}
		
		private function setExists(textExists:Boolean):void {
			if (textExists)
				calloutText.exists = true;
			calloutSprite.exists = true;
			calloutButton.exists = true;
			skipTxt.exists = true;
		}
		
		public function handlePitCallout():void {
			// Should be checked but check again just in case
			if (!FlxG.paused && !PIT_ALERT) {
				PIT_ALERT = true;
				calloutIndex = PIT_ALERT_INDEX;
				callout(player.getScreenXY());
			}
		}
		
		public function handleConversionCallout():void {
			// Should be checked but check again just in case
			if (!FlxG.paused && !CONVERSION_ALERT) {
				CONVERSION_ALERT = true;
				calloutIndex = CONVERSION_ALERT_INDEX;
				callout(player.getScreenXY());
			}
		}
		
		public function handleSkaterCallout(alert:Boolean, skater:Skater):void {
			// Should be checked but check again just in case
			if (!FlxG.paused) {
				if (!SKATER_BAR_ALERT && alert == SKATER_BAR_ALERT) {
					SKATER_BAR_ALERT = true;
					calloutIndex = SKATER_BAR_ALERT_INDEX;
					callout(skater.getScreenXY());
				} else if (!SKATER_STUCK_ALERT && alert == SKATER_STUCK_ALERT) {
					SKATER_STUCK_ALERT = true;
					calloutIndex = SKATER_STUCK_INDEX;
					callout(skater.getScreenXY());
				}
			}
		}
		
		private function checkCoords(object:FlxObject):void {
			object.x = (object.x < 5) ? 5 : object.x;
			object.x = (object.x > FlxG.width - object.width) ? FlxG.width - object.width : object.x;
			object.y = (object.y < 5) ? 5 : object.y;
			object.y = (object.y > FlxG.height - object.height) ? FlxG.height - object.height : object.y;
		}
		
		private function onClick():void {
			if (FlxG.paused) {
				this.setAll("exists", false, false);
				if (calloutIndex == SKATER_BAR_ALERT_INDEX && !SKATER_TURN_ALERT) {
					SKATER_TURN_ALERT = true;
					calloutIndex = SKATER_TURN_INDEX;
					callout();
				} else if (calloutIndex == SKATER_STUCK_INDEX && !SAVE_SKATER_STUCK_ALERT) {
					SAVE_SKATER_STUCK_ALERT = true;
					calloutIndex = SAVE_SKATER_STUCK_INDEX;
					callout();
				} else {
					if (calloutIndex == SAVE_SKATER_PIT_INDEX) {
						glow = createGlow(new FlxRect(456, 304, 64, 32));
						glow.flicker(1);
					}
					PlayState(FlxG.state).unpause();
					trace("unpaused!");
				}
			}
		}

		
		override public function update():void {
			if (!FlxG.paused && calloutIndex > NUM_INTRO_CALLOUTS - 1) {
				var playerRect:FlxRect = new FlxRect(player.x/8, player.y/8, 8, 4);
				if (!respawning && !player.alive) {
					respawning = true;
					respawnPlayer();
					respawning = false;
				}
				switch(currentRoom) {
					case IN_FIRST_ROOM:
						if (!iceTileLeft(rooms[IN_FIRST_ROOM])) {
							openDoor(doors[currentRoom++]);
							door1Open = true;
						}
						break;
					case IN_SECOND_ROOM:
						if (door1Open && !playerRect.overlaps(rooms[IN_FIRST_ROOM])) {
							closeDoor(doors[IN_FIRST_ROOM]);
							door1Open = false;
						}
						if (!iceTileLeft(rooms[IN_SECOND_ROOM])) {
							openDoor(doors[currentRoom++]);
							SkaterQueue(PlayState(FlxG.state).activeSprites[PlayState.SKATERS_INDEX]).startTutorialSkater(null);
							door2Open = true;
						}
						if (!MOUSE_ALERT && FlxG.mouse.pressed()) {
							MOUSE_ALERT = true;
							calloutIndex = MOUSE_ALERT_ID;
							callout();
						}
						break;
					case IN_THIRD_ROOM:
						if (door2Open && !playerRect.overlaps(rooms[IN_SECOND_ROOM])) {
							closeDoor(doors[IN_SECOND_ROOM]);
							door2Open = false;
						}
						if (skatersComplete == 1 && !iceTileLeft(rooms[IN_THIRD_ROOM])) {
							openDoor(doors[currentRoom++]);
							door3Open = true;
						}
						break;
					case IN_FOURTH_ROOM:
						if (!SAVE_SKATER_PIT_ALERT) {
							SAVE_SKATER_PIT_ALERT = true;
							calloutIndex = SAVE_SKATER_PIT_INDEX;
							callout(player.getScreenXY());
						} else if (skatersComplete >= 2 && PlayState(FlxG.state).playerPoints.checkWin()) {
							PlayState(FlxG.state).endLevel();
						} else if (SAVE_SKATER_PIT_ALERT && glow != null && glow.exists) {
							if (player.overlapsPoint(playerSaveSkaterPit)) {
								SkaterQueue(PlayState(FlxG.state).activeSprites[PlayState.SKATERS_INDEX]).startTutorialSkater(null);
								glow.kill();
								//glow = null;
							} else {
								glow.flicker(3);
							}
						}
						break;
					default:
						break;
				}
			} else if (!FlxG.paused) {
				callout();
			}
			// player wants to skip screen, stop timer, and immediately go to next level
			if (FlxG.keys.justPressed("ENTER")) {
				onClick();
			}
			super.update();
		}
		
		private function respawnPlayer():void {
			var minDist:Number = FlxG.width * FlxG.height;
			var minIndex:uint = respawnPts.length;
			var curPt:FlxPoint = player.getMidpoint();
			
			for (var i:uint = 0; i < respawnPts.length; ++i) {
				var dist:Number = FlxU.getDistance(curPt, respawnPts[i]);
				if (dist < minDist) {
					minDist = dist;
					minIndex = i;
				}
			}
			player.resetZamboni(respawnPts[minIndex].x, respawnPts[minIndex].y, respawnDirs[minIndex]);
		}
		
		public function iceTileLeft(rect:FlxRect):Boolean {
			for (var i:uint = 0; i < rect.height; ++i) {
				for (var j:uint = 0; j < rect.width; ++j) {
					if (LevelLoader.isTrail(level.getTile(rect.x + j, rect.y + i))) {
						return true;
					}
				}
			}
			return false;
		}
		
		public function skaterComplete():void {
			skatersComplete++;
			if (!SKATER_FINISHES_ALERT) {
				SKATER_FINISHES_ALERT = true;
				this.calloutIndex = SKATER_FINISHES_INDEX;
				callout(player.getScreenXY());
			}
		}
		
		public function openDoor(rect:FlxRect):void {
			var ice:uint = 0;
			for (var i:uint = 0; i < rect.height; ++i) {
				for (var j:uint = 0; j < rect.width; ++j) {
					level.setTile(rect.x + j, rect.y + i, i * level.widthInTiles + j, true);
				}
			}
		}
		
		public function closeDoor(rect:FlxRect):void {
			var doorStart:uint = 7776;
			for (var i:uint = 0; i < rect.height; ++i) {
				var door:uint = doorStart + ((i % 4) * level.widthInTiles);
				for (var j:uint = 0; j < rect.width; ++j) {
					level.setTile(rect.x + j, rect.y + i, door + (j % 4), true);
				}
			}
		}
		
		public function createGlow(rect:FlxRect):FlxSprite
		{
			var glow:FlxSprite = new FlxSprite(rect.x, rect.y);
			glow.makeGraphic(rect.width, rect.height, 0xffffffff);
			glow.alpha = 0.5;
			add(glow);
			return glow;
		}
	}

}