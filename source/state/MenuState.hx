package state ;

import flixel.addons.editors.ogmo.FlxOgmoLoader;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tile.FlxTilemap;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import flixel.util.FlxMath;
import flixel.util.FlxDestroyUtil;
import openfl.system.System;
import util.FileReg;
import util.GamepadIDs;
using flixel.util.FlxSpriteUtil;

/**
 * ...
 * @author Glynn Taylor
 * State for displaying the main menu
 */
class MenuState extends FlxState
{
	//Constants//
	private static inline var _btnOffset:Int = 32;
	//UI//
	private var _btnPlay:FlxButton;
	private var _btnOptions:FlxButton;
	private var _btnControls:FlxButton;
	private var _btnCredits:FlxButton;
	private var _btnQuit:FlxButton;
	private var _title1:FlxText;
	private var _warningMsg:FlxText;
	//Map//
	private var _map:FlxOgmoLoader;
	private var _mWalls:FlxTilemap;
	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		FlxG.mouse.visible = true;
		_map = new FlxOgmoLoader(FileReg.dataLevel_1);				//Load map
		_mWalls = _map.loadTilemap(FileReg.imgTiles, 16, 16, "tiles");	//Load walls using tilesheet from layer "tiles"
		_mWalls.setTileProperties(1, FlxObject.NONE);				//Not collideable in menu
		add(_mWalls);
		
		_title1 = new FlxText(0, 0,0, "Reflectionfall");				//Create title
		_title1.screenCenter();
		_title1.y = 50;
		_title1.x -=90;
		_title1.size = 32;
		_title1.color = 0xFFCC00;
		_title1.borderStyle = FlxText.BORDER_SHADOW;				//Set shadowed border
		_title1.borderSize = 2;
		_title1.borderColor = 0x000000;
		_title1.antialiasing = false;								//Nearest neighbour rendering
		add(_title1);
		
		_warningMsg= new FlxText(0, (FlxG.height / 3) - 18, 0,"Requires controllers to play", 8);
		_warningMsg.alignment = "center";
		_warningMsg.screenCenter(true, false);
		add(_warningMsg);
		
		var sndSelect:FlxSound = FlxG.sound.load(FileReg.sndSelect);//Load select sound
		
		_btnPlay = new FlxButton(0, 0, "Play (start)", clickPlay);			//Create button
		_btnPlay.screenCenter();
		_btnPlay.y -= 1 * _btnOffset;								//Set position
		_btnPlay.onUp.sound = sndSelect;							//set sound to select
		add(_btnPlay);												//add button to scene
		
		_btnOptions = new FlxButton(0, 0, "Options", clickOptions);	//Create button
		_btnOptions.screenCenter();
		_btnOptions.y += 0 * _btnOffset;							//Set position
		_btnOptions.onUp.sound = sndSelect;							//set sound to select
		add(_btnOptions);											//add button to scene
		
		_btnControls = new FlxButton(0, 0, "Controls", clickControls);	//Create button
		_btnControls.screenCenter();
		_btnControls.y += 1 * _btnOffset;							//Set position
		_btnControls.onUp.sound = sndSelect;						//set sound to select
		add(_btnControls);											//add button to scene
		
		_btnCredits = new FlxButton(0, 0, "Credits", clickCredits);	//Create button
		_btnCredits.screenCenter();
		_btnCredits.y += 2 * _btnOffset;							//Set position
		_btnCredits.onUp.sound = sndSelect;							//set sound to select
		add(_btnCredits);											//add button to scene
		
		_btnQuit = new FlxButton(0, 0, "Quit", clickQuit);			//Create button
		_btnQuit.screenCenter();
		_btnQuit.y += 3 * _btnOffset;								//Set position
		_btnQuit.onUp.sound = sndSelect;							//set sound to select
		add(_btnQuit);												//add button to scene
		FlxG.camera.fade(FlxColor.BLACK, .33, true);				//Fade in
		super.create();
	}
	//Handles "play" button click
	private function clickPlay():Void
	{
		if (FlxG.gamepads.numActiveGamepads < 2) {
			_warningMsg.text = "Requires at least 2 controllers to play";
			_warningMsg.x = FlxG.width/2-_warningMsg.width/2-25;	//Recentering not working that great, need to come back to this
			//_warningMsg.alignment = "center";						
			//_warningMsg.screenCenter(true, false);
		}else{
			FlxG.camera.fade(FlxColor.BLACK,.33, false,function() {	//Fade out
				FlxG.switchState(new PlayState());
			});
		}
	}
	//Handles "options" button click
	private function clickOptions():Void
	{
		FlxG.camera.fade(FlxColor.BLACK,.33, false,function() {		//Fade out
			FlxG.switchState(new OptionsState());
		});
	}
	//Handles "credits" button click
	private function clickCredits():Void
	{
		FlxG.camera.fade(FlxColor.BLACK,.33, false,function() {		//Fade out
			FlxG.switchState(new InfoState("Credits","Programming: Glynn Taylor\nArt/Music: OpenGameArt (multiple)\nVicky Hedgecock: Player sprite\nPatrick Crecelius: BG music\n Framework: HaxeFlixel"));
		});
	}
	//Handles "controls" button click
	private function clickControls():Void
	{
		FlxG.camera.fade(FlxColor.BLACK,.33, false,function() {		//Fade out
			FlxG.switchState(new InfoState("Controls","Thumbstick: Look+move\nA: Jump\nX: Fire"));
		});
	}
	//Handles "quit" button click
	private function clickQuit():Void
	{
		System.exit(0);
	}

	//Called every frame
	override public function update():Void
	{
		if (FlxG.gamepads.anyPressed(GamepadIDs.START)) {			//Use start for going to playstate
			FlxG.switchState(new PlayState());
		}
		super.update();
	}
	
	//Cleanup
	override public function destroy():Void
	{
		super.destroy();
		_btnPlay = FlxDestroyUtil.destroy(_btnPlay);
		_btnOptions = FlxDestroyUtil.destroy(_btnOptions);
		_btnControls = FlxDestroyUtil.destroy(_btnControls);
		_btnCredits = FlxDestroyUtil.destroy(_btnCredits);
		_btnQuit = FlxDestroyUtil.destroy(_btnQuit);
		_title1 = FlxDestroyUtil.destroy(_title1);
		_map = null;
		_mWalls = FlxDestroyUtil.destroy(_mWalls);
	}
}