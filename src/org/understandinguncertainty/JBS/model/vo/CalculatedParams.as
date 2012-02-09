/*
This file forms part of the JBS3Risk Cardiovascular Assessment Tool.
It is ©2012 University of Cambridge.
It is released under version 3 of the GNU General Public License
Source code, including a copy of the license is available at https://github.com/BritCardSoc/JBS3Risk
*/
package org.understandinguncertainty.JBS.model.vo
{
	public class CalculatedParams {
		public var a:Number;
		public var a_int:Number;
		public var genPop_a:Number
		public var h:Number;
		
		function CalculatedParams(a:Number, a_int:Number, h:Number, genPop_a:Number)
		{
			this.a = a;
			this.a_int = a_int;
			this.h = h;
			this.genPop_a = genPop_a;
			trace("a=", a," a_int=", a_int," h=", h, " genPop_a=", genPop_a);
		}
	}
}