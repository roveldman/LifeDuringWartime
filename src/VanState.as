package
{
	import flash.display.Sprite;
	import org.flixel.*;
	
	/**
	 * ...
	 * @author Roger Veldman
	 */
	public class VanState extends FlxState
	{
		[Embed(source = "/snd/music.mp3")]
		public static const Music:Class;
		
		[Embed(source = "/img/van.png")]
		public static const Van:Class;
		
		[Embed(source = "/img/back.png")]
		public static const Back:Class;
		
		[Embed(source = "/img/title.png")]
		public static const Title:Class;
		
		private var van:FlxSprite;
		private var back:FlxSprite;
		private var back2:FlxSprite;
		
		private var title:FlxSprite;
		private var moveState:int = 0;
		private var lines:Array;
		
		public override function create():void
		{
			super.create();
			
			FlxG.bgColor = 0xff00ff
			FlxG.playMusic(Music);
			
			title = new FlxSprite(0, 0, Title);
			add(title);
			back = new FlxSprite(0, 300, Back);
			back2 = new FlxSprite(back.width, 300, Back);
			
			add(back);
			add(back2);
			
			van = new FlxSprite(32, 100 + 300, Van);
			van.loadGraphic(Van, true, false, 256, 128);
			van.addAnimation("drive", [0, 0, 0, 1], 4, true);
			van.play("drive");
			add(van);
			
			if (moveState == -1)
			{
				van.y = 100;
				back.y = 0;
				back2.y = 0;
			}
			
			title.alpha = 0;
			
			FlxG.camera.y = 0;
			lines = new Array();
			lines.push("Vanessa: ... so as I was saying, it's a lot safer this way.");
			lines.push("Sara: Whatever you say.");
			lines.push("Vanessa: Still tired?");
			lines.push("Sara: This road is so long.");
			lines.push("Vanessa: I definitely hear you there.");
			lines.push("Sara: Hey look up ahead! It looks like an abandoned gas station!");
			lines.push("Vanessa: But we've seen dozens of those.");
			lines.push("Sara: Let's check it out.");
			lines.push("Vanessa: Alright.");
			lines.push("Vanessa: I guess.");
		
		}
		
		override public function update():void
		{
			super.update();
			if (moveState == 2)
			{
				if (FlxG.keys.justPressed("K"))
				{
					if (DialogueManager.isComplete())
					{
						var line:String = lines.shift();
						if (line != null)
						{
							DialogueManager.nextMessage(line);
							FlxG.log("change");
							FlxG.stage.addChild(DialogueManager.profile);
						}
						else
						{
							DialogueManager.finishText()
							DialogueManager.hide();
							FlxG.fade(0xff000000, 2,launchGameState);
						}
						
					}
					else
					{
						DialogueManager.finishText();
					}
					
				}
			}
			if (moveState == 0)
			{
				title.alpha += .001;
			}
			else
			{
				title.alpha = 1;
			}
			if (back.y > 0 && moveState == 1)
			{
				back.y -= .25 + (back.y / 300);
				back2.y -= .25 + (back.y / 300);
				
				title.y -= .25 + (back.y / 300);
				van.y -= .25 + (back.y / 300);
			}
			if (moveState == 1 && back.y <= 0)
			{
				moveState = 2;
				DialogueManager.show();
				DialogueManager.nextMessage(lines.shift());
				FlxG.stage.addChild(DialogueManager.profile);
				
			}
			if (FlxG.keys.justPressed("K") && moveState == 0)
			{
				moveState = 1;
			}
			
			if (moveState == -1)
			{
				moveState = 2;
				DialogueManager.show();
				DialogueManager.nextMessage(lines.shift());
				FlxG.stage.addChild(DialogueManager.profile);
			}
			
			back.x -= 3;
			back2.x -= 3;
			if (back.x < -back.width)
			{
				back.x = back.width - 3;
			}
			if (back2.x < -back.width)
			{
				back2.x = back.width - 3
			}
		}
		
		public function launchGameState():void {
			FlxG.switchState(new GameState);
		}
	
	}
}