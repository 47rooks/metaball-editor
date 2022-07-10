package ui;

import EquationSystem.ErrorData;
import haxe.ui.components.TextField;
import haxe.ui.containers.VBox;
import haxe.ui.containers.dialogs.Dialog.DialogButton;
import haxe.ui.containers.dialogs.Dialogs;
import haxe.ui.containers.dialogs.MessageBox.MessageBoxType;
import haxe.ui.containers.dialogs.OpenFileDialog;
import haxe.ui.containers.dialogs.SaveFileDialog;
import haxe.ui.data.ArrayDataSource;
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
@:build(haxe.ui.ComponentBuilder.build("assets/ui/editor-view.xml"))
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

		for (i in 0...5)
		{
			falloffEquations.dataSource.add(new FalloffEquationRow());
		}
		xyTransform.dataSource.add(new XYTransformRow());

		_saveRequired = false;

		saveDefinitionButton.disabled = _saveRequired;
	}

	@:bind(generateButton, MouseEvent.CLICK)
	private function onGenerate(e:MouseEvent)
	{
		generateButton.disabled = true;

		// Process the equations
		var uiInputs = marshalInputs();
		var errors = _generateButtonCbk(uiInputs);
		if (errors != null)
		{
			for (err in errors)
			{
				switch (err.eqnType)
				{
					case FALLOFF:
						var r = falloffEquations.getComponentAt(err.eqnNumber).getComponentAt(err.eqnFieldNumber);
						var errField = r.findComponent("theError");
						errField.text = err.errorMsg;
						errField.addClass("invalid-value");
						errField.show();
					case XY_TRANSFORM:
				}
			}
		}
		generateButton.disabled = false;
	}

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
			y: Std.parseInt(ypixels.text)
		}
	}

	@:bind(saveDefinitionButton, MouseEvent.CLICK)
	private function onSaveDef(e:MouseEvent)
	{
		saveDefinitionButton.disabled = true;
		var dialog = new SaveFileDialog();
		dialog.options = {
			title: "Save Metaball Definition",
			writeAsBinary: false,
			extensions: FileDialogTypes.TEXTS
		}
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

	private function clearUI():Void
	{
		xpixels.text = "256";
		ypixels.text = "256";
	}

	private function unmarshalDefinitionToUI(definitionText:String):Void
	{
		clearUI();
		var definition:UIInputs = haxe.Json.parse(definitionText);
		falloffEquations.dataSource.clear();
		for (indx => foe in definition.falloffFunctions)
		{
			falloffEquations.dataSource.add(new FalloffEquationRow(foe[0], foe[1], foe[2], foe[3], foe[4], foe[5]));
		}

		xyTransform.dataSource.clear();
		var xyT = definition.xyTransform;
		xyTransform.dataSource.add(new XYTransformRow(xyT[0], xyT[1], xyT[2]));

		xpixels.text = Std.string(definition.x);
		ypixels.text = Std.string(definition.y);
	}

	@:bind(loadDefinitionButton, MouseEvent.CLICK)
	private function onLoadDef(e:MouseEvent)
	{
		var dialog = new OpenFileDialog();
		dialog.options = {
			readContents: true,
			title: "Open Metaball Definition File",
			readAsBinary: false,
			extensions: FileDialogTypes.TEXTS
		};
		dialog.onDialogClosed = function(event)
		{
			if (event.button == DialogButton.OK)
			{
				unmarshalDefinitionToUI(dialog.selectedFiles[0].text);
				onGenerate(null);
			}
		}
		dialog.show();
	}

	@:bind(exitButton, MouseEvent.CLICK)
	private function onExitButton(e:MouseEvent)
	{
		Sys.exit(0);
	}
}
