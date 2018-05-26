package  {
	
	import flash.display.MovieClip;
	
	public class Explosion_basic extends MovieClip {
		public var death: Boolean = false;
		public var lifetime: int = 10;

		public function Explosion_basic(X: int, Y: int, scaler:Number = 1) {
			x = X;
			y = Y;
			scaleX = scaler;
			scaleY = scaler;
		}
		public function loop(): void {
			if (lifetime) {
				--lifetime;
			} else {
				death = true;
			}
		}
		public function destroy(): void {
			parent.removeChild(this);
		}

	}
	
}
