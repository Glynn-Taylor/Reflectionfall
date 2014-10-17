package state ; 
import flixel.addons.editors.ogmo.FlxOgmoLoader;
import flixel.effects.particles.FlxEmitter;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup;
import flixel.group.FlxTypedGroup;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tile.FlxTilemap;
import flixel.util.FlxColor;
import flixel.util.FlxDestroyUtil;
import flixel.util.FlxRandom;
import flixel.util.FlxTimer;
import openfl.Assets;
import openfl.geom.Point;
import openfl.Lib;
import player.Arrow;
import player.Player;
import util.FileReg;

/**
 * ...
 * @author Glynn Taylor
 * The main game (play) state
 */
class PlayState extends FlxState
{
	//Constants
	private static inline var _ARROW_POOL_LIMIT:Int = 18; //Number of recyclable arrows, norm app is 3
	//Map var
	private var _map:FlxOgmoLoader;
	private var _mWalls:FlxTilemap;
	private var _mDecals:FlxTilemap;
	private var _SpawnPoints:List<Point> = new List<Point>();
	//Group var
	private var _grpPlayers:FlxTypedGroup<Player>;
	public var _grpArrows:FlxTypedGroup<Arrow>;
	//Emitter var
	private var _gibs:FlxEmitter;
	//Util var
	private var _colorMap:Map<Int,String> = [0xFF0000 => "Red", 0x00FF00 => "Green", 0x0000FF => "Blue", 0xFFFF00 => "Yellow", 0x00FFFF => "???"];
	private var _sndHit:FlxSound;
	private var _sndPickup:FlxSound;
	private var _victoryString:String = "";				//Temp store for victory string to enable pause before state transistion
	
	//Initialisation
	override public function create():Void 
	{
		//MAP//
		_map = new FlxOgmoLoader(FileReg.dataLevel_1);	//Load level
		_mWalls = _map.loadTilemap(FileReg.imgTiles, 16, 16, "tiles");	//Load walls with tilesheet using tiles layer
		_mWalls.setTileProperties(1, FlxObject.NONE);	//Set tile 1 to be non collidable
		_mWalls.setTileProperties(2, FlxObject.ANY);	//Set tile 2 to be collidable, makes 2+ collidable too if not set further
		_mWalls.immovable = true;						//Ensure wall immovable (default)
		add(_mWalls);									//Add walls to scene
		
		_map.loadEntities(createSpawns, "entities");	//Create spawning positions
		
		//UTIL//
		FlxG.mouse.visible = false;						//Hide Cursor
		_sndHit = FlxG.sound.load(FileReg.sndHit);		//Load sound hit
		_sndPickup = FlxG.sound.load(FileReg.sndPickup);//Load sound pickup
		
		_gibs = new FlxEmitter();						//Create emitter for gibs
		_gibs.setXSpeed( -150, 150);					//Gib settings
		_gibs.setYSpeed( -200, 0);
		_gibs.acceleration.y = 400;						//Add gravity to gibs
		_gibs.setRotation( -720, 720);
		_gibs.makeParticles(FileReg.imgGibs, 25, 16, true, .5);	//Setup gib tilesheet
		add(_gibs);										//Add gibs to scene
		
		//PLAYER GENERATION//
		_grpPlayers = new FlxTypedGroup<Player>();		//Create player group
		add(_grpPlayers);								//Add player group to scene
		
		var colours : Array<Int> = [0xFF0000,0x00FF00,0x0000FF,0xFFFF00,0x00FFFF];	//Colours for players
		for (i in 0...FlxG.gamepads.numActiveGamepads) {
			var _p:Player = new Player(FlxG.width / 2 - 5, 30, i,colours[i]);	//Position changed on next line, stores pID and colour
			var pnt:Point = _SpawnPoints.pop(); 		//Get the next spawn point
			if(pnt!=null){								//Ensure enough spawnpoints (if not then keeps default)
				_p.x = pnt.x;
				_p.y = pnt.y;
			}
			_grpPlayers.add(_p);						//Add to group
		}
		
		//MAP//
		_mDecals = _map.loadTilemap("assets/images/decaltiles.png", 16, 16, "decal");	//Load map decals (after players so in front)
		_mDecals.setTileProperties(1, FlxObject.NONE);	//Set non collideable
		add(_mDecals);									//Add to scene
		
		//ARROW GENERATION//
		var arw:Arrow;
		_grpArrows = new FlxTypedGroup<Arrow>(_ARROW_POOL_LIMIT);
		for(i in 0 ... _ARROW_POOL_LIMIT)
		{
			arw = new Arrow( -100, -100);				//Instantiate a new arrow sprite offscreen
			_grpArrows.add(arw);						//Add it to the pool of arrows
		}
		add(_grpArrows);								//Add the group to the scen
		
		FlxG.camera.fade(FlxColor.BLACK, .33, true);	//Fade camera in
		super.create();
	}
	
