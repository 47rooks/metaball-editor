package errors;

/**
 * Equation error information
 */
typedef EquationError =
{
	/**
	 * The equation this error applies to. Starts and 0 for the first row in the table.
	 */
	var eqnNumber:Int;

	/**
	 * The field number starting at 0 for the left most column in the row, increasing to the right.
	 */
	var eqnFieldNumber:Int;

	/**
	 * The position of the error as reported by Formula, if applicable.
	 */
	var errorPos:Int;

	/**
	 * The error message text.
	 */
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

	/**
	 * XY Transform equation errors.
	 */
	public var xyTransformErrors(default, null):Array<EquationError>;

	/**
	 * Width value errors.
	 */
	public var xpixelError(default, null):NumberError;

	/**
	 * Height value errors.
	 */
	public var ypixelError(default, null):NumberError;

	/**
	 * Constructor
	 * @param falloffErrors falloff equation errors
	 * @param xyTransformErrors XY transform equation errors
	 * @param xpixelError x pixel (width) errors
	 * @param ypixelError y pixel (height) errors
	 */
	public function new(falloffErrors:Array<EquationError>, xyTransformErrors:Array<EquationError>, xpixelError:Null<NumberError>,
			ypixelError:Null<NumberError>)
	{
		this.falloffEquationErrors = falloffErrors;
		this.xyTransformErrors = xyTransformErrors;
		this.xpixelError = xpixelError;
		this.ypixelError = ypixelError;
	}
}
