/*
This file forms part of the JBS3Risk Cardiovascular Assessment Tool.
It is ©2012 University of Cambridge.
It is released under version 3 of the GNU General Public License
Source code, including a copy of the license is available at https://github.com/BritCardSoc/JBS3Risk
*/
package org.understandinguncertainty.JBS.model.vo
{
	import mx.graphics.SolidColor;
	import mx.graphics.SolidColorStroke;

	public class ShapeData
	{
		public var shape:String;
		public var fill:SolidColor;
		public var stroke:SolidColorStroke;
		public var tenths:int;
		public var dtenths:int;
		public var verticalCut:Boolean;
		
		public function ShapeData(shape:String="man", fill:SolidColor=null, stroke:SolidColorStroke=null, tenths:int = 10, dtenths:int = 10, verticalCut:Boolean = true)
		{
			this.shape = shape;
			this.fill = fill;
			this.stroke = stroke;
			this.tenths = tenths;
			this.dtenths = dtenths;
			this.verticalCut = verticalCut;
		}
	}
}