package  
{
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.Joints.b2RevoluteJointDef;
	import flash.events.EventDispatcher;
	import flash.display.*;
	import flash.geom.Point;
	/**
	 * ...
	 * @author Kai
	 */
	public class Actor extends EventDispatcher
	{
		protected var _body:b2Body;
		protected var _costume:DisplayObject;
		
		public function Actor(myBody:b2Body, myCostume:DisplayObject) {
			_body = myBody;
			_body.SetUserData(this);
			_costume = myCostume;
			
			updateMyLook();
		}
		
		public function updateNow():void {
			updateMyLook();
			childSpecificUpdating();
		}
		
		protected function childSpecificUpdating():void {
			//expected to be called by my children
		}
		
		public function destroy():void {
			cleanUpBeforeRemoving();
			_costume.parent.removeChild(_costume);
			PhysiVals.world.DestroyBody(_body);
		}
		
		public function getSpriteLoc():Point {
			return new Point(_costume.x, _costume.y);
		}
		
		protected function cleanUpBeforeRemoving():void {
			//will be called by children
		}
		
		private function updateMyLook():void {
			_costume.x = _body.GetPosition().x * PhysiVals.RATIO;
			_costume.y = _body.GetPosition().y * PhysiVals.RATIO;
			_costume.rotation = _body.GetAngle() * 180 / Math.PI;
		}
		
	}

}