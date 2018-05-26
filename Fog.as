package  {
	import flash.display.MovieClip;
	
	public class Fog extends MovieClip {
		public var game: Game;
		public var death: Boolean = false;
		public var fog_invisible: Fog_invisible;
		public var fog_shade: Fog_shade;
		public var fog_mask: Fog_mask;
		public var a: Fog_obscure;
		public var b: Fog_obscure;
		public var c: Fog_obscure;
		public var d: Fog_obscure;
		public var px: int; //fog centre
		public var py: int;
		var ox: int = 1400; //obscure_width
		var oy: int = 1340;
		var tx: int; //current player x
		var ty: int;

		public function Fog(main:Game, playerX: int, playerY: int) {
			game = main;
			px = playerX;
			py = playerY;
			
			fog_invisible = new Fog_invisible();
			fog_shade = new Fog_shade();
			fog_mask = new Fog_mask();
			a = new Fog_obscure(px-ox, py-oy);
			b = new Fog_obscure(px, py-oy);
			c = new Fog_obscure(px-ox, py);
			d = new Fog_obscure(px, py);
			addChild(fog_invisible);
			addChild(fog_mask);
			addChild(fog_shade);
			addChild(a);
			addChild(b);
			addChild(c);
			addChild(d);
			fog_invisible.mask = fog_mask;
		}
		public function loop(): void {
			tx = game.level.player1.x;
			ty = game.level.player1.y;
			fog_invisible.x = tx;
			fog_mask.x = tx;
			fog_shade.x = tx;
			fog_invisible.y = ty;
			fog_mask.y = ty;
			fog_shade.y = ty;
			fog_invisible.rotation = game.level.player1.rotation;
			fog_mask.rotation = game.level.player1.rotation;
			fog_shade.rotation = game.level.player1.rotation;
			
			if (tx - px < -ox/2) {
				px -= ox;
				removeChild(b);
				removeChild(d);
				b = a;
				d = c;
				a = new Fog_obscure(px-ox, py-oy);
				c = new Fog_obscure(px-ox, py);
				addChild(a);
				addChild(c);
			} else if (tx - px > ox/2) {
				px += ox;
				removeChild(a);
				removeChild(c);
				a = b;
				c = d;
				b = new Fog_obscure(px, py-oy);
				d = new Fog_obscure(px, py);
				addChild(b);
				addChild(d);
			}
			if (ty - py < -oy/2) {
				py -= oy;
				removeChild(c);
				removeChild(d);
				c = a;
				d = b;
				a = new Fog_obscure(px-ox, py-oy);
				b = new Fog_obscure(px, py-oy);
				addChild(a);
				addChild(b);
			} else if (ty - py > oy/2) {
				py += oy;
				removeChild(a);
				removeChild(b);
				a = c;
				b = d;
				c = new Fog_obscure(px-ox, py);
				d = new Fog_obscure(px, py);
				addChild(c);
				addChild(d);
			}
		}

	}
	
}
