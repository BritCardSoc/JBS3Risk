/*
This file forms part of the JBS3Risk Cardiovascular Assessment Tool.
It is ©2012 University of Cambridge.
It is released under version 3 of the GNU General Public License
Source code, including a copy of the license is available at https://github.com/BritCardSoc/JBS3Risk
*/
package org.understandinguncertainty.personal.types
{
	import org.understandinguncertainty.personal.interfaces.IPersonalVariable;

	public class BooleanPersonalVariable extends GenericPersonalVariable implements IPersonalVariable
	{
		
		public function BooleanPersonalVariable(instanceName:String, defaultValue:*) {
			super(instanceName, defaultValue);
		}

		public function fromString(s:String):void
		{
			value = s.match(/^\s*(t|true)\s*$/i) != null;
		}
		
		public function toString():String
		{
			return value ? "true" : "false";
		}
		
		public function get type():String
		{
			return "Boolean";	
		}
	}
}