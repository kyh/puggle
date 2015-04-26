package  
{
	import com.greensock.TweenLite
	/**
	 * ...
	 * @author Kai
	 */
	public class TimeMaster 
	{
		private var _frameRate:int
		
		public function TimeMaster() {
			_frameRate = PhysiVals.FRAME_RATE;
		}
		
		public function getTimeStep():Number {
			return (1.0 / _frameRate);
		}
		
		public function slowDown():void {
			TweenLite.to(this, 0.5, { frameRate: PhysiVals.FRAME_RATE * 5 } );
		}
		
		public function backToNormal():void {
			TweenLite.to(this, 0.5, { frameRate: PhysiVals.FRAME_RATE } );
		}
		
		public function get frameRate():int 
		{
			return _frameRate;
		}
		
		public function set frameRate(value:int):void 
		{
			_frameRate = value;
		}
		
	}

}