package player ;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxPoint;
import flixel.util.FlxTimer;
import openfl.Lib;

/**
 * ...
 * @author Glynn Taylor
 * Arrow sprite and logic
 */
class Arrow extends FlxSprite 
{
	//Constant vars
	private static inline var SPEED:Float = 200;
	//Data vars
	public  var _canPickup:Bool = true;
	//Constructor
	public function new(x:Int,y:Int) 
	{
		super(x,y);
		makeGraphic(8, 2);								//Create box graphic
		width = 2;		
		height = 2;
		
		exists = false;
		elasticity = 1;
	}
	//Handles angle parts of the firing (velocity and rotation), plus anti-immediate pickup
	public function degShoot(deg:Float):Void
	{
		angle = radToDeg(deg);
		
		velocity.x += SPEED * Math.cos(deg);
		velocity.y += SPEED * Math.sin(deg);
		
		_canPickup = false;								//Prevent pickup on fire
		new FlxTimer(0.2, canPickupAgain, 1);			//Restore picking up in 0.2 seconds
	}
	//Changes the angle of the graphic to reflect the new angle after bouncing
	public function resetAngle():Void
	{
		angle = radToDeg(Math.atan2(velocity.y, velocity.x));
	}
	//Makes the arrow available to pickup again after a short delay
	private function canPickupAgain(Timer:FlxTimer):Void {
		_canPickup = true;
	}
	//Converts radians to degrees
	public inline static function radToDeg(rad:Float):Float
	{
		return 180 / Math.PI * rad;
	}
	//Cleanup
	override public function destroy():Void 
	{
		super.destroy();
		_canPickup = null;
	}
}