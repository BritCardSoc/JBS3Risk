/*
This file forms part of the JBS3Risk Cardiovascular Assessment Tool.
It is ©2012 University of Cambridge.
It is released under version 3 of the GNU General Public License
Source code, including a copy of the license is available at https://github.com/BritCardSoc/JBS3Risk
*/
package org.understandinguncertainty.personal.variables
{
	import org.understandinguncertainty.personal.interfaces.IPersonalVariable;
	import org.understandinguncertainty.personal.types.NumberPersonalVariable;
	
	public class YearOfBirth extends NumberPersonalVariable implements IPersonalVariable
	{

		public var dateOfBirth:DateOfBirth;
		
		override public function set value(v:*):void {
			super.value = v;
			dateOfBirth.value.fullYear = v;
		}
		
		function YearOfBirth(instanceName:String, defaultValue:*) {
			super(instanceName, defaultValue);
		}
		
		public function getAge():int {
			var yob:Number = value;
			if(isNaN(yob)) return -1;
			var now:Date = new Date();
			var age:Number = now.getFullYear() - yob;
			return age;
		}

	}
}