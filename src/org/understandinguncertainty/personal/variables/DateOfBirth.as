/*
This file forms part of the JBS3Risk Cardiovascular Assessment Tool.
It is ©2012 University of Cambridge.
It is released under version 3 of the GNU General Public License
Source code, including a copy of the license is available at https://github.com/BritCardSoc/JBS3Risk
*/
package org.understandinguncertainty.personal.variables
{
	import org.understandinguncertainty.personal.interfaces.IPersonalVariable;
	import org.understandinguncertainty.personal.types.DDMMYYYY_PersonalVariable;
	
	public class DateOfBirth extends DDMMYYYY_PersonalVariable implements IPersonalVariable
	{
		
		public var yearOfBirth:YearOfBirth;
		
		function DateOfBirth(instanceName:String, date:Date) {
			super(instanceName, date);
		}

		override public function get value():* {
			if(_value == null) {
				_value = new Date();
			}

			return _value;
		}
		override public function set value(v:*):void {
			super.value = v;
//			yearOfBirth.value = v.fullYear;

		}
		
		public function getAge():int {
			var date:Date = value;
			if(date == null) return -1;
			var now:Date = new Date();

			var yearDiff:int = now.getFullYear() - date.getFullYear();
			var monthDiff:int = now.getMonth() - date.getMonth();

			if(monthDiff > 0)
				return yearDiff;
			
			if(monthDiff < 0)
				return yearDiff-1;
			
			var dayDiff:int = now.date - date.date;
			if(dayDiff >= 0)
				return yearDiff;
			else
				return yearDiff - 1;

		}

	}
}