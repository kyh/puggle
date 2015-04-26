package  
{
	import Box2D.Collision.Shapes.b2CircleDef;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.geom.Point;
	/**
	 * ...
	 * @author Kai
	 */
	public class BallActor extends Actor
	{
		static private const BALL_DIAMETER:int = 12;
		
		public function BallActor(parent:DisplayObjectContainer, location:Point, initVol:Point) {
			//create the costume
			var ballSprite:Sprite = new BallSprite();
			ballSprite.scaleX = BALL_DIAMETER / ballSprite.width;
			ballSprite.scaleY = BALL_DIAMETER / ballSprite.height;
			parent.addChild(ballSprite);
			//create the shape def
			var ballShapeDef:b2CircleDef = new b2CircleDef();
			ballShapeDef.radius = BALL_DIAMETER / 2 / PhysiVals.RATIO;
			ballShapeDef.density = 1.5;
			ballShapeDef.friction = 0;
			ballShapeDef.restitution = 0.45;
			//create the body definition
			var ballBodyDef:b2BodyDef = new b2BodyDef();
			ballBodyDef.position.Set(location.x / PhysiVals.RATIO, location.y / PhysiVals.RATIO);
			ballBodyDef.isBullet = true;
			//create the body
			var ballBody:b2Body = PhysiVals.world.CreateBody(ballBodyDef);
			ballBody.CreateShape(ballShapeDef);
			ballBody.SetMassFromShapes();
			//set volocity
			var velocityVector:b2Vec2 = new b2Vec2(initVol.x / PhysiVals.RATIO, initVol.y / PhysiVals.RATIO);
			ballBody.SetLinearVelocity(velocityVector);
			
			super(ballBody, ballSprite);
		}
		
		public function hitBonusTarget():void {
			dispatchEvent(new BallEvent(BallEvent.BALL_HIT_BONUS));
		}
		
		override protected function childSpecificUpdating():void 
		{
			if (_costume.y > _costume.stage.stageHeight) {
				//trace ("off stage");
				dispatchEvent(new BallEvent(BallEvent.BALL_OFF_SCREEN));
			}
			super.childSpecificUpdating();
		}
		
	}

}