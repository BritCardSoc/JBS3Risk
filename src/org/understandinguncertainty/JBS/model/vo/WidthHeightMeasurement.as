/*
This file forms part of the JBS3Risk Cardiovascular Assessment Tool.
It is ©2012 University of Cambridge.
It is released under version 3 of the GNU General Public License
Source code, including a copy of the license is available at https://github.com/BritCardSoc/JBS3Risk
*/
package org.understandinguncertainty.JBS.model.vo
{
	import mx.core.UIComponent;

	public class WidthHeightMeasurement
	{
		public var component:UIComponent;
		public var width:Number;
		public var height:Number;
		
		public function WidthHeightMeasurement(c:UIComponent, w:Number, h:Number)
		{
			component = c;
			width = w;
			height = h;
		}
	}
}