/*
This file forms part of the JBS3Risk Cardiovascular Assessment Tool.
It is ©2012 University of Cambridge.
It is released under version 3 of the GNU General Public License
Source code, including a copy of the license is available at https://github.com/BritCardSoc/JBS3Risk
*/
package org.understandinguncertainty.JBS.model
{
	import mx.graphics.SolidColor;
	import mx.graphics.SolidColorStroke;
	
	import org.understandinguncertainty.JBS.signals.ModelUpdatedSignal;
	
	public class AppState
	{
		[Inject]
		public var modelUpdatedSignal:ModelUpdatedSignal;
		
		public const mmolConvert:Number = 38.7;
		public var mmol:Boolean = true;
		public var showDifferences:Boolean = false;
		public var interventionAge:int = 0;
		public var targetInterval:int = 10;
		public var maximumAge:int = 95;
		public var selectedScreenName:String = "profile";
		
		private var _minimumAge:int = 0;

		public function get minimumAge():int
		{
			return _minimumAge;
		}

		public function set minimumAge(value:int):void
		{
			if(interventionAge < value)
				interventionAge = value;
			_minimumAge = value;
		}

		
	}
	
	
}