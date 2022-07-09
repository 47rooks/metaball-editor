package;

/**
 * DataSource object for the falloff equations table.
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

	public function toString():String
	{
		return
			'outVar: ${outVar}, equalsSign: ${equalsSign}, eqn: ${eqn}, domainVariable: ${domainVariable}, domainMinimum: ${domainMinimum}, domainMaximum: ${domainMaximum}, theValue: ${theValue}';
	}

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
