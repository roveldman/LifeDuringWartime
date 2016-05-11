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
		[Embed(source = "/img/vanessasprite.png")]
		public static const Player:Class;
		[Embed(source = "/img/grass.png")]
		public static const Grass:Class;
		[Embed(source = "/img/spritesheet.png")]
		public static const Spritesheet:Class;
		[Embed(source = "/img/vanlittle.png")]
		public static const Van:Class;
		
		[Embed(source = '/csv/lvl1.csv', mimeType = "application/octet-stream")]
		public static const Level1:Class;
		
		private var stationback:FlxSprite;
		private var station:FlxSprite;
		private var player:FlxSprite;
		private var van:FlxSprite;
		private var vanbox:FlxSprite;
		private var focus:FlxObject;
		private var items:FlxGroup;
		private var countsort:int = 0;
		private var tilemap:FlxTilemap;
		
		public override function create():void
		{
			FlxG.camera.alpha = 0;
			player = new FlxSprite(64, 256, Player);
			player.loadGraphic(Player, true, false, 32, 64);
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
			
			items = new FlxGroup();
			stationback = new FlxSprite(128, 157, StationBack);
			stationback.offset.y = 157;
			station = new FlxSprite(128, 169, Station);
			station.offset.y = 169
			
			van = new FlxSprite(128, 250, Van);
			vanbox = new FlxSprite(128, 250);
			vanbox.makeGraphic(128, 16,0x55ffffff);
			vanbox.offset.y = 64
			
			van.offset.y = 110;
			items.add(van);
			
			station.height = 1;
			for (var x:int = -14; x < 34; x++)
			{
				for (var y:int = -14; y < 34; y++)
				{
					//add(new FlxSprite(x * 32, y * 32, Grass));
				}
			}
			
			tilemap = new FlxTilemap();
			tilemap.loadMap(new Level1, Spritesheet, 32, 32, FlxTilemap.OFF);
			
			add(tilemap);
			items.add(player);
			
			items.add(station);
			
			items.add(stationback);
			
			items.sort();
			add(items);
			add(vanbox);
			vanbox.immovable = true;
			
			vanbox.allowCollisions = FlxObject.ANY;
			player.allowCollisions = FlxObject.ANY;
			
			FlxG.camera.follow(focus, FlxCamera.STYLE_TOPDOWN);
			//FlxG.bgColor = 0x449944;
			FlxG.worldBounds.width = 18*32*2;
			FlxG.worldBounds.height = 12*32*2;
		}
		
		public override function update():void
		{
			super.update();
			
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
				player.play("down");
			}
			if (a)
			{
				player.acceleration.x -= player.drag.x;
				maybeSort();
				player.play("right");
			}
			if (d)
			{
				player.acceleration.x += player.drag.x;
				maybeSort();
				player.play("right");
			}
			
			if (player.velocity.x + player.velocity.y == 0)
			{
				player.play("idle");
			}
			
			focus.x = player.x;
			focus.y = player.y - 32;
			FlxG.collide(player, vanbox);
			FlxG.collide(player, tilemap);
			FlxG.camera.alpha += .05;
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
	}

}