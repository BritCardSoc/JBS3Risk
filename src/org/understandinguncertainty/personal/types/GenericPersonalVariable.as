/*
This file forms part of the JBS3Risk Cardiovascular Assessment Tool.
It is ©2012 University of Cambridge.
It is released under version 3 of the GNU General Public License
Source code, including a copy of the license is available at https://github.com/BritCardSoc/JBS3Risk
*/
package org.understandinguncertainty.personal.types
{
	import flash.utils.getQualifiedClassName;
	
	public class GenericPersonalVariable
	{		
		private var _name:String;
				
		function GenericPersonalVariable(instanceName:String, defaultValue:*) {
			_name = instanceName;
			_value = defaultValue;
		}
		
		public function get name():String {
			return _name;
		}

		protected var _value:*;
		public function get value():* {
			return _value;
		}
		public function set value(v:*):void {
			_value = v;
		}

	}
}