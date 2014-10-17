package state ;

import flixel.FlxG;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxBar;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import flixel.util.FlxDestroyUtil;
import flixel.util.FlxSave;
import util.FileReg;
using flixel.util.FlxSpriteUtil;

/**
 * ...
 * @author Glynn Taylor
 * State for displaying options such as volume
 */
class OptionsState extends FlxState
{
	private var _txtTitle:FlxText;						//Title
	private var _barVolume:FlxBar;						//rect for volume progress
	private var _txtVolume:FlxText;						//"Volume" text
	private var _txtVolumeAmt:FlxText;					//Volume percent text
	private var _btnVolumeDown:FlxButton;				//Decrement vol button
	private var _btnVolumeUp:FlxButton;					//Increment vol button
	private var _btnClearData:FlxButton;				//Clear saved setting
	private var _btnBack:FlxButton;						//Back to menu button
	
	private var _save:FlxSave;							//Save object for saving settings
	
	//Initialisation
	override public function create():Void 
	{
		FlxG.mouse.visible = true;						//Ensure mouse visibility
		//TITLE SETUP
		_txtTitle = new FlxText(0, 20, 0, "Options", 22);
		_txtTitle.alignment = "center";
		_txtTitle.screenCenter(true, false);
		add(_txtTitle);
		
		_txtVolume = new FlxText(0, _txtTitle.y + _txtTitle.height + 10, 0, "Volume", 8);
		_txtVolume.alignment = "center";
		_txtVolume.screenCenter(true, false);
		add(_txtVolume);
		
		//VOLUME SETUP
		_btnVolumeDown = new FlxButton(8, _txtVolume.y + _txtVolume.height + 2, "-", clickVolumeDown);
		_btnVolumeDown.loadGraphic(FileReg.imgButton, true, 20,20);
		add(_btnVolumeDown);
		
		_btnVolumeUp = new FlxButton(FlxG.width - 28, _btnVolumeDown.y, "+", clickVolumeUp);
		_btnVolumeUp.loadGraphic(FileReg.imgButton, true, 20,20);
		add(_btnVolumeUp);
		
		_barVolume = new FlxBar(_btnVolumeDown.x + _btnVolumeDown.width + 4, _btnVolumeDown.y, FlxBar.FILL_LEFT_TO_RIGHT, Std.int(FlxG.width - 64), Std.int(_btnVolumeUp.height));
		_barVolume.createFilledBar(FlxColor.CHARCOAL, FlxColor.WHITE, true, FlxColor.WHITE);
		add(_barVolume);
		
		_txtVolumeAmt = new FlxText(0, 0, 200, Std.string( FlxG.sound.volume * 100) + "%", 8);
		_txtVolumeAmt.alignment = "center";
		_txtVolumeAmt.borderStyle = FlxText.BORDER_OUTLINE;
		_txtVolumeAmt.borderColor = FlxColor.CHARCOAL;
		_txtVolumeAmt.y = _barVolume.y + (_barVolume.height / 2) - (_txtVolumeAmt.height / 2);
		_txtVolumeAmt.screenCenter(true, false);
		add(_txtVolumeAmt);
		
		_btnClearData = new FlxButton((FlxG.width / 2) - 90, FlxG.height - 28, "Clear Data", clickClearData);
		add(_btnClearData);
		
		_btnBack = new FlxButton((FlxG.width/2)+10, FlxG.height-28, "Back", clickBack);
		add(_btnBack);
		
		_save = new FlxSave(); 							// create and bind our save object to "reflection"
		_save.bind("reflection");

		updateVolume();									// update our bar to show the current volume level
		
		FlxG.camera.fade(FlxColor.BLACK, .33, true);	//Fade in
		super.create();
	}
	
	//Erases saved data
	private function clickClearData():Void
	{
		_save.erase();
		FlxG.sound.volume = .5;							//Reset volume
		updateVolume();									//Update displayed volume
	}
	//Handles back button
	private function clickBack():Void
	{
		_save.close();
		FlxG.switchState(new MenuState());
	}
	
	//Handles decrementing volume
	private function clickVolumeDown():Void
	{
		FlxG.sound.volume -= 0.1;						//Update game sound vol
		_save.data.volume = FlxG.sound.volume;			//Update save vol
		updateVolume();									//Update display
	}
	//Handles incrementing volume
	private function clickVolumeUp():Void
	{
		FlxG.sound.volume += 0.1;
		_save.data.volume = FlxG.sound.volume;
		updateVolume();
	}
	//Updates the displayed volume text+bar
	private function updateVolume():Void
	{
		var vol:Int = Math.round(FlxG.sound.volume * 100);
		_barVolume.currentValue = vol;
		_txtVolumeAmt.text = Std.string(vol) + "%";
	}
	//Cleans up variables
	override public function destroy():Void 
	{
		super.destroy();
		_txtTitle = FlxDestroyUtil.destroy(_txtTitle);
		_barVolume = FlxDestroyUtil.destroy(_barVolume);
		_txtVolume = FlxDestroyUtil.destroy(_txtVolume);
		_txtVolumeAmt = FlxDestroyUtil.destroy(_txtVolumeAmt);
		_btnVolumeDown = FlxDestroyUtil.destroy(_btnVolumeDown);
		_btnVolumeUp = FlxDestroyUtil.destroy(_btnVolumeUp);
		_btnClearData = FlxDestroyUtil.destroy(_btnClearData);
		_btnBack = FlxDestroyUtil.destroy(_btnBack);
		_save.destroy();
		_save = null;
	}
}