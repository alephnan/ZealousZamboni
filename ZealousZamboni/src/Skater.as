package
{
	import org.flixel.FlxObject;
	import org.flixel.FlxSprite;
	import org.flixel.FlxTilemap;
	import org.flixel.FlxGroup;
	import org.flixel.FlxG;
	
	/**
	 * ...
	 * @author Kenny
	 */
	public class Skater extends ZzUnit
	{
		[Embed(source = '../media/skater.png')] private var skaterPNG:Class;
		
		private var goingLeft:Boolean = false;
		private var goingRight:Boolean = false;
		private var goingUp:Boolean = false;
		private var goingDown:Boolean = false;
		private var isControlled:Boolean = false;
		private var trail:Trail;
		
		public function Skater(X:Number, Y:Number) {
			super(X, Y);
			trail = new Trail();
			//place holder stuff
			//makeGraphic(10,12,0xff1111aa);
			loadGraphic(skaterPNG, true, true, 32, 32, true);
			var o:Number = 0;	//offset for specifying animations
			addAnimation("walkS", [o + 0, o + 1, o + 2, o + 3, o + 4, o + 5, o + 6, o + 7, o + 8, o + 9, o + 10, o + 11], 6, true);
			o = 16;
			addAnimation("walkN", [o + 0, o + 1, o + 2, o + 3, o + 4, o + 5, o + 6, o + 7, o + 8, o + 9, o + 10, o + 11], 6, true);
			o = 32;
			addAnimation("walkW", [o + 0, o + 1, o + 2, o + 3, o + 4, o + 5, o + 6, o + 7, o + 8, o + 9, o + 10, o + 11], 6, true);
			o = 48;
			addAnimation("walkE", [o+0, o+1, o+2, o+3, o+4, o+5, o+6, o+7, o+8, o+9, o+10, o+11], 6, true);
			maxVelocity.x = 80;
			maxVelocity.y = 80;
			drag.x = maxVelocity.x * 4;
			drag.y = maxVelocity.y * 4;
			goingRight = true;
			this.play("walkS", true);
		}
		
		public function getTrail() : Trail {
			return trail;
		}
		
		override public function update() : void {
			if (goingLeft) {
				velocity.x = -maxVelocity.x;
				velocity.y = 0;
				this.play("walkW", false);
			}
			if (goingRight) {
				velocity.x = maxVelocity.x;
				velocity.y = 0;
				this.play("walkE", false);
			}
			if (goingDown) {
				velocity.x = 0;
				velocity.y = maxVelocity.y;
				this.play("walkS", false);
			}
			if (goingUp) {
				velocity.x = 0;
				velocity.y = -maxVelocity.y;
				this.play("walkN", false);
			}
			if(!FlxG.overlap(trail, this))
				trail.addTile(this.getMidpoint().x, this.getMidpoint().y);
		}
		
		
		override public function setNextMove(level:FlxTilemap, entities:FlxGroup) : void {
			
		}
		
		override public function onCollision(other:FlxObject) : void {
			rotate();
		}
		
		public function rotate() : void{
			if (goingLeft) {
				goingLeft = false;
				goingDown = true;
			}else if (goingDown) {
				goingDown = false;
				goingRight = true;
			}else if (goingRight) {
				goingRight = false;
				goingUp = true;
			}else if (goingUp) {
				goingUp = false;
				goingLeft = true;
			}
		}
	}
	
}