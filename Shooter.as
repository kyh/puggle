package  
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	/**
	 * ...
	 * @author Kai
	 */
	public class Shooter extends Sprite
	{
		private const BALL_OFFSET:Point = new Point(82, 0);
		
		public function Shooter() {
			this.addEventListener(Event.ENTER_FRAME, alignToMouse);
		}
		
		private function alignToMouse(e:Event):void {
			var mouseAngle:Number = Math.atan2(this.stage.mouseY - this.y, this.stage.mouseX - this.x) * 180 / Math.PI;
			this.rotation = mouseAngle;
		}
		
		public function getLaunchPosition():Point {
			return(localToGlobal(BALL_OFFSET));
		}
		
	}

}