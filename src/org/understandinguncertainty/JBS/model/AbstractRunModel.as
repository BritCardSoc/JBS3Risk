/*
This file forms part of the JBS3Risk Cardiovascular Assessment Tool.
It is ©2012 University of Cambridge.
It is released under version 3 of the GNU General Public License
Source code, including a copy of the license is available at https://github.com/BritCardSoc/JBS3Risk
*/
package org.understandinguncertainty.JBS.model
{
	import mx.collections.ArrayCollection;
	import mx.resources.IResourceManager;
	
	import org.understandinguncertainty.JBS.model.vo.ColourNumbersVO;
	import org.understandinguncertainty.JBS.signals.ModelUpdatedSignal;
	import org.understandinguncertainty.JBS.signals.UpdateModelSignal;
	import org.understandinguncertainty.personal.VariableList;
	import org.understandinguncertainty.personal.types.BooleanPersonalVariable;

	[ResourceBundle("JBS")]
	public class AbstractRunModel 
	{
		
		[Inject]
		public var resourceManager:IResourceManager;

		[Inject(name="userProfile")]
		public var userProfile:UserModel;
		
		[Inject(name="interventionProfile")]
		public var interventionProfile:UserModel;
		
		[Inject]
		public var modelUpdatedSignal:ModelUpdatedSignal;
		
		[Inject]
		public var appState:AppState;
		
		private var _h:Number;
		public function get heartAge():Number
		{
			if(_h != _h) return userProfile.age;
			return _h;
		}
		public function set heartAge(i:Number):void
		{
			_h = i; 
			var hint:int = Math.floor(_h);
			var hmonth:int = Math.round((_h - hint)*12);
			_heartAgeText = hint + " years"; 
		}
		
		private var _heartAgeText:String = "";
		public function get heartAgeText():String
		{
			return _heartAgeText;
		}

		public function set heartAgeText(value:String):void
		{
			_heartAgeText = value;
		}

		
		protected var sum_e:Number = 0;
		protected var sum_e_int:Number = 0;
		
		public function get yearGain():Number {
			return (sum_e_int - sum_e)/100;
		}
		
		public function get meanAge():Number {
			return appState.minimumAge + sum_e_int/100;
		}
		
		protected var peakYellowNeg:Number = 20;
		
		/**
		 * returns the minimum acceptable value of the outlook (-ve) vertical axis slider
		 */
		public function get peakYellowPadded():Number
		{
			return 10*Math.ceil(peakYellowNeg/10);
		}
			
		protected function clamp(n:Number):Number 
		{
			return Math.max(0,Math.min(n, chanceClamp));
		}
		
		private var chanceClamp:Number = 100;
			
		protected var _resultSet:ArrayCollection;
		public function getResultSet():ArrayCollection
		{
			return _resultSet;	
		}
		
		/**
		 * @return counts of each colour in balance views
		 */
		public function get colourNumbers():ColourNumbersVO
		{
			const _N2:int = 100;

			var targetAge:int = userProfile.age + appState.targetInterval;
			var dataProvider:ArrayCollection = getResultSet();
			if(dataProvider == null)
				return null;
			if(appState.targetInterval >= dataProvider.length)
				appState.targetInterval = dataProvider.length - 1;
			var targetItem:Object = dataProvider.getItemAt(appState.targetInterval);

			var m:Number = targetItem.mdash;
			var m_int:Number = targetItem.mdash_int;
			var f:Number = targetItem.fdash;
			var f_int:Number = targetItem.fdash_int;

			var colourNumbers:ColourNumbersVO = new ColourNumbersVO;
			colourNumbers.green = _N2-(f+m);
			colourNumbers.green_int = _N2-(f_int+m_int);
			colourNumbers.red = f;
			colourNumbers.red_int = f_int;
			colourNumbers.blue = m;
			colourNumbers.blue_int = m_int;
			return colourNumbers;		

		}	
	}
}
