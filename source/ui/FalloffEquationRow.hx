package ui;

/**
 * DataSource object for the falloff equations table. And instance of this object represents one row.
 */
class FalloffEquationRow
{
	public var outVar:String;
	public var equalsSign:String;
	public var eqn:String;
	public var domainVariable:String;
	public var domainMinimum:String;
	public var domainMaximum:String;
	// dummy value to support the falloffRenderer field theValue
	public var theValue:String;

	/**
	 * Constructor
	 * @param outVar output variable
	 * @param equalsSign the equals sign - this is boilerblate and should be removed at some point
	 * @param eqn the equation
	 * @param domainVariable the intermediate domain variable, if specified
	 * @param domainMinimum the minimum value, convertible to float, -Infinity is a valid value
	 * @param domainMaximum the maximum value, convertible to float, Infinity is a valid value
	 */
	public function new(outVar:String = "", equalsSign:String = "=", eqn:String = "", domainVariable:String = "", domainMinimum:String = "",
			domainMaximum:String = "")
	{
		this.outVar = outVar;
		this.equalsSign = equalsSign;
		this.eqn = eqn;
		this.domainVariable = domainVariable;
		this.domainMinimum = domainMinimum;
		this.domainMaximum = domainMaximum;
		theValue = "";
	}

	/**
	 * Return a string representation, mostly for debugging.
	 * @return String
	 */
	public function toString():String
	{
		return
			'outVar: ${outVar}, equalsSign: ${equalsSign}, eqn: ${eqn}, domainVariable: ${domainVariable}, domainMinimum: ${domainMinimum}, domainMaximum: ${domainMaximum}, theValue: ${theValue}';
	}

	/**
	 * Return the elements of the falloff equations row as an Array of Strings. This is mostly
	 * used by the serialization code.
	 * @return Array<String>
	 */
	public function toArray():Array<String>
	{
		var rv = new Array<String>();
		rv.push(outVar);
		rv.push(equalsSign);
		rv.push(eqn);
		rv.push(domainVariable);
		rv.push(domainMinimum);
		rv.push(domainMaximum);
		return rv;
	}
}
