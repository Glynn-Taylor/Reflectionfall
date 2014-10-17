package state ;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import flixel.util.FlxDestroyUtil;
import flixel.util.FlxSave;
using flixel.util.FlxSpriteUtil;

/**
 * ...
 * @author Glynn Taylor
 * Displays defineable text and a defineable title; provides a back to main menu button
 */
class InfoState extends FlxState
{
	private var _txtTitle:FlxText;				// The title text (set on creation)
	private var _txtMessage:FlxText;			// Message text to display (set on creation)
	private var _btnMainMenu:FlxButton;			// Button to go to main menu
	private var _text:String;					// Title text to set (passed into new)
	private var _msgText:String;				// Message text to set (passed into new)
	//Constructor
	public function new(text:String,msgtext:String) 
	{
		super();
		_text = text;							//Store text
		_msgText = msgtext;
	}
	
	override public function create():Void 
	{
		FlxG.mouse.visible = true;				//Ensure mouse visibility
		bgColor = 0x000000;						//Ensure BG color
		//Create UI
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
		
		_txtMessage = new FlxText(0, (FlxG.height / 2) - 18, 0,_msgText, 8);
		_txtMessage.alignment = "center";
		_txtMessage.screenCenter(true, false);
		add(_txtMessage);
		
		_btnMainMenu = new FlxButton(0, FlxG.height - 32, "Main Menu", goMainMenu);
		_btnMainMenu.screenCenter(true, false);
		add(_btnMainMenu);
		
		super.create();
		FlxG.camera.fade(FlxColor.BLACK, .33, true);	//Fade in
	}
	
	
	//When the user hits the main menu button, it should fade out and then take them back to the MenuState
	private function goMainMenu():Void
	{
		FlxG.camera.fade(FlxColor.BLACK, .33, false, function() {
			FlxG.switchState(new MenuState());
		});
	}
	//Cleanup
	override public function destroy():Void 
	{
		super.destroy();
		_txtTitle = FlxDestroyUtil.destroy(_txtTitle);
		_txtMessage = FlxDestroyUtil.destroy(_txtMessage);
		_btnMainMenu = FlxDestroyUtil.destroy(_btnMainMenu);
		_text = null;
		_msgText = null;
	}
	
}