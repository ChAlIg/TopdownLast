﻿package {
	import flash.display.MovieClip;
	import flash.events.Event;

	import flash.display.Stage;
	import flash.events.MouseEvent;

	import flash.geom.Matrix;
	import flash.geom.Point;
	
	import flash.geom.Transform; 
	import flash.geom.ColorTransform; 

	public class Player2 extends MovieClip {
		public var game: Game;
		public var facet: Facet2;
		
		public var death: Boolean = false;
		
		public var energyMax: int = 190;
		public var healthMax: int = 100;
		public var jumpCost: int = 100;
		public var speed: Number = 5;
		public var playerPoint: Point = new Point(400, 300);
		
		public var energy: int = 0;
		public var health: int = healthMax;
		public var shotDelay: int = 0;
		
		public var i: int;
		public var j: int;
		public var number: Number;
		public var number1: Number;
		public var number2: Number;
		public var number3: Number;
		public var token:Boolean = false;
		public var point: Point;
		
		private var sqrt2: Number = Math.sqrt(2);
		public var roll: int = 0;
		public var jumpAccelerator: int = 3;
		
		public var rotSpeed: Number;
		public var coursor: Coursor2;
		
		public var usualColour: ColorTransform = new ColorTransform ();
		public var hitTimer: int = 0;
		public var redOnHit: ColorTransform = new ColorTransform (2.5);
		
		public var activity: Boolean = false;
		
		public var r: int = 8;

		public function Player2(main:Game, X: int = 400, Y: int = 300): void {
			this.x = X;
			this.y = Y;
			game = main;
			coursor = new Coursor2(400, 300, this);
			facet = new Facet2(0, 0);
			
			//stage.addEventListener(MouseEvent.MOUSE_MOVE, rotateAndCoursor);
		}
		public function loop(): void {
			
			facet.abc.text = ("HP = " + health);
			
			if (hitTimer == 1) {
				--hitTimer;
				this.transform.colorTransform = usualColour;
			} else if (hitTimer) {
				--hitTimer
				this.transform.colorTransform = redOnHit;
			}
			
			if (health <= 0)
				death = true;
			
			if (energy < energyMax)
				++energy;
			
			if (shotDelay > 0)
				--shotDelay;
			if (activity) {
				token = false;
				number = speed / sqrt2;
				point = game.level.localToGlobal(new Point(x, y));

				if (game.leftPressed) {
					if (game.upPressed && !game.level.walls.hitTestPoint(point.x - 13 / sqrt2, point.y - 13 / sqrt2, true)) {
						game.level.x += number;
						game.level.y += number;
						token = true;
					} else if (game.downPressed && !game.level.walls.hitTestPoint(point.x - speed / sqrt2, point.y + speed / sqrt2, true)) {
						game.level.x += number;
						game.level.y -= number;
						token = true;
					} else if (!game.level.walls.hitTestPoint(point.x - 13, point.y, true)) {
						game.level.x += speed;
						token = true;
					}
				} else if (game.rightPressed) {
					if (game.downPressed && !game.level.walls.hitTestPoint(point.x + 13 / sqrt2, point.y + 13 / sqrt2, true)) {
						game.level.x -= number;
						game.level.y -= number;
						token = true;
					} else if (game.upPressed && !game.level.walls.hitTestPoint(point.x + 13 / sqrt2, point.y - 13 / sqrt2, true)) {
						game.level.x -= number;
						game.level.y += number;
						token = true;
					} else if (!game.level.walls.hitTestPoint(point.x + 13, point.y, true)) {
						game.level.x -= speed;
						token = true;
					}
				} else if (game.upPressed && !game.level.walls.hitTestPoint(point.x, point.y - 13, true)) {
					game.level.y += speed;
					token = true;
				} else if (game.downPressed && !game.level.walls.hitTestPoint(point.x, point.y + 13, true)) {
					game.level.y -= speed;
					token = true;
				}
					
				if (token == true) {
					point = game.level.globalToLocal(playerPoint);
					x = point.x;
					y = point.y; //помещение игрока в то место в локальной системе координат, которое соответствует месту игрока в глобальных координатах (Player2Point) 
				}
				if (game.leftMousePressed) {
					shootingBullet();
				}
			}

		}
		
		public function rotateAndCoursor(e: MouseEvent): void {
			
			rotation = Math.atan2(coursor.x - 400, -(coursor.y - 300)) * 180 / Math.PI;
			coursor.moving(e.movementX, e.movementY);

		}
		
		public function shootingBullet(): void {
			if ((energy >= 0) && (shotDelay == 0)) {
				point = game.level.globalToLocal(new Point(coursor.x, coursor.y));
				var bullet: Bullet = new Bullet(game, x, y, point.x + (Math.random() * 20 - 10), point.y + (Math.random() * 20 - 10));
				game.level.common.bulletList.push(bullet); //add this bullet to the bulletList array
				game.level.common.addChild(bullet);
				shotDelay = 15;
			}
		}
		
		/*public function shootingBullet(e: MouseEvent): void {
			if ((energy >= 0) && (shotDelay == 0)) {
				var bullet_pistol: Bullet_pistol = new Bullet_pistol(game.level, x, y, rotation + (Math.random() * 14 - 7)*Math.sqrt((coursor.x-400)*(coursor.x-400) + (coursor.y-300)*(coursor.y-300))/400 , 12 + Math.sqrt((coursor.x-400)*(coursor.x-400) + (coursor.y-300)*(coursor.y-300))/10);
				game.level.bulletList.push(bullet_pistol); //add this bullet to the bulletList array
				game.level.addChild(bullet_pistol);
				shotDelay = 8;
			}
		}*/
		
		public function onHit(damage: int): void {
			health -= damage;
			hitTimer = 5;
		}
		
		public function destroy(): void {
			var explosion_basic:Explosion_basic = new Explosion_basic(x, y, 5);
			game.level.layerList[3].addChild(explosion_basic);
			game.level.layerList[3].unitList.push(explosion_basic);
			game.level.common.removeChild(this);
		}
		
		public function toggleActivityUp(): void {
			
			point = game.level.localToGlobal(new Point(x, y));
			game.level.x += playerPoint.x - point.x;
			game.level.y += playerPoint.y - point.y;
			
			point = new Point(x, y);
			
			var t: Matrix = game.level.transform.matrix;
			point = t.transformPoint(point);
			t.translate(-point.x, -point.y);
			t.rotate(-game.level.rotation * (Math.PI / 180));
			t.translate(point.x, point.y);
			game.level.transform.matrix = t;
			
			game.addChild(facet);
			game.addChild(coursor);
			game.parent.addEventListener(MouseEvent.MOUSE_MOVE, game.level.player2.rotateAndCoursor);
			activity = true;
		}
		
		public function toggleActivityDown(): void {
			game.removeChild(facet);
			game.removeChild(coursor);
			game.parent.removeEventListener(MouseEvent.MOUSE_MOVE, game.level.player2.rotateAndCoursor);
			activity = false;
		}
		
	}
}