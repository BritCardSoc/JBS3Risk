/*
This file forms part of the JBS3Risk Cardiovascular Assessment Tool.
It is ©2012 University of Cambridge.
It is released under version 3 of the GNU General Public License
Source code, including a copy of the license is available at https://github.com/BritCardSoc/JBS3Risk
*/
package org.understandinguncertainty.personal.types
{
	import org.understandinguncertainty.personal.interfaces.IPersonalVariable;

	public class NumberPersonalVariable extends GenericPersonalVariable implements IPersonalVariable
	{
		function NumberPersonalVariable(instanceName:String, defaultValue:*) {
			super(instanceName, defaultValue);
		}
		
/*
		override public function get value():* {
			return _value;
		}
		override public function set value(v:*):void {
			_value = v;
		}
*/
		
		public function fromString(s:String):void {
			value = Number(s);
		}
		
		public function toString():String {
			return !isNaN(value) ? value.toString() : "";
		}

		public function get type():String
		{
			return "Number";	
		}
	}
}