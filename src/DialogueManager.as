package
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import org.flixel.FlxG;
	import flash.utils.Timer
	import flash.events.TimerEvent;
	import flash.display.DisplayObject;
	import org.flixel.FlxSound;
	import org.flixel.FlxSprite;
	
	/**
	 * ...
	 * @author Roger Veldman
	 */
	public class DialogueManager
	{
		[Embed(source = "/snd/charprint.mp3")]
		public static const CharPrint:Class;
		
		[Embed(source = "font/nokiafc22.ttf", fontName = "nokia", mimeType = "application/x-font", advancedAntiAliasing = "false", embedAsCFF = "false")]
		private static var NokiaFont:Class;
		
		[Embed(source = "/img/vanessa.png")]
		public static const Vanessa:Class;
		
		[Embed(source = "/img/sara.png")]
		public static const Sara:Class;
		
		[Embed(source = "/img/jonson.png")]
		public static const Jonson:Class;
		
		[Embed(source = "/img/boy.png")]
		public static const Boy:Class;
		
		private static var messageArray:Array = new Array();
		private static var printing:Boolean = false;
		private static var next:String = "c0000";
		
		public static var textView:TextField = new TextField();
		public static var backRect:Sprite = new Sprite();
		public static var profile:Bitmap = new Bitmap();
		
		private static var timer:Timer = new Timer(50);
		
		public static function initDialogue():void
		{
			backRect.graphics.beginFill(0xFF888888);
			backRect.graphics.drawRect(12, 12, FlxG.width * 2 - 20, 96);
			
			var format:TextFormat = new TextFormat("nokia", 16, 0xffffff);
			textView.x = 124;
			textView.y = 20;
			textView.width = 500;
			textView.multiline = true;
			textView.wordWrap = true;
			textView.embedFonts = true;
			textView.defaultTextFormat = format;
			textView.setTextFormat(textView.defaultTextFormat);
			textView.appendText("default");
			
			profile.bitmapData = null
			
			hide();
		}
		
		public static function show():void
		{
			backRect.alpha = .8;
			textView.alpha = 1;
			profile.alpha = 1;
		}
		
		public static function hide():void
		{
			backRect.alpha = 0;
			textView.alpha = 0;
			profile.alpha = 0;
		}
		
		public static function nextMessage(next:String = null):void
		{
			hide();
			if (next.substring(0, 3) == "Van")
			{
				profile = new Vanessa();
			}
			if (next.substring(0, 3) == "Sar")
			{
				profile = new Sara();
			}
			if (next.substring(0, 3) == "Jon")
			{
				profile = new Jonson();
			}
			if (next.substring(0, 3) == "Boy")
			{
				profile = new Boy();
			}
			profile.x = 12;
			profile.y = 12;
			show();
			if (printing)
			{
				finishText();
				return;
			}

			// TODO: add shadow
			
			textView.text = "";			
			messageArray = new Array();
			messageArray = next.split("");
			finishText();
			timer = new Timer(50);
			timer.addEventListener(TimerEvent.TIMER, printChars);
			function printChars(e:TimerEvent):void
			{
				var character:String = messageArray.shift();
				if (character == null)
				{
					timer.stop();
					printing = false;
					return;
				}
				if (character != " " && character != "!" && character != "," && character != "."&& character != "?"&& character != ":")
				{
					FlxG.play(CharPrint, textView.alpha);
					timer.delay = 50;
				} else if (character == "." || character == "," || character == "?" || character == ":"){
					timer.delay = 300;
				} else {
					timer.delay = 0;
				}
				
				textView.appendText(character);
			}
			
			timer.start();
			return;
		}
		
		public static function finishText():void
		{
			timer.stop();
			
			var character:String = messageArray.shift();
			
			if (character == null)
			{
				return;
			}
			
			while (character != null)
			{
				if (character == ":")
				{
					textView.appendText(character);
					return;
				}
				textView.appendText(character);
				character = messageArray.shift();
			}
			FlxG.play(CharPrint, textView.alpha);
			printing = false;
		}
		
		public static function isComplete():Boolean
		{
			return messageArray.length == 0;
		}
	
	}

}
