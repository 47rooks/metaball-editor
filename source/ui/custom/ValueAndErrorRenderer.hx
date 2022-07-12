package ui.custom;

import haxe.ui.core.ItemRenderer;
import haxe.ui.events.UIEvent;

@:build(haxe.ui.ComponentBuilder.build("assets/ui/value-and-error-renderer.xml"))
class ValueAndErrorRenderer extends ItemRenderer
{
	public function new()
	{
		super();
	}

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

	private override function onDataChanged(data:Dynamic)
	{
		super.onDataChanged(data);
		theValue.text = Std.string(Reflect.field(data, this.id));
	}
}
