package errors;

import errors.ErrorData;

/**
 * Error data accumulation and builder for ErrorData objects. ErrorDataBuilder uses a fluent DSL style with most APIs returning the builder object to facilitate chained invocation.
 */
class ErrorDataBuilder
{
	var _falloffEquationErrors:Array<EquationError>;
	var _xyTransformErrors:Array<EquationError>;
	var _xpixelError:NumberError;
	var _ypixelError:NumberError;

	/**
	 * True if there are recorded errors, false otherewise.
	 */
	public var hasErrors(default, null):Bool;

	public function new()
	{
		_falloffEquationErrors = new Array<EquationError>();
		_xyTransformErrors = new Array<EquationError>();
		_xpixelError = null;
		_ypixelError = null;

		hasErrors = false;
	}

	public function addFalloffEquationError(e:EquationError):ErrorDataBuilder
	{
		_falloffEquationErrors.push(e);
		hasErrors = true;
		return this;
	}

	public function addXYTransformError(e:EquationError):ErrorDataBuilder
	{
		_xyTransformErrors.push(e);
		hasErrors = true;
		return this;
	}

	public function setXPixelError(e:NumberError):ErrorDataBuilder
	{
		_xpixelError = e;
		hasErrors = true;
		return this;
	}

	public function setYPixelError(e:NumberError):ErrorDataBuilder
	{
		_ypixelError = e;
		hasErrors = true;
		return this;
	}

	public function emit():ErrorData
	{
		return new ErrorData(_falloffEquationErrors, _xyTransformErrors, _xpixelError, _ypixelError);
	}
}
