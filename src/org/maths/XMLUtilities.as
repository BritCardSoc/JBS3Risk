/*
This file forms part of the JBS3Risk Cardiovascular Assessment Tool.
It is ©2012 University of Cambridge.
It is released under version 3 of the GNU General Public License
Source code, including a copy of the license is available at https://github.com/BritCardSoc/JBS3Risk
*/
package org.maths
{
	public class XMLUtilities
	{
		public static function booleanAttr(attribute:XMLList, defaultValue:Boolean):Boolean {
			if(attribute && attribute.length() > 0) {
				var b:String = attribute[0].toString();
				if(b.match(/\s*(t|true)\s*/i))
					return true;
				else if(b.match(/\s*(f|false)\s*/))
					return false;
			}
			return defaultValue;
		}
		
		public static function stringAttr(attribute:XMLList, defaultValue:String):String {
			if(attribute && attribute.length() > 0) {
				return attribute[0].toString();
			}
			else
				return defaultValue;
		}
		
		public static function intAttr(attribute:XMLList, defaultValue:int):int {
			if(attribute && attribute.length() > 0) {
				return parseInt(attribute[0].toString());
			}
			else
				return defaultValue;
		}
		
		public static function numberAttr(attribute:XMLList, defaultValue:Number):Number {
			if(attribute && attribute.length() > 0) {
				return Number(attribute[0].toString());
			}
			else
				return defaultValue;
		}
		
		public static function uintAttr(attribute:XMLList, defaultValue:uint):uint {
			if(attribute && attribute.length() > 0) {
				return parseInt(attribute[0].toString());
			}
			else
				return defaultValue;
		}
	}
}