package ui;

/**
 * DataSource object for the XY transform equation table. Each instance of this class represents one row in the table.
 */
class XYTransformRow
{
	public var xytVariable:String;
	public var equalsSign:String;
	public var eqn:String;
	// dummy value to support the falloffRenderer field theValue
	public var theValue:String;

	/**
	 * Constructor
	 * @param xytVariable the output variable of the transform, expected to match the falloff equation domain variable.
	 * @param equalsSign boilerplate '=' sign
	 * @param eqn the transform equation
	 */
	public function new(xytVariable:String = "", equalsSign:String = "=", eqn:String = "")
	{
		this.xytVariable = xytVariable;
		this.equalsSign = equalsSign;
		this.eqn = eqn;
		theValue = "";
	}

	/**
	 * Return a string representation, for debugging
	 * @return String the string form of the row
	 */
	public function toString():String
	{
		return 'domainVariable: ${xytVariable}, equalsSign: ${equalsSign}, eqn: ${eqn}';
	}

	/**
	 * Return the elements of the XYTransform row as an Array of Strings. This is mostly
	 * used by the serialization code.
	 * @return Array<String>
	 */
	public function toArray():Array<String>
	{
		var rv = new Array<String>();
		rv.push(xytVariable);
		rv.push(equalsSign);
		rv.push(eqn);
		return rv;
	}
}
