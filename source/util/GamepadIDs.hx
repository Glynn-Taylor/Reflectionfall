package util ;

import flixel.input.gamepad.XboxButtonID;
import flixel.input.gamepad.OUYAButtonID;

/**
 * NOTE: This should probably be inside FlxGamepad.
 * @author crazysam, edits by Glynn Taylor
 * Handles compilation specific IDs
 */
class GamepadIDs
{
	public static inline var A = #if (OUYA) OUYAButtonID.O #else XboxButtonID.A #end;
	public static inline var B = #if (OUYA) OUYAButtonID.A #else XboxButtonID.B #end;
	public static inline var X = #if (OUYA) OUYAButtonID.U #else XboxButtonID.X #end;
	public static inline var Y = #if (OUYA) OUYAButtonID.Y #else XboxButtonID.Y #end;
	public static inline var LB = #if (OUYA) OUYAButtonID.LB #else XboxButtonID.LB #end;
	public static inline var RB = #if (OUYA) OUYAButtonID.RB #else XboxButtonID.RB #end;
	public static inline var RT = #if (OUYA) OUYAButtonID.RB #else XboxButtonID.RIGHT_TRIGGER #end;
	public static inline var LT = #if (OUYA) OUYAButtonID.LB #else XboxButtonID.LEFT_TRIGGER #end;
	public static inline var START = #if (OUYA) OUYAButtonID.RIGHT_ANALOGUE #else XboxButtonID.START #end; // hax: there's no start button on the OUYA
	public static inline var SELECT = #if (OUYA) OUYAButtonID.LEFT_ANALOGUE #else XboxButtonID.BACK #end;
	public static inline var LEFT_ANALOGUE = #if (OUYA) OUYAButtonID.LEFT_ANALOGUE #else XboxButtonID.LEFT_ANALOGUE #end;
	public static inline var RIGHT_ANALOGUE = #if (OUYA) OUYAButtonID.RIGHT_ANALOGUE #else XboxButtonID.RIGHT_ANALOGUE #end;
	public static inline var LEFT_ANALOGUE_X = #if (OUYA) OUYAButtonID.LEFT_ANALOGUE_X #else XboxButtonID.LEFT_ANALOGUE_X #end;
	public static inline var LEFT_ANALOGUE_Y = #if (OUYA) OUYAButtonID.LEFT_ANALOGUE_Y #else XboxButtonID.LEFT_ANALOGUE_Y #end;
	public static inline var RIGHT_ANALOGUE_X = #if (OUYA) OUYAButtonID.RIGHT_ANALOGUE_X #else XboxButtonID.RIGHT_ANALOGUE_X #end;
	public static inline var RIGHT_ANALOGUE_Y = #if (OUYA) OUYAButtonID.RIGHT_ANALOGUE_Y #else XboxButtonID.RIGHT_ANALOGUE_Y #end;
	public static inline var DPAD_UP:Int = #if (OUYA) OUYAButtonID.RIGHT_ANALOGUE_Y #else XboxButtonID.DPAD_UP #end;
	public static inline var DPAD_DOWN:Int = 13;
	public static inline var DPAD_LEFT:Int = 14;
	public static inline var DPAD_RIGHT:Int = 15;
	public static inline var LogiA:Int = 2;
	public static inline var LogiX:Int = 3;
	
}