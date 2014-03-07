/*
This file forms part of the JBS3Risk Cardiovascular Assessment Tool.
It is ©2012 University of Cambridge.
It is released under version 3 of the GNU General Public License
Source code, including a copy of the license is available at https://github.com/BritCardSoc/JBS3Risk
*/
package org.understandinguncertainty.JBS.view
{
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;
	
	import org.robotlegs.mvcs.Mediator;
	import org.understandinguncertainty.JBS.model.AppState;
	import org.understandinguncertainty.JBS.model.ICardioModel;
	import org.understandinguncertainty.JBS.model.vo.ColourNumbersVO;
	import org.understandinguncertainty.JBS.signals.ModelUpdatedSignal;
	import org.understandinguncertainty.JBS.signals.NumbersAvailableSignal;
	import org.understandinguncertainty.JBS.signals.ShowDifferencesChangedSignal;
	
	public class BalanceMediator extends Mediator
	{
		
		[Inject]
		public var balance:Balance;
		
		[Inject]
		public var modelUpdatedSignal:ModelUpdatedSignal;
		
		[Inject]
		public var numbersAvailableSignal:NumbersAvailableSignal;
		
		[Inject]
		public var runModel:ICardioModel;
		
		[Inject]
		public var appState:AppState;
		
		public function BalanceMediator()
		{
			super();
		}
		
		override public function onRegister() : void
		{
			//# trace("Balance register");
			modelUpdatedSignal.add(updateView);
			runModel.commitProperties();
			balance.differenceCheckBox.addEventListener(Event.CHANGE, updateView);
		}
		
		override public function onRemove():void
		{
			//# trace("Balance remove");
			modelUpdatedSignal.remove(updateView);
			balance.differenceCheckBox.removeEventListener(Event.CHANGE, updateView);
		}
				
		private function updateView(event:Event = null) : void
		{
			//# trace("Balance updateView");
			var colours:ColourNumbersVO = runModel.colourNumbers;
			appState.showDifferences = balance.differenceCheckBox.selected;
			
			balance.title.text = "What we expect to happen in "+appState.targetInterval+" years to 100 people like you";
			balance.leftSubtitle.text = "carrying on as usual";
			balance.rightSubtitle.text = "after interventions";
			
			runModel.showDifferences = balance.differenceCheckBox.selected;
			numbersAvailableSignal.dispatch(colours, runModel.showDifferences);
		}
	}
}