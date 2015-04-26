package  
{
	import flash.display.Sprite;
	import flash.geom.Point;
	/**
	 * ...
	 * @author Kai
	 */
	public class AimingLine extends Sprite
	{
		private var _gravityInMeters:Number;
		
		public function AimingLine(gravityInMeters:Number) {
			_gravityInMeters = gravityInMeters;
		}
		
		public function showLine(startPoint:Point, direction:Point, velocityInPixels:Number):void {
			//vector our ball travels in
			var velocityVect:Point = direction.clone();
			velocityVect.normalize(velocityInPixels);  //our velocity length in pixels/second
			var gravityInPixels = _gravityInMeters * PhysiVals.RATIO;
			var stepPoint:Point = startPoint.clone();
			
			this.graphics.clear();
			this.graphics.lineStyle(12, 0x00FF00, .4);
			this.graphics.moveTo(stepPoint.x, stepPoint.y);
			
			//steps per second to draw
			var granularity:Number = 30;
			for (var i:int = 0; i < granularity; i++) {
				velocityVect.y += gravityInPixels / granularity;
				stepPoint.x += velocityVect.x / granularity;
				stepPoint.y += velocityVect.y / granularity;
				
				this.graphics.lineTo(stepPoint.x, stepPoint.y);
			}
		}
		
		public function hide():void {
			this.graphics.clear();
		}
		
	}

}