package  
{
	import Box2D.Collision.Shapes.b2PolygonDef;
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
	public class ArbStaticActor extends Actor
	{
		
		public function ArbStaticActor(parent:DisplayObjectContainer, location:Point, arrayOfCoords:Array, visibleSprite:Boolean = true) {
			var myBody:b2Body = createBodyFromCoords(arrayOfCoords, location);
			var mySprite:Sprite = createSpriteFromCoords(arrayOfCoords, location, parent);
			if (!visibleSprite) {
				mySprite.visible = false;
			}
			
			super (myBody, mySprite);
		}
		
		private function createSpriteFromCoords(arrayOfCoords:Array, location:Point, parent:DisplayObjectContainer):Sprite {
			var newSprite:Sprite = new Sprite();
			newSprite.graphics.lineStyle(2, 0x368D45);
			
			for each (var listOfPoints:Array in arrayOfCoords) {
				var firstPoint:Point = listOfPoints[0];
				newSprite.graphics.moveTo(firstPoint.x, firstPoint.y);
				newSprite.graphics.beginFill(0x368D45);
				
				for each (var newPoint:Point in listOfPoints) {
					newSprite.graphics.lineTo(newPoint.x, newPoint.y);
				}
				
				newSprite.graphics.lineTo(firstPoint.x, firstPoint.y);
				newSprite.graphics.endFill();
			}
			
			newSprite.x = location.x;
			newSprite.y = location.y;
			parent.addChild(newSprite);
			
			return newSprite;
		}
		
		private function createBodyFromCoords(arrayOfCoords:Array, location:Point):b2Body {
			//Define Shapes
			var allShapeDefs:Array = [];
			for each (var listOfPoints:Array in arrayOfCoords) {
				var newShapeDef: b2PolygonDef = new b2PolygonDef();
				newShapeDef.vertexCount = listOfPoints.length;
				for (var i:int = 0; i < listOfPoints.length; i++) {
					var nextPoint:Point = listOfPoints[i];
					b2Vec2 (newShapeDef.vertices[i]).Set(nextPoint.x / PhysiVals.RATIO, nextPoint.y / PhysiVals.RATIO);
				}
				newShapeDef.density = 0;
				newShapeDef.friction = 0.2;
				newShapeDef.restitution = 0.3;
				allShapeDefs.push(newShapeDef);
			}
			
			//Define a body
			var arbiBodyDef:b2BodyDef = new b2BodyDef();
			arbiBodyDef.position.Set(location.x / PhysiVals.RATIO, location.y / PhysiVals.RATIO);
			
			//Create the body
			var arbiBody:b2Body = PhysiVals.world.CreateBody(arbiBodyDef);
			
			//Create the shapes
			for each (var newShapeDefToAdd:b2ShapeDef in allShapeDefs) {
				arbiBody.CreateShape(newShapeDefToAdd);
			}
			arbiBody.SetMassFromShapes();
			
			return arbiBody;
		}
		
	}

}