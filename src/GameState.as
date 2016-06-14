package
{
	import org.flixel.*;
	
	/**
	 * ...
	 * @author Roger Veldman
	 */
	public class GameState extends FlxState
	{
		
		[Embed(source = "/img/station.png")]
		public static const Station:Class;
		[Embed(source = "/img/stationBack.png")]
		public static const StationBack:Class;
		[Embed(source = "/img/jonsonsprite.png")]
		public static const Jonson:Class;
		[Embed(source = "/img/vanessasprite.png")]
		public static const Player:Class;
		[Embed(source = "/img/sarasprite.png")]
		public static const Sara:Class;
		[Embed(source = "/img/ground.png")]
		public static const Grass:Class;
		[Embed(source = "/img/spritesheet.png")]
		public static const Spritesheet:Class;
		[Embed(source = "/img/vanlittle.png")]
		public static const Van:Class;
		[Embed(source = "/img/dreamboy64.png")]
		public static const Dreamboy:Class;
		[Embed(source = "/img/hole.png")]
		public static const Hole:Class;
		[Embed(source = "/img/white.png")]
		public static const White:Class;
		[Embed(source = "/img/cellar.png")]
		public static const Cellar:Class;
		[Embed(source = "/img/swingset.png")]
		public static const Swingset:Class;
		[Embed(source = "/img/bookshelf.png")]
		public static const Bookshelf:Class;
		[Embed(source = "/img/strip.png")]
		public static const Strip:Class;
		[Embed(source = "/img/door.png")]
		public static const Door:Class;
		[Embed(source = "/img/computer.png")]
		public static const Computer:Class;
		[Embed(source = "/img/gate.png")]
		public static const Gate:Class;
		
		[Embed(source = '/csv/lvl1.csv', mimeType = "application/octet-stream")]
		public static const Level1:Class;
		
		[Embed(source = "/snd/BlipMellow.mp3")]
		public static const BlipMellow:Class;
		
		private var stationback:FlxSprite;
		private var station:FlxSprite;
		private var player:FlxSprite;
		private var van:FlxSprite;
		private var vanbox:FlxSprite;
		private var dreamboy:FlxSprite;
		private var swingset:FlxSprite;
		private var gate:FlxSprite;
		private var door:FlxSprite;
		private var computer:FlxSprite;
		private var hole:FlxSprite;
		private var focus:FlxObject;
		private var items:FlxGroup;
		private var countsort:int = 0;
		private var tilemap:FlxTilemap;
		private var last:String = "left";
		private var sara:FlxSprite;
		private var jonson:FlxSprite;
		private var prompt:FlxText;
		private var conv:Boolean = false;
		private var darkness:FlxSprite;
		private var playerlight:Light;
		private var lightsgroup:FlxGroup;
		private var lines:Array;
		private var boydone:Boolean;
		
		public override function create():void
		{
			DialogueManager.initDialogue();
			FlxG.camera.alpha = 0;
			darkness = new FlxSprite(0, 0);
			darkness.makeGraphic(FlxG.width, FlxG.height, 0xff000000);
			
			darkness.scrollFactor.x = darkness.scrollFactor.y = 0;
			darkness.blend = "multiply";
			
			player = new FlxSprite(180, 220, Player);
			player.loadGraphic(Player, true, false, 32, 64);
			player.width = 10;
			player.offset.x = 11;
			player.offset.y = 64
			player.drag.x = 200
			player.drag.y = 200;
			player.maxVelocity.x = player.maxVelocity.y = 75;
			player.addAnimation("idle", [0, 0], 2);
			player.addAnimation("down", [1, 7, 2, 8], 4);
			player.addAnimation("right", [4, 5, 6, 3], 4);
			player.addAnimation("left", [11, 12, 13, 14], 4);
			player.play("down");
			focus = new FlxObject(player.x, player.y);
			player.height = 1;
			lightsgroup = new FlxGroup();
			
			items = new FlxGroup();
			stationback = new FlxSprite(128, 152 - 10, StationBack);
			stationback.offset.y = 157 - 10;
			station = new FlxSprite(128, 165 - 10, Station);
			station.offset.y = 169 - 10
			
			van = new FlxSprite(128 - 78, 250, Van);
			vanbox = new FlxSprite(134 - 78, 250 - 10);
			vanbox.makeGraphic(110, 16, 0x00ffffff);
			
			swingset = new FlxSprite(70 * 32, 5 * 32);
			swingset.loadGraphic(Swingset, true, false, 128, 96);
			swingset.addAnimation("swing", [0, 0, 0, 1, 0, 0, 0], 1);
			swingset.play("swing");
			
			van.offset.y = 62;
			
			station.height = 1;
			
			add(new FlxSprite(-200, -200, Grass));
			add(new FlxSprite(800, -200, Grass));
			add(new FlxSprite(35 * 32 - 16, 170, Cellar));
			add(new FlxSprite(1900, -32 * 4, White));
			add(new FlxSprite(32 * 65, 32 * 9 - 16, Strip));
			door = new FlxSprite(32 * 78, -32 * 6 + 21, Door);
			add(new FlxSprite(32 * 45, 32 * 22, Computer));
			add(new FlxSprite(32 * 46, 32 * 22, Computer));
			add(new FlxSprite(32 * 47, 32 * 22, Computer));
			add(new FlxSprite(32 * 48, 32 * 22, Computer));
			add(door);
			
			computer = new FlxSprite(32 * 21, 32 * 15, Computer);
			items.add(computer);
			
			gate = new FlxSprite(32 * 12, 32 * 13, Gate);
			items.add(gate);
			
			items.add(swingset);
			
			tilemap = new FlxTilemap();
			tilemap.loadMap(new Level1, Spritesheet, 32, 32, FlxTilemap.OFF);
			
			add(tilemap);
			items.add(van);
			
			items.add(player);
			items.add(stationback);
			items.add(station);
			
			items.sort();
			dreamboy = new FlxSprite(32 * 50, 32 * 22, Dreamboy);
			items.add(dreamboy);
			items.add(new FlxSprite(32 * 39, 32 * 17, Bookshelf));
			items.add(new FlxSprite(32 * 40, 32 * 17, Bookshelf));
			items.add(new FlxSprite(32 * 44, 32 * 17, Bookshelf));
			items.add(new FlxSprite(32 * 45, 32 * 17, Bookshelf));
			items.add(new FlxSprite(32 * 39, 32 * 15, Bookshelf));
			items.add(new FlxSprite(32 * 40, 32 * 15, Bookshelf));
			items.add(new FlxSprite(32 * 44, 32 * 15, Bookshelf));
			items.add(new FlxSprite(32 * 45, 32 * 15, Bookshelf));
			items.add(new FlxSprite(32 * 39, 32 * 13, Bookshelf));
			items.add(new FlxSprite(32 * 40, 32 * 13, Bookshelf));
			items.add(new FlxSprite(32 * 44, 32 * 13, Bookshelf));
			items.add(new FlxSprite(32 * 45, 32 * 13, Bookshelf));
			items.add(new FlxSprite(32 * 50, 32 * 22, Bookshelf));
			
			hole = new FlxSprite(32 * 4, 32 * 16, Hole)
			add(hole);
			add(items);
			
			add(vanbox);
			sara = new FlxSprite(170 + 32, 270 + 32, Sara);
			jonson = new FlxSprite(170 + 32 + 50, 270 + 32 - 50, Jonson);
			makelight(170 + 50, 280);
			makelight(170 + 50 + 50, 230);
			sara.loadGraphic(Sara, true, false, 32, 64);
			jonson.loadGraphic(Jonson, true, false, 32, 64);
			sara.addAnimation("idle", [0, 1, 0, 1, 0, 1, 0, 2], 2);
			jonson.addAnimation("idle", [0, 1, 0, 1, 0, 1, 0, 2], 2.3);
			sara.play("idle");
			jonson.play("idle");
			sara.offset.y = 62;
			jonson.offset.y = 62;
			items.add(jonson);
			items.add(sara);
			vanbox.immovable = true;
			gate.immovable = true;
			
			vanbox.allowCollisions = FlxObject.ANY;
			player.allowCollisions = FlxObject.ANY;
			
			FlxG.camera.follow(focus, FlxCamera.STYLE_TOPDOWN);
			
			FlxG.worldBounds.width = 40 * 32 * 3;
			FlxG.worldBounds.height = 24 * 32 * 2;
			prompt = new FlxText(0, 0, 64);
			prompt.setFormat(null, 8, 0xefefef, "center");
			prompt.shadow = 1;
			
			add(lightsgroup);
			add(darkness);
			add(prompt);
			
			playerlight = new Light(player.x, player.y, darkness);
			lightsgroup.add(playerlight);
			playerlight.alpha = .5;
			
			lines = new Array();
			if (Counter.staticpoint == 3)
			{
				FlxG.camera.follow(focus, FlxCamera.STYLE_LOCKON);
				
				goDream();
			}
			if (Counter.staticpoint == 1)
			{
				FlxG.playMusic(BlipMellow);
			}
		}
		
		public function makelight(locX:int = 0, locY:int = 0):void
		{
			var light:Light = new Light(locX, locY, darkness);
			light.alpha = .5;
			lightsgroup.add(light);
		}
		
		override public function draw():void
		{
			lightsgroup.visible = true;
			if (player.x > 62 * 32)
			{
				darkness.fill(0xffffffff);
			}
			else if (player.x < 27 * 32)
			{
				darkness.fill(0xff555555);
			}
			else
			{
				darkness.fill(0xff111111);
			}
			super.draw();
		}
		
		public override function update():void
		{
			super.update();
			
			if (conv)
			{
				if (FlxG.keys.justPressed("K"))
				{
					
					if (DialogueManager.isComplete())
					{
						var line:String = lines.shift();
						if (line == null)
						{
							conv = false;
							return;
						}
						else
						{
							if (line.indexOf("No sense") != -1)
							{
								dreamboy.x = -2000
								var icon:FlxSprite = new FlxSprite(10, FlxG.height - 40, Dreamboy);
								icon.scale.x = 2;
								icon.scale.y = 2;
								icon.scrollFactor.x = icon.scrollFactor.y = 0;
								add(icon);
							}
							if (line.indexOf("I think.") != -1)
							{
								DialogueManager.hide();
								FlxG.fade(0x000000, 6, launchVan);
								jonson.y += 1000
								jonson.offset.y += 1000
								
							}
							if (line.indexOf("We have nothing left to talk about.") != -1)
							{
								door.y = 32 * 6 + 21;
							}
							DialogueManager.nextMessage(line);
							FlxG.stage.addChild(DialogueManager.profile);
						}
					}
					else
					{
						DialogueManager.finishText();
					}
					
				}
				return;
			}
			DialogueManager.hide();
			
			var s:Boolean = FlxG.keys.pressed("S");
			var w:Boolean = FlxG.keys.pressed("W");
			var a:Boolean = FlxG.keys.pressed("A");
			var d:Boolean = FlxG.keys.pressed("D");
			
			player.acceleration.x = player.acceleration.y = 0;
			if (w)
			{
				player.acceleration.y -= player.drag.y;
				maybeSort();
			}
			if (s)
			{
				player.acceleration.y += player.drag.y;
				maybeSort();
			}
			if (a)
			{
				player.acceleration.x -= player.drag.x;
				maybeSort();
			}
			if (d)
			{
				player.acceleration.x += player.drag.x;
				maybeSort();
			}
			
			if (player.velocity.x == 0 && player.velocity.y == 0)
			{
				player.play("idle");
			}
			
			if (player.velocity.x > 0)
			{
				player.play("right");
				last = "right";
			}
			else if (player.velocity.x < 0)
			{
				player.play("left");
				last = "left";
				
			}
			else if (player.velocity.y > 0)
			{
				player.play("down");
			}
			else if (player.velocity.y < 0)
			{
				player.play(last);
			}
			
			focus.x = player.x;
			focus.y = player.y - 32;
			if (player.x > 62 * 32)
			{
				player.offset.y = 64 + 16;
				player.height = 4;
				focus.y = player.y - 64
			}
			FlxG.collide(player, vanbox);
			FlxG.collide(player, tilemap);
			FlxG.collide(player, gate);
			if (FlxG.camera.alpha < 1)
			{
				FlxG.camera.alpha += .01;
			}
			
			if (Math.abs(Math.sqrt(Math.pow(player.x - sara.x, 2) + Math.pow(player.y - sara.y, 2))) < 50)
			{
				prompt.alpha += .1
				prompt.text = "chat";
				prompt.x = sara.x + sara.frameWidth / 2 - prompt.width / 2;
				prompt.y = sara.y - sara.height - prompt.height;
				if (FlxG.keys.justPressed("K"))
				{
					prompt.alpha = 0;
					prompt.text = "";
					lines.push("Sara: This is a rough break, but it'll be ok right, Vanessa?");
					lines.push("Sara: Right?");
					lines.push("Vanessa: Maybe we'll find something useful around here.");
					lines.push("Sara: Yeah let's hope.");
					lines.push("Vanessa: I'll be right back.");
					DialogueManager.nextMessage(lines.shift());
					FlxG.stage.addChild(DialogueManager.profile);
					conv = true;
					player.velocity.x = player.velocity.y = 0;
					player.acceleration.x = player.acceleration.y = 0;
					player.play("idle");
				}
			}
			else if (Math.abs(Math.sqrt(Math.pow(player.x - jonson.x, 2) + Math.pow(player.y - jonson.y, 2))) < 50)
			{
				prompt.alpha += .1
				prompt.text = "chat";
				prompt.x = jonson.x + jonson.frameWidth / 2 - prompt.width / 2;
				prompt.y = jonson.y - jonson.height - prompt.height;
				if (FlxG.keys.justPressed("K"))
				{
					prompt.alpha = 0;
					prompt.text = "";
					if (dreamboy.x != -2000)
					{
						lines.push("Jonson: Oh hey.");
						lines.push("Jonson: Just kind of chillin here I guess.");
						lines.push("Vanessa: Okay.");
						lines.push("Jonson: You know, Sara was right, it is kind of nice out here. Especially on a quiet night like tonight.");
						lines.push("Vanessa: Pays to get outside every once and a while.");
						lines.push("Jonson: I suppose it does.");
					}
					else
					{
						lines.push("Vanessa: Any idea what this thing is here?");
						lines.push("Jonson: Where'd you find that? I can't believe it. That's a Dreamboy 64!");
						lines.push("Vanessa: ???");
						lines.push("Jonson: It was all the rage before the war, but they stopped producing video games altogether a few years ago.");
						lines.push("Vanessa: Oh, really?");
						lines.push("Jonson: Yes, really.");
						lines.push("Vanessa: Well, I don't think it'll turn on here.");
						lines.push("Jonson: It's solar powered, so just leave it out in the sun tomorrow.");
						lines.push("Vanessa: Is it safe? I've never used virtual reality before.");
						lines.push("Jonson: I mean it should be pretty safe.");
						lines.push("Jonson: I think.");
					}
					DialogueManager.nextMessage(lines.shift());
					FlxG.stage.addChild(DialogueManager.profile);
					conv = true;
					player.velocity.x = player.velocity.y = 0;
					player.acceleration.x = player.acceleration.y = 0;
					player.play("idle");
				}
			}
			else if (Math.abs(Math.sqrt(Math.pow(player.x - dreamboy.x, 2) + Math.pow(player.y - dreamboy.y, 2))) < 80)
			{
				prompt.alpha += .1
				prompt.text = "what's this?";
				prompt.x = dreamboy.x + dreamboy.frameWidth / 2 - prompt.width / 2;
				prompt.y = dreamboy.y - dreamboy.height - prompt.height;
				if (FlxG.keys.justPressed("K"))
				{
					prompt.alpha = 0;
					prompt.text = "";
					lines.push("Vanessa: Hmm. Never seen one of these before.");
					lines.push("Vanessa: It looks neat, maybe Jonson will know what it is.");
					lines.push("Vanessa: No sense in leaving it here by itself, right?");
					DialogueManager.nextMessage(lines.shift());
					FlxG.stage.addChild(DialogueManager.profile);
					FlxG.stage.addChild(DialogueManager.profile);
					conv = true;
					player.velocity.x = player.velocity.y = 0;
					player.acceleration.x = player.acceleration.y = 0;
					player.play("idle");
				}
			}
			else if (Math.abs(player.x - swingset.x - 50) < 100)
			{
				prompt.alpha += .1
				prompt.color = 0xaaaaaa;
				prompt.text = "hello?";
				prompt.x = swingset.x + swingset.frameWidth / 2 - prompt.width / 2;
				prompt.y = swingset.y + swingset.height - prompt.height;
				if (FlxG.keys.justPressed("K"))
				{
					prompt.alpha = 0;
					prompt.text = "";
					if (boydone == false)
					{
						boydone = true;
						lines.push("Vanessa: ... hello?");
						lines.push("Boy: ... Umm. Hi.");
						lines.push("Vanessa: Where am I?");
						lines.push("Boy: You're playing a video game.");
						lines.push("Vanessa: Not much of a video game, really.");
						lines.push("Boy: This is all I want it to be.");
						lines.push("Vanessa: Could we make it a game of tennis? I like tennis.");
						lines.push("Boy: No, I think I'll sit here on this swingset.");
						lines.push("Boy: I rather like this swingset.");
						lines.push("Vanessa: Are you alright?");
						lines.push("Boy: Absolutely.");
						lines.push("Vanessa: Are you sure we can't play tennis in here?");
						lines.push("Boy: I haven't changed the settings in here for years, why would I change it now?");
						lines.push("Vanessa: Why are you all monochromatic?");
						lines.push("Boy: Color is just too much for me nowadays.");
						lines.push("Vanessa: Who are you?");
						lines.push("Boy: I don't know anymore.");
						lines.push("Vanessa: Do you remember the war?");
						lines.push("Boy: I have a painful memory of it, yes. It is only a feeling though. I couldn't tell you the details.");
						lines.push("Boy: They would come here and tell me all about it, and then one day they stopped coming.");
						lines.push("Vanessa: How old are you?");
						lines.push("Boy: I was created by Kusunoki Yamoto, in the year 2022 for Yamaguchi Video Game corporation, headquartered in Tokyo, Japan.");
						lines.push("Boy: This is all I know.");
						lines.push("Vanessa: It's been a while, Kusunoki. The world is gone as you know it.");
						lines.push("Boy: Do not call me Kusunoki, for I'm just one of his Dreamboy 64s. That is all.");
						lines.push("Vanessa: You seem lonely.");
						lines.push("Boy: Indeed.");
						lines.push("Boy: You'd better be going.");
						lines.push("Vanessa: But I just got here?");
						lines.push("Boy: We have nothing left to talk about.");
					}
					else
					{
						lines.push("Boy: There's nothing left to talk about.");
						lines.push("Vanessa: Wow, rude.");
					}
					
					DialogueManager.nextMessage(lines.shift());
					FlxG.stage.addChild(DialogueManager.profile);
					FlxG.stage.addChild(DialogueManager.profile);
					conv = true;
					player.velocity.x = player.velocity.y = 0;
					player.acceleration.x = player.acceleration.y = 0;
					player.play("idle");
				}
			}
			else if (Math.abs(Math.sqrt(Math.pow(player.x - dreamboy.x, 2) + Math.pow(player.y - dreamboy.y, 2))) < 80)
			{
				prompt.alpha += .1
				prompt.text = "what's this?";
				prompt.x = dreamboy.x + dreamboy.frameWidth / 2 - prompt.width / 2;
				prompt.y = dreamboy.y - dreamboy.height - prompt.height;
				if (FlxG.keys.justPressed("K"))
				{
					prompt.alpha = 0;
					prompt.text = "";
					lines.push("Vanessa: Hmm. Never seen one of these before.");
					lines.push("Vanessa: It looks neat, maybe Jonson will know what it is.");
					lines.push("Vanessa: No sense in leaving it here by itself, right?");
					DialogueManager.nextMessage(lines.shift());
					FlxG.stage.addChild(DialogueManager.profile);
					FlxG.stage.addChild(DialogueManager.profile);
					conv = true;
					player.velocity.x = player.velocity.y = 0;
					player.acceleration.x = player.acceleration.y = 0;
					player.play("idle");
				}
			}
			else if (Math.abs(Math.sqrt(Math.pow(player.x - door.x, 2) + Math.pow(player.y - door.y - 30, 2))) < 100)
			{
				prompt.alpha += .1
				prompt.color = 0xff9999;
				prompt.text = "goodbye";
				prompt.shadow = 0
				prompt.x = door.x + door.frameWidth / 2 - prompt.width / 2 - 6;
				prompt.y = door.y - door.height - prompt.height + 40;
				if (FlxG.keys.justPressed("K"))
				{
					Counter.staticpoint = 0;
					player.immovable = true;
					FlxG.fade(0xff000000, 3, endDialogue);
				}
			}
			else if (Math.abs(Math.sqrt(Math.pow(player.x - computer.x, 2) + Math.pow(player.y - computer.y - 30, 2))) < 100)
			{
				prompt.alpha += .1
				prompt.text = "tinker?";
				prompt.x = Math.round(computer.x + computer.frameWidth / 2 - prompt.width / 2);
				prompt.y = Math.round(computer.y + computer.height - 64);
				if (FlxG.keys.justPressed("K"))
				{
					prompt.alpha = 0;
					prompt.text = "";
					lines.push("Vanessa: That should open that gate.");
					DialogueManager.nextMessage(lines.shift());
					FlxG.stage.addChild(DialogueManager.profile);
					FlxG.stage.addChild(DialogueManager.profile);
					conv = true;
					player.velocity.x = player.velocity.y = 0;
					player.acceleration.x = player.acceleration.y = 0;
					player.play("idle");
					gate.x -= 2000;
					computer.x += 1000;
					computer.offset.x += 1000;
				}
			}
			
			else if (player.x > 36 * 32 && player.x < 49 * 32 && player.y < 32 * 13)
			{
				prompt.alpha += .1
				prompt.text = "ascend";
				prompt.x = 32 * 42 - 16;
				prompt.y = 32 * 10;
				if (FlxG.keys.justPressed("K"))
				{
					player.x = 7 * 32 + 10;
					player.y = 16 * 32;
					FlxG.camera.alpha = 0;
				}
				
			}
			else if (Math.abs(Math.sqrt(Math.pow(player.x - hole.x, 2) + Math.pow(player.y - hole.y - 30, 2))) < 100)
			{
				prompt.alpha += .1
				prompt.text = "descend";
				prompt.x = hole.x + hole.frameWidth / 2 - prompt.width / 2;
				prompt.y = hole.y - hole.height - prompt.height;
				if (FlxG.keys.justPressed("K"))
				{
					goCellar();
				}
				
			}
			else if (Math.abs(Math.sqrt(Math.pow(player.x - gate.x, 2) + Math.pow(player.y - gate.y - 30, 2))) < 100)
			{
				prompt.alpha += .1
				prompt.text = "locked";
				prompt.x = gate.x + gate.frameWidth / 2 - gate.width / 2 - 16;
				prompt.y = gate.y - hole.height - gate.height + 32;
				
			}
			else
			{
				prompt.color = 0xffffff;
				if (prompt.alpha > 0)
				{
					prompt.alpha -= .05;
				}
			}
			
			prompt.offset.y = prompt.alpha * 5 - 10;
			
			playerlight.x = player.x;
			playerlight.y = player.y - 24;
		}
		
		public function maybeSort():void
		{
			countsort++;
			countsort = countsort % 5;
			if (countsort == 0)
			{
				items.sort();
			}
		}
		
		public function launchVan():void
		{
			Counter.staticpoint++;
			FlxG.switchState(new VanState);
		}
		
		public function goDream():void
		{
			player.x = 67 * 32;
			player.y = 9 * 32 + 16;
			FlxG.camera.alpha = 0;
		}
		
		public function goCellar():void
		{
			player.x = 42 * 32 + 10;
			player.y = 14 * 32;
			FlxG.camera.alpha = 0;
		}
		
		public function endDialogue():void
		{
			conv = true;
			
			lines.push("Jonson: How was the game?");
			lines.push("Vanessa: Pretty lame, I guess.");
			lines.push("\t\t\tFin");
			DialogueManager.nextMessage(lines.shift());
			FlxG.stage.addChild(DialogueManager.profile);
		}
	}

}