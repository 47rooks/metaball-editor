package ui;

/**
 * DataSource object for the XY transform equation table.
 */
class XYTransformRow
{
	public var xytVariable:String;
	public var equalsSign:String;
	public var eqn:String;
	// dummy value to support the falloffRenderer field theValue
	public var theValue:String;

	public function new(xytVariable:String = "", equalsSign:String = "=", eqn:String = "")
	{
		this.xytVariable = xytVariable;
		this.equalsSign = equalsSign;
		this.eqn = eqn;
		theValue = "";
	}

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
