package extras;

#if desktop
import Discord.DiscordClient;
#end
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.utils.Assets;
import flixel.FlxSubState;
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxSave;
import haxe.Json;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import flixel.input.keyboard.FlxKey;
import flixel.graphics.FlxGraphic;
import Controls;

using StringTools;

class ExtrasState extends MusicBeatState
{
	var extras:Array<String> = ['Note Colors', #if debug 'Editor State', #end 'Links'];
	private var grpExtras:FlxTypedGroup<Alphabet>;
	private static var curSelected:Int = 0;
	public static var menuBG:FlxSprite;

	function openSelectedSubstate(label:String) {
		switch(label) {
			case 'Note Colors':
				openSubState(new options.NotesSubState()); // I prefer it being here. ~ Andrei_P
			case 'Soundtrack':
				trace('Coming Soon...'); // This'll be a huge thing, holy shit how I wanted to know real coding... ~ Andrei_P
				FlxG.sound.play(Paths.sound('cancelMenu'));
			case 'Editor State':
				LoadingState.loadAndSwitchState(new editors.MasterEditorMenu());
				#if desktop
					openfl.Lib.application.window.title = Main.engineTitle;
				#end
			case 'Links':
				LoadingState.loadAndSwitchState(new extras.LinksSubState()); // Supposed to be a SubState, but HaxeFlixel is a bitch. ~ Andrei_P
		}
	}

	var selectorLeft:Alphabet;
	var selectorRight:Alphabet;

	override function create() {
		#if desktop
		DiscordClient.changePresence("Extras Menu", null);
		#end

		var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
		bg.color = 0xff35d396;
		bg.updateHitbox();

		bg.screenCenter();
		bg.antialiasing = ClientPrefs.globalAntialiasing;
		add(bg);

		grpExtras = new FlxTypedGroup<Alphabet>();
		add(grpExtras);

		for (i in 0...extras.length)
		{
			var extraText:Alphabet = new Alphabet(0, 0, extras[i], true);
			extraText.screenCenter();
			extraText.y += (100 * (i - (extras.length / 2))) + 50;
			grpExtras.add(extraText);
		}

		selectorLeft = new Alphabet(0, 0, '>', true);
		add(selectorLeft);
		selectorRight = new Alphabet(0, 0, '<', true);
		add(selectorRight);

		changeSelection();
		ClientPrefs.saveSettings();

		super.create();
	}

	override function closeSubState() {
		super.closeSubState();
		ClientPrefs.saveSettings();
	}

	override function update(elapsed:Float) {
		super.update(elapsed);

		if (controls.FULLSCREEN)
			FlxG.fullscreen = !FlxG.fullscreen;

		if (controls.UI_UP_P) {
			changeSelection(-1);
		}
		if (controls.UI_DOWN_P) {
			changeSelection(1);
		}

		if (controls.BACK) {
			FlxG.sound.play(Paths.sound('cancelMenu'));
			MusicBeatState.switchState(new MainMenuState());
		}

		if (controls.ACCEPT) {
			openSelectedSubstate(extras[curSelected]);
		}
	}
	
	function changeSelection(change:Int = 0) {
		curSelected += change;
		if (curSelected < 0)
			curSelected = extras.length - 1;
		if (curSelected >= extras.length)
			curSelected = 0;

		var bullShit:Int = 0;

		for (item in grpExtras.members) {
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;
			if (item.targetY == 0) {
				item.alpha = 1;
				selectorLeft.x = item.x - 63;
				selectorLeft.y = item.y;
				selectorRight.x = item.x + item.width + 15;
				selectorRight.y = item.y;
			}
		}
		FlxG.sound.play(Paths.sound('scrollMenu'));
	}
}