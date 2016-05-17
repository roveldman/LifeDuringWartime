package
{
	import mx.core.FlexSprite;
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
		
		[Embed(source = '/csv/lvl1.csv', mimeType = "application/octet-stream")]
		public static const Level1:Class;
		
		[Embed(source = "/snd/curious.mp3")]
		public static const Curious:Class;
		
		private var stationback:FlxSprite;
		private var station:FlxSprite;
		private var player:FlxSprite;
		private var van:FlxSprite;
		private var vanbox:FlxSprite;
		private var dreamboy:FlxSprite;
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
		
		public override function create():void
		{
			Counter.staticpoint = 1;
			//FlxG.playMusic(Curious);
			DialogueManager.initDialogue();
			FlxG.camera.alpha = 0;
			darkness = new FlxSprite(0, 0);
			darkness.makeGraphic(FlxG.width, FlxG.height, 0xff000000);
			
			darkness.scrollFactor.x = darkness.scrollFactor.y = 0;
			darkness.blend = "multiply";
			
			player = new FlxSprite(140, 270, Player);
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
			
			van = new FlxSprite(128, 250, Van);
			vanbox = new FlxSprite(134, 250 - 10);
			vanbox.makeGraphic(110, 16, 0x00ffffff);
			
			van.offset.y = 62;
			
			station.height = 1;
			
			add(new FlxSprite(-200, -200, Grass));
			add(new FlxSprite(800, -200, Grass));
			add(new FlxSprite(1200, 400, Cellar));
			add(new FlxSprite(2000, 0, White));
			
			tilemap = new FlxTilemap();
			tilemap.loadMap(new Level1, Spritesheet, 32, 32, FlxTilemap.OFF);
			
			add(tilemap);
			items.add(van);
			
			items.add(player);
			items.add(stationback);
			items.add(station);
			
			items.sort();
			dreamboy = new FlxSprite(32 * 11, 32 * 42, Dreamboy);
			items.add(dreamboy);
			
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
			
			vanbox.allowCollisions = FlxObject.ANY;
			player.allowCollisions = FlxObject.ANY;
			
			FlxG.camera.follow(focus, FlxCamera.STYLE_TOPDOWN);
			
			FlxG.worldBounds.width = 18 * 32 * 2;
			FlxG.worldBounds.height = 12 * 32 * 2;
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
			darkness.fill(0xff555555);
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
								FlxG.fade(0xffffff, 4, launchVan);
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
			FlxG.collide(player, vanbox);
			FlxG.collide(player, tilemap);
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
			else if (Math.abs(Math.sqrt(Math.pow(player.x - dreamboy.x, 2) + Math.pow(player.y - dreamboy.y, 2))) < 100)
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
			else if (Math.abs(Math.sqrt(Math.pow(player.x - hole.x, 2) + Math.pow(player.y - hole.y, 2))) < 100)
			{
				prompt.alpha += .1
				prompt.text = "descend";
				prompt.x = hole.x + hole.frameWidth / 2 - prompt.width / 2;
				prompt.y = hole.y - hole.height - prompt.height;
				if (FlxG.keys.justPressed("K"))
				{
					prompt.alpha = 0;
					prompt.text = "";
					player.x = 42 * 32;
					player.y = 14*32
				}
			}
			else
			{
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
	}

}