	//Run every Frame
	override public function update():Void 
	{
		super.update();
		FlxG.collide( _mWalls, _grpArrows, ping); 		//Check arrows vs walls collision, ping ensures arrows rotate according to new dir
		FlxG.overlap( _grpArrows, _grpPlayers, arrowHit);	//Check arrows vs player collision, arrowhit resolves hits
		FlxG.collide(_grpArrows, _grpArrows);			//Check arrows vs arrows collision
		FlxG.collide(_gibs, _mWalls);					//Check gibs vs walls collision
		FlxG.collide(_mWalls, _grpPlayers);				//Check players vs walls collision
		
		checkAlive();									//Check if there is a victor
	}
	
	//Checks if there is a victor
	private function checkAlive ():Void {
		
		if(_victoryString==""){ 						//String check (to prevent using seperate bool) to prevent multiple timers
		
			if (_grpPlayers.length > 1 && _grpPlayers.countLiving() == 1) {	//If one player alive and >1 player existing
				
				var winner:Player = _grpPlayers.getFirstAlive();	//Get winner
				_victoryString = getColorText(winner.color) + "Wins!";	//Set victory string
				new FlxTimer(2, endGame, 1);			//Create pause before transition timer
			}else if (_grpPlayers.countLiving() == 0) {	//If no players alive
				
				_victoryString = "Draw";				//Set victory string
				new FlxTimer(2, endGame, 1);			//Create pause before transition timer
			}
		}
	}
	//Ends the game and transitions to new state with victory string
	private function endGame(Timer:FlxTimer):Void
	{
		FlxG.camera.fade(FlxColor.BLACK, .66, false, function() {	//Fade out
			FlxG.switchState(new EndGameState(_victoryString));	//Switch state
		});
	}
	
	//Translates a color to the string equivalent if the int->String exists in _colorMap
	function getColorText(color:Int) :String
	{
		if (_colorMap.exists(color)) {
			return _colorMap.get(color);
		}else {
			return "???";								//Not in the map
		}
	}
	//Get all of the spawn positions from the oel
	private function createSpawns(entityName:String, entityData:Xml):Void
	{
		if (entityName == "player")						//If a spawn position
		{
			var x:Int = Std.parseInt(entityData.get("x"));
			var y:Int = Std.parseInt(entityData.get("y"));
			_SpawnPoints.add(new Point(x, y));			//Add the spawn point to the list
		}
		
	}
	//Updates the angle of the arrow after bounce (does not change bounding box/velocity just graphical)
	private function ping(wall:FlxObject, arw:FlxObject):Void
	{
		cast(arw, Arrow).resetAngle();					//Update angle of arrow after bounce
	}
	//Resolves arrows hits (arrow <-> player)
	private function arrowHit(arw:FlxObject, person:FlxObject):Void
	{
		var sArw:Arrow = cast(arw, Arrow);
		var sPerson:Player = cast(person, Player);
		
		if (sPerson.color != sArw.color) {				//If arrow not owned by player
			_gibs.at(sPerson);								//Set emitter location
			_gibs.start(true, 2.80);						//Emit
			sPerson.kill();									//Set player not alive (non rendered and non active)
			_sndHit.play();								//Play sound
		}else {												//If arrow owned by player (color set on firing (also allows for teams))
			if(sArw._canPickup){							//If arrow is not fresh (to prevent pickup on fire)
			sPerson.restoreArrow();							//Increment player ammo
			sArw.kill();									//Set arrow not alive (non rendered and non active)
			_sndPickup.play();								//Play sound
			}
		}
	}
	//Cleanup
	override public function destroy():Void 
	{
		super.destroy();
		_map = null;
		_mWalls= FlxDestroyUtil.destroy(_mWalls);
		_mDecals= FlxDestroyUtil.destroy(_mDecals);
		_SpawnPoints = null;
		_grpPlayers= FlxDestroyUtil.destroy(_grpPlayers);
		_grpArrows= FlxDestroyUtil.destroy(_grpArrows);
		_gibs= FlxDestroyUtil.destroy(_gibs);
		_colorMap = null;
		_sndHit= FlxDestroyUtil.destroy(_sndHit);
		_sndPickup= FlxDestroyUtil.destroy(_sndPickup);
		_victoryString = null;		
	}
}