package;

import errors.ErrorData;
import errors.ErrorDataBuilder;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import ui.EditorView.UIInputs;
import ui.EditorView;

/**
 * The Metaball Editor state is used for processing equation input and driving the display of the metaball.
 */
class MEState extends FlxState
{
	final UI_WIDTH:Int;

	/**
	 * Display pane camera for the editor
	 */
	var _demoCamera:FlxCamera;

	/**
	 * The system of equations defining the metaball
	 */
	var _equations:EquationSystem;

	/**
	 * Indicator indicating that the formulae are valid and have been updated and the metaball may be created and drawn.
	 */
	var _formulaeUpdated:Bool = false;

	/**
	 * The width of the metaball in pixels
	 */
	var _mbWidth:Int;

	/**
	 * The height of the metaball in pixels
	 */
	var _mbHeight:Int;

	/**
	 * The center of the display pane
	 */
	var _demoPaneCenter:FlxPoint;

	/**
	 * The sprite to display the metaball
	 */
	var _editorSprite:Metaball;

	/*
	 * These are border corner sprites which are drawn and the corners of the metaball to show the extent of the metaball image.
	 */
	var _topLeft:FlxSprite;
	var _bottomLeft:FlxSprite;
	var _topRight:FlxSprite;
	var _bottomRight:FlxSprite;

	override public function new()
	{
		super();
		UI_WIDTH = 900;
	}

	override public function create():Void
	{
		super.create();

		// Add UI to default camera
		FlxG.camera.width = UI_WIDTH;
		FlxG.camera.bgColor = 0xFFFFFFFF;

		// Create the camera to display the metaball
		_demoCamera = new FlxCamera(UI_WIDTH, 0, FlxG.width - UI_WIDTH, FlxG.height);
		FlxG.cameras.add(_demoCamera, false);
		_demoCamera.bgColor = FlxColor.BLACK;
		_demoCamera.bgColor.alphaFloat = 0.0;

		// Add UI view
		var ev = new EditorView(UI_WIDTH, generateCallback);
		add(ev);

		// Setup the metaball display area
		_demoPaneCenter = getDisplayPaneCenter();
	}

	/**
	 * This callback receives the equations from the UI and processes them so that a metaball can be created.
	 * @param falloffFunctions the functions defining the falloff
	 * @param xyTransform if supplied a function which transform x and y into an intermediate variable usually
	 * used as a domain variable in the falloff equations.
	 * @param mbWidth the width in pixels of the final metaball image
	 * @param mbHeight the height in pixels of the final metaball image
	 * @return Null<Array<ErrorData>> if there are errors in the input equations error data is returned, otherwise null.
	 */
	private function generateCallback(uiInputs:UIInputs):Null<ErrorData>
	{
		// Process the input
		if (uiInputs.clear)
		{
			clearDisplayPane();
			return null;
		}
		try
		{
			var edb = new ErrorDataBuilder();
			// Vaidate width and height before the EquationSystem validation is done.
			// This will make sure we get all possible validation errors in a single pass.
			if (uiInputs.x <= 0)
			{
				edb.setXPixelError({errorMsg: 'X pixels must be a positive integer'});
			}
			if (uiInputs.y <= 0)
			{
				edb.setYPixelError({errorMsg: 'Y pixels must be a positive integer'});
			}
			_equations = new EquationSystem(uiInputs.falloffFunctions, uiInputs.xyTransform, edb);

			// If there are errors then clear the display and return the errors for display to the user.
			// This handles errors where the EquationSystem is ok but other validations failed.
			if (edb.hasErrors)
			{
				clearDisplayPane();
				return edb.emit();
			}

			_mbWidth = uiInputs.x;
			_mbHeight = uiInputs.y;
			_formulaeUpdated = true;
		}
		catch (e:ESException)
		{
			// This case handles errors thrown out of the EquationSystem validation. It will also include
			// any other failure information from other validations.
			clearDisplayPane();
			return e.errors.emit();
		}
		return null;
	}

