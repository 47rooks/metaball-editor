package ui.custom;

import haxe.ui.core.ItemRenderer;
import haxe.ui.events.UIEvent;

/**
 * ValueAndErrorRenderer is the Haxe companion class to the value-and-error-renderer.xml custom component definition. It provides callback and data wrangling support for the value and error fields.
 */
@:build(haxe.ui.ComponentBuilder.build("assets/ui/value-and-error-renderer.xml"))
class ValueAndErrorRenderer extends ItemRenderer
{
	public function new()
	{
		super();
	}

	/**
	 * When theValue field changes clear any current error information and push the data into the correct field in the dataSource.
	 * @param _ Change event, currently ignored.
	 */
	@:bind(theValue, UIEvent.CHANGE)
	private function onValue(_)
	{
		if (theError != null)
		{
			theError.text = null;
			theValue.removeClass("invalid-value");
			theError.hide();
		}
		if (this.data != null)
		{
			Reflect.setField(this.data, this.id, theValue.text);
			onDataChanged(this.data);
		}
	}

	/**
	 * When data is changed in the dataSource push it out to the display widget.
	 * @param data the new data value
	 */
	private override function onDataChanged(data:Dynamic)
	{
		super.onDataChanged(data);
		theValue.text = Std.string(Reflect.field(data, this.id));
	}
}
