package
{
	import org.flixel.*;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	
	/**
	 * ...
	 * @author Roger Veldman
	 */
	public class LogoState extends FlxState
	{
		private var myTimer:Timer;
		
		[Embed(source = "/snd/poweron.mp3")]
		public static const PowerOn:Class;
		
		[Embed(source = "/img/logo.png")]
		public static const Logo:Class;
		
		public function LogoState()
		{
			var count:uint = 0;
			super();
			add(new FlxSprite(0, 0, GameState.White));
			var snd:FlxSound = new FlxSound();
			snd.loadEmbedded(PowerOn);
			snd.volume = .5;
			var logo:FlxSprite = new FlxSprite(FlxG.width / 2, FlxG.height / 2, Logo);
			logo.x -= logo.width / 2;
			logo.y -= logo.height / 2;
			myTimer = new Timer(650);
			myTimer.addEventListener(TimerEvent.TIMER, timerListener);
			function timerListener(e:TimerEvent):void
			{
				
				if (count >= 5)
				{
					FlxG.switchState(new VanState);
					myTimer.stop();
				}
				if (count == 1) {
					add(logo);
					snd.play();
				}
				count++;
			}
			myTimer.start();
		
		}
		
		
	}

}