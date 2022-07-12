package;

import errors.ErrorDataBuilder;
import haxe.Exception;

/**
 * EquationSystem exceptions are thrown as this type.
 * Refer to the definition of ErrorData to process this.
 */
class ESException extends Exception
{
	public var errors(default, null):Null<ErrorDataBuilder>;

	/**
	 * Constructor
	 * @param message the top level message for these errors
	 * @param previous any previous exception that this is chained to
	 * @param errors A builder containing errors accumulated during EquationSystem processing
	 */
	public function new(message:String, ?previous:Exception, errorBuilder:ErrorDataBuilder)
	{
		super(message, previous);
		errors = errorBuilder;
	}
}
