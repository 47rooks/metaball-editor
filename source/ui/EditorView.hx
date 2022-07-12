package ui;

import errors.ErrorData;
import haxe.ui.components.TextField;
import haxe.ui.containers.VBox;
import haxe.ui.containers.dialogs.Dialog.DialogButton;
import haxe.ui.containers.dialogs.Dialogs;
import haxe.ui.containers.dialogs.MessageBox.MessageBoxType;
import haxe.ui.containers.dialogs.OpenFileDialog;
import haxe.ui.containers.dialogs.SaveFileDialog;
import haxe.ui.data.ArrayDataSource;
import haxe.ui.events.MouseEvent;
import haxe.ui.events.UIEvent;

/**
 * Structure definition for marshalled UI input information.
 */
typedef UIInputs =
{
	/**
	 * The falloff equations with an array of strings per row, and an array of rows.
	 */
	var falloffFunctions:Array<Array<String>>;

	/**
	 * The XY transform equation. Currently only a single equation is supported.
	 */
	var xyTransform:Array<String>;

	/**
	 * The width of the metaball in pixels.
	 */
	var x:Int;

	/**
	 * The height of the metaball in pixels.
	 */
	var y:Int;

	/**
	 * If true indicates that the user chose to clear all the editor fields and the display pane.
	 * If this field is true all other fields are ignored.
	 */
	var clear:Bool;
}

/**
 * EditorView provides the UI for enter equations and other parameters. It also provides support for
 * saving and loading metaball definitions and images.
 */
@:build(haxe.ui.ComponentBuilder.build("assets/ui/editor-view.xml"))
class EditorView extends VBox
{
	var _generateButtonCbk:(uiInputs:UIInputs) -> Null<ErrorData>;
	var _uiWidth:Int;

	@:bind(saveDefinitionButton.disabled)
	var _saveRequired:Bool = true;

	final DEFAULT_MB_WIDTH = "256";
	final DEFAULT_MB_HEIGHT = "256";

	/**
	 * Constructor
	 *
	 * @param uiWidth - width of the UI portion of the window in pixels
	 * @param generateButtonCbk - function to call when the generate button it pressed. Receives the
	 * input collected in the UI.
	 */
	public function new(uiWidth:Int, generateButtonCbk:(uiInputs:UIInputs) -> Null<ErrorData>)
	{
		super();
		_uiWidth = uiWidth;
		_generateButtonCbk = generateButtonCbk;

		clearDefinitions();
	}

	/**
	 * Process the input data and trigger the metaball generation.
	 * @param e the mouse event, currently ignored.
	 */
	@:bind(generateButton, MouseEvent.CLICK)
	private function onGenerate(e:MouseEvent)
	{
		// Prevent multiple generations as this is a long operation
		generateButton.disabled = true;

		// Process the equations
		var uiInputs = marshalInputs();
		var errors = _generateButtonCbk(uiInputs);

		// Process all errors and update the UI error fields
		if (errors != null)
		{
			for (err in errors.falloffEquationErrors)
			{
				var r = falloffEquations.getComponentAt(err.eqnNumber).getComponentAt(err.eqnFieldNumber);
				var errField = r.findComponent("theError");
				var valField = r.findComponent("theValue");
				errField.text = err.errorMsg;
				valField.addClass("invalid-value"); // Move to the textfield not the error
				errField.show();
			}
			for (err in errors.xyTransformErrors)
			{
				var r = xyTransform.getComponentAt(err.eqnNumber).getComponentAt(err.eqnFieldNumber);
				var errField = r.findComponent("theError");
				var valField = r.findComponent("theValue");
				errField.text = err.errorMsg;
				valField.addClass("invalid-value");
				errField.show();
			}
			if (errors.xpixelError != null)
			{
				xpixelsError.text = errors.xpixelError.errorMsg;
				xpixels.addClass("invalid-value");
				xpixelsError.show();
			}
			if (errors.ypixelError != null)
			{
				ypixelsError.text = errors.ypixelError.errorMsg;
				ypixels.addClass("invalid-value");
				ypixelsError.show();
			}
		}
		// Reenable generation
		generateButton.disabled = false;
	}

	/**
	 * Reset the width error field and invalid-value class if they have been set.
	 * This is triggered when a user updates the field with the error.
	 * @param _ MouseEvent, currently ignored
	 */
	@:bind(xpixels, UIEvent.CHANGE)
	private function onXpixelsChange(_)
	{
		if (xpixelsError != null)
		{
			xpixelsError.text = null;
			xpixels.removeClass("invalid-value");
			xpixelsError.hide();
		}
	}

	/**
	 * Reset the height error field and invalid-value class if they have been set.
	 * This is triggered when a user updates the field with the error.
	 * @param _ MouseEvent, currently ignored
	 */
	@:bind(ypixels, UIEvent.CHANGE)
	private function onYpixelsChange(_)
	{
		if (ypixelsError != null)
		{
			ypixelsError.text = null;
			ypixels.removeClass("invalid-value");
			ypixelsError.hide();
		}
	}

