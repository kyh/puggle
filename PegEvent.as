package  
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Kai
	 */
	public class PegEvent extends Event 
	{
		public static const PEG_LIT_UP:String = "PegLitUp";
		public static const DONE_FADING_OUT:String = "DoneFadingOut";
		
		public function PegEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			
		} 
		
		public override function clone():Event 
		{ 
			return new PegEvent(type, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("PegEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}