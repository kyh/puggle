package  
{
	import Box2D.Collision.Shapes.b2CircleDef;
	import Box2D.Collision.Shapes.b2ShapeDef;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.geom.Point;
	import com.greensock.TweenLite

	/**
	 * ...
	 * @author Kai
	 */
	public class PegActor extends Actor
	{
		public static const NORMAL:int = 1;
		public static const GOAL:int = 2;
		private static const PEG_DIAMETER:int = 19; //diameter of all the pegs in pixels
		private var _beenHit:Boolean;
		private var _pegType:int;
		
		public function PegActor(parent:DisplayObjectContainer, location:Point, type:int) {
			_beenHit = false;
			_pegType = type;
			
			//create the costume
			var pegMovie:MovieClip = new PegMovie();
			pegMovie.scaleX = PEG_DIAMETER / pegMovie.width;
			pegMovie.scaleY = PEG_DIAMETER / pegMovie.height;
			parent.addChild(pegMovie);
			
			//create shape def
			var pegShapeDef:b2CircleDef = new b2CircleDef();
			pegShapeDef.radius = ((PEG_DIAMETER / 2) / PhysiVals.RATIO);
			pegShapeDef.density = 0;
			pegShapeDef.friction = 0;
			pegShapeDef.restitution = 0.45;
			
			//create body def
			var pegBodyDef:b2BodyDef = new b2BodyDef();
			pegBodyDef.position.Set(location.x / PhysiVals.RATIO, location.y / PhysiVals.RATIO);
			
			//create body
			var pegBody:b2Body = PhysiVals.world.CreateBody(pegBodyDef);
			
			//create shape
			pegBody.CreateShape(pegShapeDef);
			pegBody.SetMassFromShapes();
			
			super(pegBody, pegMovie);
			
			//set what frame the movie is at
			setMyMovieFrame();
			
		}
		
		private function setMyMovieFrame():void {
			if (_pegType == NORMAL) {
				if (_beenHit) {
					MovieClip(_costume).gotoAndStop(2);
				} else {
					MovieClip(_costume).gotoAndStop(1);
				}
			} else if (_pegType == GOAL) {
				if (_beenHit) {
					MovieClip(_costume).gotoAndStop(4);
				} else {
					MovieClip(_costume).gotoAndStop(3);
				}
			} else {
				throw(new Error("Peg type isn't recognized"));
			}
		}
		
		public function hitByBall():void {
			if (!_beenHit) {
				_beenHit = true;
				setMyMovieFrame();
				dispatchEvent(new PegEvent(PegEvent.PEG_LIT_UP));
			}
		}
		
		public function fadeOut(pegNumber:int):void {
			TweenLite.to(_costume, 0.3, { alpha:0, delay: 0.3 * pegNumber, onComplete: sendFadeOutDone } );
		}
		
		private function sendFadeOutDone():void {
			dispatchEvent(new PegEvent(PegEvent.DONE_FADING_OUT));
		}
		
		public function setType(newType:int):void {
			_pegType = newType;
			setMyMovieFrame();
		}
		
	}

}