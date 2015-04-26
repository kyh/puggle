package  
{
	import Box2D.Collision.b2ContactPoint;
	import Box2D.Common.b2Settings;
	import Box2D.Dynamics.b2ContactListener;
	/**
	 * ...
	 * @author Kai
	 */
	public class PuggleContactListener extends b2ContactListener
	{
		
		public function PuggleContactListener() 
		{
			
		}
		
		override public function Add(point:b2ContactPoint):void 
		{
			trace ("Pow!");
			if (point.shape1.GetBody().GetUserData() is PegActor && point.shape2.GetBody().GetUserData() is BallActor) {
				PegActor(point.shape1.GetBody().GetUserData()).hitByBall();
			} else if (point.shape1.GetBody().GetUserData() is BallActor && point.shape2.GetBody().GetUserData() is PegActor) {
				PegActor(point.shape2.GetBody().GetUserData()).hitByBall();
			} else if (point.shape1.GetUserData() is String &&
					   String(point.shape1.GetUserData()) == BonusChuteActor.BONUS_TARGET &&
					   point.shape2.GetBody().GetUserData() is BallActor) {
						   BallActor(point.shape2.GetBody().GetUserData()).hitBonusTarget();
			} else if (point.shape2.GetUserData() is String &&
					   String(point.shape2.GetUserData()) == BonusChuteActor.BONUS_TARGET &&
					   point.shape1.GetBody().GetUserData() is BallActor) {
						   BallActor(point.shape1.GetBody().GetUserData()).hitBonusTarget();
			}
					   
			super.Add(point);
		}
		
	}

}