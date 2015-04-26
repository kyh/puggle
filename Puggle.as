package{
	
	import Box2D.Collision.b2AABB;
	import Box2D.Collision.Shapes.b2CircleDef;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2World;
	import flash.display.*;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	
	public class Puggle extends Sprite {
		
		var _allActors:Array;
		var _actorsToRemove:Array;
		var _pegsLitUp:Array;
		var _camera:Camera;
		var _goalPegs:Array;
		var _currentBall:BallActor;
		var _timeMaster:TimeMaster;
		var _director:Director;
		var _aimingLine:AimingLine;
		var _shooter:Shooter;
		
		private const SHOOTER_POINT:Point = new Point(323, 10);
		private const LAUNCH_VELOCITY:Number = 470.0;
		private const GOAL_PEG_NUM:int = 22;
		private const GRAVITY:Number = 7.8;
		
		public function Puggle() {
			// constructor code
			_camera = new Camera();
			addChild(_camera);
			_timeMaster = new TimeMaster();
			_director = new Director(_camera, _timeMaster);
			_aimingLine = new AimingLine(GRAVITY);
			_camera.addChild(_aimingLine);
			_shooter = new Shooter();
			_camera.addChild(_shooter);
			_shooter.x = SHOOTER_POINT.x;
			_shooter.y = SHOOTER_POINT.y;
			
			setupPhysicsWorld();
			_allActors = [];
			_actorsToRemove = [];
			_pegsLitUp = [];
			_goalPegs = [];
			_currentBall = null;
			createLevel();
			addEventListener(Event.ENTER_FRAME, newFrameListener);
			stage.addEventListener(MouseEvent.CLICK, launchBall);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, showAimLine);
		}
		
		private function createLevel():void {
			var horizSpacing:int = 36;
			var vertSpacing:int = 36;
			var pegBounds:Rectangle = new Rectangle(114, 226, 418, 255);
			var flipRow:Boolean = false;
			var allPegs:Array = [];
			
			//create our pegs
			for (var pegY:int = pegBounds.top; pegY < pegBounds.bottom; pegY += vertSpacing) {
				var startX:int = pegBounds.left + ((flipRow) ? 0 : (horizSpacing / 2));
				flipRow = !flipRow;
				for (var pegX:int = startX; pegX < pegBounds.right; pegX += horizSpacing) {
					var newPeg:PegActor = new PegActor(_camera, new Point(pegX, pegY), PegActor.NORMAL);
					newPeg.addEventListener(PegEvent.PEG_LIT_UP, handlePegLitUp);
					newPeg.addEventListener(PegEvent.DONE_FADING_OUT, destroyPegNow);
					_allActors.push(newPeg);
					allPegs.push(newPeg);
				}
			}
			//make goal pegs
			if (allPegs.length < GOAL_PEG_NUM) {
				throw (new Error("Not enough pegs to set up level!"));
			} else {
				for ( var i:int = 0; i < GOAL_PEG_NUM; i++){
					//turn some of pegs into goal pegs and keep track of them
					var randomPegNum = Math.floor(Math.random() * allPegs.length);
					PegActor(allPegs[randomPegNum]).setType(PegActor.GOAL);
					//keep track of goal pegs
					_goalPegs.push(allPegs[randomPegNum]);
					allPegs.splice(randomPegNum, 1);
				}
			}
			
			//add side walls
			var wallShapes:Array = [[new Point(0, 0), new Point(10, 0), new Point(10, 603), new Point(0, 603)]];
			var leftWall:ArbStaticActor = new ArbStaticActor(_camera, new Point(-9, 0), wallShapes);
			_allActors.push(leftWall);
			var rightWall:ArbStaticActor = new ArbStaticActor(_camera, new Point(645, 0), wallShapes);
			_allActors.push(rightWall);
			
			//add some ramps
			var leftRampCoords:Array = [[new Point(0.0), new Point(79, 27), new Point(79, 30), new Point(0, 3)]];
			var leftRamp1:ArbStaticActor = new ArbStaticActor(_camera, new Point(0, 265), leftRampCoords);
			_allActors.push(leftRamp1);
			var leftRamp2:ArbStaticActor = new ArbStaticActor(_camera, new Point(0, 336), leftRampCoords);
			_allActors.push(leftRamp2);
			var leftRamp3:ArbStaticActor = new ArbStaticActor(_camera, new Point(0, 415), leftRampCoords);
			_allActors.push(leftRamp3);
			
			var rightRampCoords:Array = [[new Point(0, 0), new Point(0, 3), new Point( -85, 32), new Point( -85, 29)]];
			var rightRamp1:ArbStaticActor = new ArbStaticActor(_camera, new Point(646, 232), rightRampCoords);
			_allActors.push(rightRamp1);
			var rightRamp2:ArbStaticActor = new ArbStaticActor(_camera, new Point(646, 308), rightRampCoords);
			_allActors.push(rightRamp2);
			var rightRamp3:ArbStaticActor = new ArbStaticActor(_camera, new Point(646, 388), rightRampCoords);
			_allActors.push(rightRamp3);
			
			var bonusChute:BonusChuteActor = new BonusChuteActor(_camera, 85, 560, 580);
			_allActors.push(bonusChute);
		}
		
		private function destroyPegNow(e:PegEvent):void {
			safeRemoveActor(PegActor(e.currentTarget));
			PegActor(e.currentTarget).removeEventListener(PegEvent.DONE_FADING_OUT, destroyPegNow);
		}
		
		private function newFrameListener(e:Event):void {
			PhysiVals.world.Step(_timeMaster.getTimeStep(), 10);
			for each (var actor:Actor in _allActors) {
				actor.updateNow();
			}
			checkForZooming();
			reallyRemoveActors();
		}
		
		private function checkForZooming():void {
			if (_goalPegs.length == 1 && _currentBall != null) {
				var finalPeg:PegActor = _goalPegs[0]
				var p1:Point = finalPeg.getSpriteLoc();
				var p2:Point = _currentBall.getSpriteLoc();
				if (getDistSquared(p1, p2) < 75 * 75) {
					_director.zoomIn(p1);
				} else {
					_director.backToNormal();
				}
			} else if (_goalPegs.length == 0) {
				_director.backToNormal();
			}
		}
		
		private function getDistSquared(p1:Point, p2:Point):int {
			return ((p2.x - p1.x) * (p2.x - p1.x)) + ((p2.y - p1.y) * (p2.y - p1.y));
		}
		
		private function showAimLine(e:MouseEvent):void {
			if (_currentBall == null) {
				var launchPoint:Point = _shooter.getLaunchPosition();
				var direction:Point = new Point(mouseX, mouseY).subtract(launchPoint);
				_aimingLine.showLine(launchPoint, direction, LAUNCH_VELOCITY);
			}
		}
		
		private function launchBall(e:MouseEvent):void {
			if (_currentBall == null) {
				var launchPoint:Point = _shooter.getLaunchPosition();
				var direction:Point = new Point(mouseX, mouseY).subtract(launchPoint);
				direction.normalize(LAUNCH_VELOCITY);
				
				var newBall:BallActor = new BallActor(_camera, launchPoint, direction);
				newBall.addEventListener(BallEvent.BALL_OFF_SCREEN, handleBallOffScreen);
				newBall.addEventListener(BallEvent.BALL_HIT_BONUS, handleBallInBonusChute);
				_allActors.push(newBall);
				_currentBall = newBall;
				_aimingLine.hide();
			}
		}
		
		private function handleBallInBonusChute(e:BallEvent):void {
			//display fancy stuffs
			trace ("Ball hit target");
			handleBallOffScreen(e);
		}
		
		private function handleBallOffScreen(e:BallEvent):void 
		{
			trace("Ball is off screen");
			var ballToRemove:BallActor = BallActor(e.currentTarget);
			ballToRemove.removeEventListener(BallEvent.BALL_OFF_SCREEN, handleBallOffScreen);
			ballToRemove.removeEventListener(BallEvent.BALL_HIT_BONUS, handleBallInBonusChute);
			_currentBall = null;
			safeRemoveActor(ballToRemove);
			
			//remove pegs that have been lit up
			for (var i:int = 0; i < _pegsLitUp.length; i++){
				var pegToRemove:PegActor = PegActor(_pegsLitUp[i]);
				pegToRemove.fadeOut(i);
			}
			_pegsLitUp = [];
			showAimLine(null);
		}
		
		private function handlePegLitUp(e:PegEvent):void {
			//record the peg has been lit to remove later
			var pegActor:PegActor = PegActor(e.currentTarget);
			pegActor.removeEventListener(PegEvent.PEG_LIT_UP, handlePegLitUp);
			if (_pegsLitUp.indexOf(pegActor) < 0) {
				_pegsLitUp.push(pegActor);
			}
			var goalPegIndex:int = _goalPegs.indexOf(pegActor);
			if (goalPegIndex > -1) {
				_goalPegs.splice(goalPegIndex, 1);
			}
		}
		
		//mark an actor to be removed at a safe time
		public function safeRemoveActor(actorToRemove:Actor):void {
			if (_actorsToRemove.indexOf(actorToRemove) < 0) {
				_actorsToRemove.push(actorToRemove);
			}
		}
		
		//actually remove actors that have been marked for deletion
		private function reallyRemoveActors():void {
			for each (var removeMe:Actor in _actorsToRemove) {
				removeMe.destroy();
				var actorIndex:int = _allActors.indexOf(removeMe);
				if (actorIndex > -1) {
					_allActors.splice(actorIndex, 1);
				}
			}
			
			_actorsToRemove = [];
		}
		
		private function setupPhysicsWorld():void {
			var worldBounds:b2AABB = new b2AABB();
			worldBounds.lowerBound.Set( -5000 / PhysiVals.RATIO, -5000 / PhysiVals.RATIO);
			worldBounds.upperBound.Set(5000 / PhysiVals.RATIO, 5000 / PhysiVals.RATIO);
			var gravity:b2Vec2 = new b2Vec2(0, GRAVITY);
			var allowSleep:Boolean = true;
			
			PhysiVals.world = new b2World(worldBounds, gravity, allowSleep);
			PhysiVals.world.SetContactListener(new PuggleContactListener());
		}
	}
	
}
