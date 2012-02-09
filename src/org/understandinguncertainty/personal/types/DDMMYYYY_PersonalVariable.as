/*
This file forms part of the JBS3Risk Cardiovascular Assessment Tool.
It is ©2012 University of Cambridge.
It is released under version 3 of the GNU General Public License
Source code, including a copy of the license is available at https://github.com/BritCardSoc/JBS3Risk
*/
package org.understandinguncertainty.personal.types
{
	import org.understandinguncertainty.personal.interfaces.IPersonalVariable;
	
	public class DDMMYYYY_PersonalVariable extends GenericPersonalVariable implements IPersonalVariable
	{
		
		function DDMMYYYY_PersonalVariable(instanceName:String, date:Date) {
			super(instanceName, date);
		}
		
		public function fromString(s:String):void {
			if(s) {
				//trace("set date from:"+s);
				
				// Assume dd/mm/yyyy format for Date of Birth
				var dmy:Array = s.split(/:|\//);
				var day:int;
				var month:int;
				var year:int;
				
				if(dmy.length == 3) {
					day = parseInt(dmy[0]);
					month = parseInt(dmy[1]);
					year = parseInt(dmy[2]);
				}
				
				if(isNaN(day) || isNaN(month) || isNaN(year))
					throw new Error("invalid date of birth: " + s);
								
				value = new Date(year, month-1, day);
				//trace("date set to: "+value);
			}
		}
		
		public function toString():String {
			if(value == null) return null;
			return value.date+"/"+(value.month+1)+"/"+value.fullYear;
		}

		public function get type():String
		{
			return "Date";	
		}

	}
}