	/**
	 * Marshal inputs from the UI fields into a UIInputs structure for further processing downstream.
	 * @return UIInputs
	 */
	private function marshalInputs():UIInputs
	{
		// Get the falloff functions
		var falloffFunctions = new Array<Array<String>>();

		for (i in 0...falloffEquations.dataSource.size)
		{
			var eqnStr = new Array<String>();
			var r:FalloffEquationRow = falloffEquations.dataSource.get(i);
			if (r.outVar != null && r.outVar.length > 0 && r.eqn != null && r.eqn.length > 0)
			{
				falloffFunctions.push(r.toArray());
			}
		}

		// Get the xy transform if one is specified
		var xyT:XYTransformRow = xyTransform.dataSource.get(0);
		var txfrmEqn = xyT.toArray();
		if (txfrmEqn[0] == null || txfrmEqn[2] == null)
		{
			// Do not retain a null or partly null entry
			txfrmEqn = new Array<String>();
		}

		return {
			falloffFunctions: falloffFunctions,
			xyTransform: txfrmEqn,
			x: Std.parseInt(xpixels.text),
			y: Std.parseInt(ypixels.text),
			clear: false
		}
	}

	/**
	 * Save the definition to a JSON file.
	 * @param e MouseEvent, currently ignored.
	 */
	@:bind(saveDefinitionButton, MouseEvent.CLICK)
	private function onSaveDef(e:MouseEvent)
	{
		// Prevent multiple saves concurrently
		saveDefinitionButton.disabled = true;
		// Create the file save dialog itself
		var dialog = new SaveFileDialog();
		dialog.options = {
			title: "Save Metaball Definition",
			writeAsBinary: false,
			extensions: FileDialogTypes.TEXTS
		}
		// Callback to handle OK. Cancel has no special handling.
		dialog.onDialogClosed = function(event)
		{
			if (event.button == DialogButton.OK)
			{
				var mb = Dialogs.messageBox("Definition saved!", "Notification", MessageBoxType.TYPE_INFO);
				mb.left = Math.floor(_uiWidth / 2 - mb.width / 2);
			}
		}
		dialog.fileInfo = {
			name: "equations.json",
			text: haxe.Json.stringify(marshalInputs())
		}
		dialog.show();
		saveDefinitionButton.disabled = false;
	}

	// Reset the UI elements that need special handling.
	private function clearUI():Void
	{
		xpixels.text = DEFAULT_MB_WIDTH;
		ypixels.text = DEFAULT_MB_HEIGHT;
	}

	/**
	 * Populate the UI with data unmarshalled from a JSON string.
	 * @param definitionText the JSON data
	 */
	private function unmarshalDefinitionToUI(definitionText:String):Void
	{
		clearUI();
		var definition:UIInputs = haxe.Json.parse(definitionText);
		falloffEquations.dataSource.clear();
		for (foe in definition.falloffFunctions)
		{
			falloffEquations.dataSource.add(new FalloffEquationRow(foe[0], foe[1], foe[2], foe[3], foe[4], foe[5]));
		}

		xyTransform.dataSource.clear();
		var xyT = definition.xyTransform;
		xyTransform.dataSource.add(new XYTransformRow(xyT[0], xyT[1], xyT[2]));

		xpixels.text = Std.string(definition.x);
		ypixels.text = Std.string(definition.y);
	}

	/**
	 * Load a metaball definition from a JSON file.
	 * @param e MouseEvent, currently ignored.
	 */
	@:bind(loadDefinitionButton, MouseEvent.CLICK)
	private function onLoadDef(e:MouseEvent)
	{
		// Create the file open dialog itself.
		var dialog = new OpenFileDialog();
		dialog.options = {
			readContents: true,
			title: "Open Metaball Definition File",
			readAsBinary: false,
			extensions: FileDialogTypes.TEXTS
		};
		// Callback to handle OK. Cancel has no special handling.
		dialog.onDialogClosed = function(event)
		{
			if (event.button == DialogButton.OK)
			{
				// Unmarshal the data and call generate to populate the display.
				unmarshalDefinitionToUI(dialog.selectedFiles[0].text);
				onGenerate(null);
			}
		}
		dialog.show();
	}

	/**
	 * Callback for the Clear Definition button
	 * @param e 
	 */
	@:bind(clearDefinitionButton, MouseEvent.CLICK)
	private function onClear(e:MouseEvent)
	{
		// Prevent double click on the clear button though this operation is idempotent
		// and very quick.
		clearDefinitionButton.disabled = true;
		clearDefinitions();
		clearDefinitionButton.disabled = false;
	}

	// Clear the editor and display pane.
	private function clearDefinitions():Void
	{
		generateButton.disabled = true;
		_saveRequired = false;

		// Clear existing data
		falloffEquations.dataSource.clear();
		xyTransform.dataSource.clear();
		// Create new empty rows
		for (i in 0...5)
		{
			falloffEquations.dataSource.add(new FalloffEquationRow());
		}
		xyTransform.dataSource.add(new XYTransformRow());
		// Reset pixel width and height to defaults
		xpixels.text = DEFAULT_MB_WIDTH;
		ypixels.text = DEFAULT_MB_HEIGHT;

		// Call generate callback with clear flag set
		_generateButtonCbk({
			falloffFunctions: new Array<Array<String>>(),
			xyTransform: new Array<String>(),
			x: Std.parseInt(xpixels.text),
			y: Std.parseInt(ypixels.text),
			clear: true
		});
	}

	/**
	 * Callback for the exit button
	 * @param e Mouse event, currently ignored.
	 */
	@:bind(exitButton, MouseEvent.CLICK)
	private function onExitButton(e:MouseEvent)
	{
		Sys.exit(0);
	}
}
