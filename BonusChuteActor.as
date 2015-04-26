package  
{
	import Box2D.Collision.Shapes.b2PolygonDef;
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Collision.Shapes.b2ShapeDef;
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
	public class BonusChuteActor extends Actor
	{
		public static const BONUS_TARGET:String = "BonusTarget";
		private const TRAVEL_SPEED:int = 2;
		private var _bounds:Array;
		private var _yPos:int;
		private var _direction:int;
		
		public function BonusChuteActor(parent:DisplayObjectContainer, leftBounds:int, rightBounds:int, yPos:int) {
			_bounds = [leftBounds, rightBounds];
			_yPos = yPos;
			_direction = 1;
			
			var chuteGraphic:Sprite = new BonusChuteGraphic();
			parent.addChild(chuteGraphic);
			
			var leftRampShapeDef:b2PolygonDef = new b2PolygonDef();
			leftRampShapeDef.vertexCount = 3;
			b2Vec2(leftRampShapeDef.vertices[0]).Set( -83.5 / PhysiVals.RATIO, 12.0 / PhysiVals.RATIO);
			b2Vec2(leftRampShapeDef.vertices[1]).Set( -54.5 / PhysiVals.RATIO, -12.0 / PhysiVals.RATIO);
			b2Vec2(leftRampShapeDef.vertices[2]).Set( -54.5 / PhysiVals.RATIO, 12.0 / PhysiVals.RATIO);
			leftRampShapeDef.friction = 0.1;
			leftRampShapeDef.restitution = 0.6;
			leftRampShapeDef.density = 1;
			
			var rightRampShapeDef:b2PolygonDef = new b2PolygonDef();
			rightRampShapeDef.vertexCount = 3;
			b2Vec2(rightRampShapeDef.vertices[0]).Set( 83.0 / PhysiVals.RATIO, 12.0 / PhysiVals.RATIO);
			b2Vec2(rightRampShapeDef.vertices[1]).Set( 59.0 / PhysiVals.RATIO, 12.0 / PhysiVals.RATIO);
			b2Vec2(rightRampShapeDef.vertices[2]).Set( 59.0 / PhysiVals.RATIO, -12.0 / PhysiVals.RATIO);
			rightRampShapeDef.friction = 0.1;
			rightRampShapeDef.restitution = 0.6;
			rightRampShapeDef.density = 1;
			
			var centerHoleShapeDef:b2PolygonDef = new b2PolygonDef();
			centerHoleShapeDef.vertexCount = 4;
			b2Vec2(centerHoleShapeDef.vertices[0]).Set( -54.5 / PhysiVals.RATIO, -12.0 / PhysiVals.RATIO);
			b2Vec2(centerHoleShapeDef.vertices[1]).Set( 59.0 / PhysiVals.RATIO, -12.0 / PhysiVals.RATIO);
			b2Vec2(centerHoleShapeDef.vertices[2]).Set( 59.0 / PhysiVals.RATIO, 12.0 / PhysiVals.RATIO);
			b2Vec2(centerHoleShapeDef.vertices[3]).Set( -54.5 / PhysiVals.RATIO, 12.0 / PhysiVals.RATIO);
			centerHoleShapeDef.friction = 0.1;
			centerHoleShapeDef.restitution = 0.6;
			centerHoleShapeDef.density = 1;
			centerHoleShapeDef.isSensor = true;
			centerHoleShapeDef.userData = BonusChuteActor.BONUS_TARGET;
			
			var chuteBodyDef:b2BodyDef = new b2BodyDef();
			chuteBodyDef.position.Set(((leftBounds + rightBounds) / 2) / PhysiVals.RATIO, yPos / PhysiVals.RATIO);
			chuteBodyDef.fixedRotation = true;
			
			var chuteBody:b2Body = PhysiVals.world.CreateBody(chuteBodyDef);
			chuteBody.CreateShape(leftRampShapeDef);
			chuteBody.CreateShape(rightRampShapeDef);
			chuteBody.CreateShape(centerHoleShapeDef);
			chuteBody.SetMassFromShapes();
			
			super(chuteBody, chuteGraphic);
		}
		
		override protected function childSpecificUpdating():void 
		{
			if (_costume.x >= _bounds[1]) {
				_direction = -1;
			} else if (_costume.x <= _bounds[0]) {
				_direction = 1;
			}
			var idealLocation:b2Vec2 = new b2Vec2(_costume.x + (_direction * TRAVEL_SPEED), _yPos);
			var directionToTravel:b2Vec2 = new b2Vec2(idealLocation.x - _costume.x, idealLocation.y - _costume.y);
			directionToTravel.Multiply(1 / PhysiVals.RATIO); //distance to travel in one frame
			directionToTravel.Multiply(PhysiVals.FRAME_RATE); //multiply by frame rate
			_body.SetLinearVelocity(directionToTravel);
			super.childSpecificUpdating();
		}
		
	}

}