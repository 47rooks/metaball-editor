package errors;

typedef EquationError =
{
	var eqnNumber:Int;
	var eqnFieldNumber:Int;
	var errorPos:Int;
	var errorMsg:String;
}

typedef NumberError =
{
	var errorMsg:String;
}

/**
 * All error data for a metaball editor input screen.
 * In general Arrays may be empty not null, and single values may be null or contain data.
 */
class ErrorData
{
	/**
	 * Error for falloff equations.
	 */
	public var falloffEquationErrors(default, null):Array<EquationError>;

	public var xyTransformErrors(default, null):Array<EquationError>;
	public var xpixelError(default, null):NumberError;
	public var ypixelError(default, null):NumberError;

	public function new(falloffErrors:Array<EquationError>, xyTransformErrors:Array<EquationError>, xpixelError:Null<NumberError>,
			ypixelError:Null<NumberError>)
	{
		this.falloffEquationErrors = falloffErrors;
		this.xyTransformErrors = xyTransformErrors;
		this.xpixelError = xpixelError;
		this.ypixelError = ypixelError;
	}
}
