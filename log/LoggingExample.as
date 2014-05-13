package
{
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	
	public class CapstoneLogging extends Sprite
	{
		private var logger:Logger;
		private var score:int;
		
		public function CapstoneLogging()
		{
			logger = new Logger("game_name",1,"skey",1,1);
			score = 0;
			stage.addEventListener(KeyboardEvent.KEY_DOWN, logEvent);
		}
		
		private function logEvent(keyEvent:KeyboardEvent):void {
			switch(keyEvent.keyCode) {
				case 13:
					// Pressed ENTER = Level Start
					trace("enter, starting level");
					logger.logLevelStart(2,null);
					break;
				
				case 8:
					// Pressed BACKSPACE = Level End
					trace("delete, ending level");
					logger.logLevelEnd(null);
					break;
				
				case 49:
					// Pressed 1 = 1 Point
					trace("1, logging 1");
					score = score + 1;
					var data1:Object = {"keypressed":"1","score":score};
					logger.logAction(1, data1);
					break;
				
				case 50:
					// Pressed 2 = 2 Points
					trace("2, logging 2");
					score = score + 2;
					var data2:Object = {"keypressed":"2","score":score};
					logger.logAction(2, data2);
					break;
				
				case 51:
					// Pressed 3 = 3 Points
					trace("3, logging 3");
					score = score + 3;
					var data3:Object = {"keypressed":"3","score":score};
					logger.logAction(3, data3);
					break;
			}
		}
	}
}