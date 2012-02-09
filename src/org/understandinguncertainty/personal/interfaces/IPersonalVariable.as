/*
This file forms part of the JBS3Risk Cardiovascular Assessment Tool.
It is ©2012 University of Cambridge.
It is released under version 3 of the GNU General Public License
Source code, including a copy of the license is available at https://github.com/BritCardSoc/JBS3Risk
*/
package org.understandinguncertainty.personal.interfaces
{
	
	
	public interface IPersonalVariable
	{
		function get name():String;

		function get value():*;
		function set value(v:*):void;

		function fromString(s:String):void;
		function toString():String;
		
		function get type():String;
		
	}
}