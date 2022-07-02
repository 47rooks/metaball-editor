package;

import EquationSystem.ErrorData;
import haxe.ui.components.TextField;
import haxe.ui.containers.VBox;
import haxe.ui.containers.dialogs.Dialog.DialogButton;
import haxe.ui.containers.dialogs.Dialogs;
import haxe.ui.containers.dialogs.MessageBox.MessageBoxType;
import haxe.ui.containers.dialogs.SaveFileDialog;
import haxe.ui.events.MouseEvent;

typedef UIInputs =
{
	var falloffFunctions:Array<Array<String>>;
	var xyTransform:Array<String>;
	var x:Int;
	var y:Int;
}

/**
 * MainView provides the UI for enter equations and other parameters. It also provides support for
 * saving and loading metaball definitions and images.
 */
@:build(haxe.ui.ComponentBuilder.build("assets/editor-view.xml"))
class EditorView extends VBox
{
	var _generateButtonCbk:(uiInputs:UIInputs) -> Null<Array<ErrorData>>;
	var _uiWidth:Int;

	@:bind(saveDefinitionButton.disabled)
	var _saveRequired:Bool = true;

	/**
	 * Constructor
	 *
	 * @param uiWidth - width of the UI portion of the window in pixels
	 * @param generateButtonCbk - function to call when the generate button it pressed. Receives the
	 * input collected in the UI.
	 */
	public function new(uiWidth:Int, generateButtonCbk:(uiInputs:UIInputs) -> Null<Array<ErrorData>>)
	{
		super();
		_uiWidth = uiWidth;
		_generateButtonCbk = generateButtonCbk;

		_saveRequired = false;

		saveDefinitionButton.disabled = _saveRequired;
	}

	@:bind(generateButton, MouseEvent.CLICK)
	private function onGenerate(e:MouseEvent)
	{
		generateButton.disabled = true;

		// Process the equations
		var uiInputs = marshalInputs();
		var errors = _generateButtonCbk(uiInputs); // falloffFunctions,

		generateButton.disabled = false;
	}

	private function marshalInputs():UIInputs
	{
		// Get the falloff functions
		var falloffFunctions = new Array<Array<String>>();
		for (i in 0...falloffEquations.numComponents)
		{
			var r = falloffEquations.getComponentAt(i);
			var eqnStr = new Array<String>();
			for (j in 0...r.numComponents)
			{
				var c = r.getComponentAt(j);
				var tf = c.getComponentAt(0);
				eqnStr.push(tf.text);
			}
			if (eqnStr[0] != null && eqnStr[0].length > 0 && eqnStr[1] != null && eqnStr[1].length > 0)
			{
				// Only keep equations that are entered
				falloffFunctions.push(eqnStr);
			}
		}

		// Get the xy transform if one is specified
		var t = xyTransform.getComponentAt(0);
		var txfrmEqn = new Array<String>();
		for (j in 0...t.numComponents)
		{
			var c = t.getComponentAt(j);
			var tf = c.getComponentAt(0);
			txfrmEqn.push(tf.text);
		}
		if (txfrmEqn[0] == null || txfrmEqn[2] == null)
		{
			// Do not retain a null or partly null entry
			txfrmEqn = new Array<String>();
		}

		return {
			falloffFunctions: falloffFunctions,
			xyTransform: txfrmEqn,
			x: Std.parseInt(xpixels.text),
			y: Std.parseInt(ypixels.text)
		}
	}

	@:bind(saveDefinitionButton, MouseEvent.CLICK)
	private function onSaveDef(e:MouseEvent)
	{
		saveDefinitionButton.disabled = true;
		trace('json=${haxe.Json.stringify(marshalInputs())}');
		var dialog = new SaveFileDialog();
		dialog.options = {
			title: "Save Text File",
			writeAsBinary: false,
			extensions: FileDialogTypes.TEXTS
		}
		dialog.onDialogClosed = function(event)
		{
			if (event.button == DialogButton.OK)
			{
				var mb = Dialogs.messageBox("File saved!", "Save Result", MessageBoxType.TYPE_INFO);
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

	@:bind(exitButton, MouseEvent.CLICK)
	private function onExitButton(e:MouseEvent)
	{
		Sys.exit(0);
	}
}
