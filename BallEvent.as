package  
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Kai
	 */
	public class BallEvent extends Event 
	{
		public static const BALL_OFF_SCREEN:String = "BallOffScreen";
		public static const BALL_HIT_BONUS:String = "BallHitBonus";
		
		public function BallEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			
		} 
		
		public override function clone():Event 
		{ 
			return new BallEvent(type, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("BallEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}