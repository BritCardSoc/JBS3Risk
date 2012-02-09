/*
This file forms part of the JBS3Risk Cardiovascular Assessment Tool.
It is ©2012 University of Cambridge.
It is released under version 3 of the GNU General Public License
Source code, including a copy of the license is available at https://github.com/BritCardSoc/JBS3Risk
*/
package org.understandinguncertainty.JBS.view
{
	import mx.graphics.SolidColor;
	
	import org.understandinguncertainty.JBS.model.vo.ColourNumbersVO;
	import org.understandinguncertainty.JBS.signals.NumbersAvailableSignal;

	public class GoodBalanceMediator extends DifferenceBalanceMediator
	{
		[Inject]
		public var goodBalance:GoodBalance;
		
		[Inject]
		public var numbersAvailableSignal:NumbersAvailableSignal;
		
		public function GoodBalanceMediator()
		{
			super();
		}

		
		override public function onRegister():void
		{
			differenceBalance = goodBalance;
			super.onRegister();
			/*
			var colours:ColourNumbersVO = runModel.colourNumbers;
			leftNumber = colours.green;
			rightNumber = colours.green_int;
			*/
			showDifferences = appState.showDifferences;
			fill = new SolidColor(0x22AA00);
			
			numbersAvailableSignal.add(updateView);
			
			var colourNumbers:ColourNumbersVO = runModel.colourNumbers;
			if(colourNumbers)
				updateView(runModel.colourNumbers, runModel.showDifferences);
		}
		
		override public function onRemove():void
		{
			numbersAvailableSignal.remove(updateView);
			super.onRemove();
		}
		
		private function updateView(colours:ColourNumbersVO, selected:Boolean):void
		{
			leftNumber = colours.green;
			rightNumber = colours.green_int;
			showDifferences = selected;
			text = "living without heart attack or stroke";
		}

		
	}
}

