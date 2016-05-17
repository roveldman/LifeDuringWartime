package
{
	import org.flixel.*;
	
	public class Light extends FlxSprite
	{		
		private var darkness:FlxSprite;
		private static const _lightSpeed:int = 1;
		
		[Embed(source = "/img/light.png")]
		public static const Light:Class;
		
		
		public function Light(x:Number, y:Number, darkness:FlxSprite):void
		{
			super(x, y);
			loadGraphic(Light, false, false, 196, 196);
			
			this.darkness = darkness;
			this.blend = "screen"
		}
		
		override public function draw():void
		{
			var screenXY:FlxPoint = getScreenXY();
			
			darkness.stamp(this, screenXY.x - this.width / 2, screenXY.y - this.height / 2);
		}
	}
}