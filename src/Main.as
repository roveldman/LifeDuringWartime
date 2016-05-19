package
{
	import flash.events.Event;
	import org.flixel.*;
	
	[SWF(width = "640", height = "512", backgroundColor = "#000000")]
	
	public class Main extends FlxGame
	{
		
		public function Main()
		{
			super(320, 256, LogoState, 2);
			DialogueManager.initDialogue();
			FlxG.stage.addChild(DialogueManager.backRect);
			FlxG.stage.addChild(DialogueManager.textView);
			FlxG.stage.addChild(DialogueManager.profile);
			
			FlxG.bgColor = 0xffff00ff;
			forceDebugger = false;
			useDefaultHotKeys = false;
		}
	}
}