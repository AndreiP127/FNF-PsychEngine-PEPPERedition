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

class LinksSubState extends MusicBeatState
{
    private static var curSelected:Int = 0;
    private var grpLinks:FlxTypedGroup<Alphabet>;
    var links:Array<String> = [
        'FNF on itch.io',
        'FNF on Newgrounds',
        'FNF on GitHub',
        'FNF on Kickstarter',
        'Psych Engine on GitHub',
        'Psych Engine on Gamebanana',
        'PEPPER Edition on GitHub'
    ];

    function openSelectedLink(label:String) {
		switch(label) {
            case 'FNF on itch.io':
				CoolUtil.browserLoad('https://ninja-muffin24.itch.io/funkin');
			case 'FNF on Newgrounds':
				CoolUtil.browserLoad('https://www.newgrounds.com/portal/view/770371');
            case 'FNF on GitHub':
                CoolUtil.browserLoad('https://github.com/FunkinCrew/Funkin');
            case 'FNF on Kickstarter':
                CoolUtil.browserLoad('https://www.kickstarter.com/projects/funkin/friday-night-funkin-the-full-ass-game');  
            case 'Psych Engine on GitHub':
                CoolUtil.browserLoad('https://github.com/ShadowMario/FNF-PsychEngine');
            case 'Psych Engine on Gamebanana':
                CoolUtil.browserLoad('https://gamebanana.com/mods/309789');
            case 'PEPPER Edition on GitHub':
                CoolUtil.browserLoad('https://github.com/AndreiP127/FNF-PsychEngine-PEPPERedition');
		}
	}

    public function new() {
        super();
        
        var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
		bg.color = 0xff726774;
		bg.screenCenter();
		bg.antialiasing = ClientPrefs.globalAntialiasing;
		add(bg);

		grpLinks = new FlxTypedGroup<Alphabet>();
		add(grpLinks);

        for (i in 0...links.length) {
            var linkText:Alphabet = new Alphabet(90, 320, links[i], true);
			linkText.isMenuItem = true;
			linkText.targetY = i;
			grpLinks.add(linkText);
			linkText.snapToPosition();
        }
    }

    override function update(elapsed:Float) {
		super.update(elapsed);

		if (controls.ACCEPT) {
			openSelectedLink(links[curSelected]);
		}

        if (controls.BACK) {
			FlxG.sound.play(Paths.sound('cancelMenu'));
			LoadingState.loadAndSwitchState(new extras.ExtrasState());
		}

        if (controls.FULLSCREEN)
			FlxG.fullscreen = !FlxG.fullscreen;

		if (controls.UI_UP_P) {
			changeSelection(-1);
		}
		if (controls.UI_DOWN_P) {
			changeSelection(1);
		}

        var bullShit:Int = 0;
		for (item in grpLinks.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;
			// item.setGraphicSize(Std.int(item.width * 0.8));

			if (item.targetY == 0)
			{
				item.alpha = 1;
				// item.setGraphicSize(Std.int(item.width));
			}
		}
		super.update(elapsed);
    }

    function changeSelection(change:Int = 0) {

        FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);

		curSelected += change;
		if (curSelected < 0)
			curSelected = links.length - 1;
		if (curSelected >= links.length)
			curSelected = 0;
    }
}