	/**
	 * Get the center of the display panel
	 * @return FlxPoint containing the coordinates of the center.
	 */
	private function getDisplayPaneCenter():FlxPoint
	{
		return new FlxPoint((FlxG.width - UI_WIDTH) / 2, FlxG.height / 2);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (FlxG.keys.justReleased.ESCAPE)
		{
			Sys.exit(0);
		}

		// If the equations are valid and have changed redraw the metaball sprite.
		if (_formulaeUpdated)
		{
			// Remove old sprite if there is one
			if (_editorSprite != null)
			{
				remove(_editorSprite);
			}

			clearCornerMarkers();

			// Create new metaball bitmap
			var mb = new MetaballBuilder(_equations, _mbWidth, _mbHeight);
			var bmd = mb.generate();
			_editorSprite = new Metaball(_demoPaneCenter.x, _demoPaneCenter.y, bmd, _demoCamera);
			add(_editorSprite);

			// Add corner marker sprites
			addUpdateCornerMarkers();

			// clear the formulaeUpdated flag so we only do this once per new set of equations
			_formulaeUpdated = false;
		}
	}

	private function clearDisplayPane():Void
	{
		clearCornerMarkers();
		remove(_editorSprite);
		_editorSprite = null;
	}

	private function clearCornerMarkers():Void
	{
		remove(_topLeft);
		remove(_bottomLeft);
		remove(_topRight);
		remove(_bottomRight);
	}

	/**
	 * Create small corner markers at the edge of the metaball sprite.
	 * FIXME This does not handle the case where the metaball image is less than 16 x 16 pixels, which will
	 * result in a noughts and crossed grid being drawn.
	 */
	private function addUpdateCornerMarkers():Void
	{
		final LINE_LENGTH = 20;
		final LINE_THICKNESS = 2;
		var horiz = new FlxSprite();
		horiz.makeGraphic(LINE_LENGTH, LINE_THICKNESS, FlxColor.WHITE);
		var vert = new FlxSprite();
		vert.makeGraphic(LINE_THICKNESS, LINE_LENGTH, FlxColor.WHITE);
		_topLeft = new FlxSprite().makeGraphic(LINE_LENGTH, LINE_LENGTH, FlxColor.TRANSPARENT);
		_topLeft.stamp(horiz);
		_topLeft.stamp(vert);

		// top left
		_topLeft.x = _demoPaneCenter.x - Math.floor(_mbWidth / 2) - LINE_THICKNESS;
		_topLeft.y = _demoPaneCenter.y - Math.floor(_mbHeight / 2) - LINE_THICKNESS;
		_topLeft.cameras = [_demoCamera];
		add(_topLeft);

		_topRight = new FlxSprite().loadGraphicFromSprite(_topLeft);
		_topRight.angle = 90;
		_topRight.x = _demoPaneCenter.x + Math.floor(_mbWidth / 2) + LINE_THICKNESS - _topRight.width;
		_topRight.y = _topLeft.y;
		_topRight.cameras = [_demoCamera];
		add(_topRight);

		_bottomLeft = new FlxSprite().loadGraphicFromSprite(_topLeft);
		_bottomLeft.angle = 270;
		_bottomLeft.x = _topLeft.x;
		_bottomLeft.y = _demoPaneCenter.y + Math.floor(_mbHeight / 2) + LINE_THICKNESS - _bottomLeft.height;
		_bottomLeft.cameras = [_demoCamera];
		add(_bottomLeft);

		_bottomRight = new FlxSprite().loadGraphicFromSprite(_topLeft);
		_bottomRight.angle = 180;
		_bottomRight.x = _topRight.x;
		_bottomRight.y = _bottomLeft.y;
		_bottomRight.cameras = [_demoCamera];
		add(_bottomRight);
	}
}
