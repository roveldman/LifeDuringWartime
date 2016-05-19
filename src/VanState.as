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
		
		[Embed(source = "/snd/curious.mp3")]
		public static const Curious:Class;
		
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
		private var darkness:FlxSprite;
		
		public override function create():void
		{
			lines = new Array();
			FlxG.playMusic(Curious);
			if (Counter.staticpoint != 2)
			{
				Counter.staticpoint = 0;
				FlxG.camera.color = 0x8888aa;
				FlxG.playMusic(Curious);
				moveState = 0;
				lines.push("Sara: ... so as I was saying, this will be a good place for all of us.");
				lines.push("Vanessa: Whatever you say.");
				lines.push("Sara: I like it here more anyway. Less people, less government. It's just peaceful.");
				lines.push("Vanessa: ...");
				lines.push("Sara: What is it?");
				lines.push("Vanessa: Let's hope it actually is.");
				lines.push("Jonson: There's so many rumors floating around. I don't know what to believe.");
				lines.push("Jonson: \"Up north, there's clean water and food enough so nobody starves\", they said. They lured us across the whole country. For Nothing.");
				lines.push("Jonson: Now what? Cleveland had nothing. There was nothing but mold and dust. Detroit was barren, too.");
				lines.push("Sara: You guys keep reminding me, but I promise this time our luck will change. I can just feel it.");
				lines.push("Vanessa: We have to hang in there, until then I guess. When will we find this place we're looking for? Can we ever find a place that isn't miserable?");
				lines.push("Vanessa: Somewhere we can at least scrape by?");
				lines.push("Vanessa: Sometimes, it just feels like there's nothing to hold on for anymore.");
				lines.push("Sara: ... well, we're alive. After the last few years of disasters, that's not a given for everyone.");
				lines.push("Sara: I wish there was some way to tell you I just want the best for us-");
				lines.push("Vanessa: Looks like we're running out of gas.");
				lines.push("Sara: For real?");
				lines.push("Jonson: Yes for real.");
				lines.push("Sara: Hey look up ahead. It looks like an abandoned gas station.");
				lines.push("Vanessa: Just about every place out here is abandoned. We've seen dozens of those. There's no gas there.");
				lines.push("Sara: Well, duh. We'll have to wait for a vendor bot to come along the road for gas, but in the meantime let's check it out.");
				lines.push("Sara: It'll at least be somewhere to sleep.");
				lines.push("Vanessa: You're so optimistic all the time Sara.");
				lines.push("Sara: I guess.");
				lines.push("Vanessa: You can just drive and drive and drive without any promise of where we're headed.");
				lines.push("Sara: And you couldn't?");
				lines.push("Jonson: Why do you think we have you drive?");
				lines.push("Sara: I see.");
				lines.push("Sara: Don't you guys give up yet...");
				lines.push("Sara: Here it is.");
			}
			if (Counter.staticpoint == 2)
			{
				moveState = -1;
				FlxG.playMusic(Music);
				lines.push("Sara: It's a good thing that vendor bot came by.");
				lines.push("Vanessa: I can't believe those things drive themselves. With all that flammable cargo.");
				lines.push("Jonson: Is the Dreamboy 64 charged yet?");
				lines.push("Vanessa: I put it out in the sun all morning, so I think it should be ready. I guess I'll go first.");
				lines.push("Sara: I wonder who lost it there? Who knows how long it was sitting there.");
				lines.push("Jonson: Maybe thirty years.");
				lines.push("Sara: I want to try next!");
				lines.push("Vanessa: Sara, you're driving.");
				lines.push("Sara: I mean we can stop sometime.");
				lines.push("Vanessa: Well, I guess I'll put it on.");
				lines.push("Vanessa: Um... Jonson?");
				lines.push("Vanessa: If my face looks freaked out at all I want you to pull this thing off of me, okay?");
				lines.push("Jonson: It should be perfectly safe, every household had one of these.");
				lines.push("Vanessa: Here goes nothing.");
			}
			
			super.create();
			
			FlxG.bgColor = 0xff00ff
			
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
							
							FlxG.stage.addChild(DialogueManager.profile);
						}
						else
						{
							DialogueManager.finishText()
							DialogueManager.hide();
							FlxG.music.fadeOut(3);
							FlxG.fade(0xff000000, 5, launchGameState);
							FlxG.music.fadeOut(4);
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
		
		public function launchGameState():void
		{
			Counter.staticpoint++;
			FlxG.switchState(new GameState);
		}
	
	}
}