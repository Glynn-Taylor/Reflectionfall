package state ;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.input.gamepad.FlxGamepad;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import flixel.util.FlxDestroyUtil;
import flixel.util.FlxSave;
import util.GamepadIDs;
using flixel.util.FlxSpriteUtil;
/**
 * ...
 * @author Glynn Taylor
 * Class that handles displaying victory text and allows for rematches/going back to menu
 */
class EndGameState extends FlxState
{
	private var _txtTitle:FlxText;		// the title text
	private var _txtMessage:FlxText;	// the final score message text
	private var _btnMainMenu:FlxButton;	// button to go to main menu
	private var _btnRematch:FlxButton;
	private var _text:String;
	//Constructor
	public function new(text:String) 
	{
		super();
		_text = text;
	}
	//Initialisation
	override public function create():Void 
	{
		FlxG.mouse.visible = true;							//Ensure mouse visibility
		bgColor = 0x000000;									//Ensure BG color
		//UI Creation//
		_txtTitle = new FlxText(0, 20, 0, _text, 22);
		_txtTitle.alignment = "center";
		_txtTitle.screenCenter(true, false);
		_txtTitle.size = 32;
		_txtTitle.x -= 20;
		_txtTitle.borderStyle = FlxText.BORDER_SHADOW;
		_txtTitle.borderSize = 2;
		_txtTitle.borderColor = 0x555555;
		_txtTitle.antialiasing = false;
		add(_txtTitle);
		
		_btnMainMenu = new FlxButton(0, FlxG.height - 32, "Main Menu (select)", goMainMenu);
		_btnMainMenu.screenCenter(true, false);
		add(_btnMainMenu);
		_btnRematch = new FlxButton(0, FlxG.height - 64, "Rematch (start)", goPlay);
		_btnRematch.screenCenter(true, false);
		add(_btnRematch);
		
		super.create();
		FlxG.camera.fade(FlxColor.BLACK, .33, true);		//Fadein
		FlxG.gamepads.reset();
	}
	override public function update():Void 
	{
		
			if (FlxG.gamepads.anyPressed(GamepadIDs.START)) {	//Check if pressed start, if so rematch
				FlxG.switchState(new PlayState());
			}else if (FlxG.gamepads.anyPressed(GamepadIDs.SELECT)) {	//Check if select, if so go back to main menu
				FlxG.switchState(new MenuState());
			}
			super.update();
		
	}
	
	//When the user hits the main menu button, it should fade out and then take them back to the MenuState
	private function goMainMenu():Void
	{
		FlxG.camera.fade(FlxColor.BLACK, .66, false, function() {
			FlxG.switchState(new MenuState());
		});
	}
	//When the user hits the rematch button, it should fade out and then take them back to the PlayState
	private function goPlay():Void
	{
		FlxG.camera.fade(FlxColor.BLACK, .66, false, function() {
			FlxG.switchState(new PlayState());
		});
	}
	//Cleanup
	override public function destroy():Void 
	{
		super.destroy();
		_txtTitle = FlxDestroyUtil.destroy(_txtTitle);
		_txtMessage = FlxDestroyUtil.destroy(_txtMessage);
		_btnMainMenu = FlxDestroyUtil.destroy(_btnMainMenu);
		_btnRematch= FlxDestroyUtil.destroy(_btnRematch);
		_text = null;
	}
	
}