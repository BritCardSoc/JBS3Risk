/*
This file forms part of the JBS3Risk Cardiovascular Assessment Tool.
It is ©2012 University of Cambridge.
It is released under version 3 of the GNU General Public License
Source code, including a copy of the license is available at https://github.com/BritCardSoc/JBS3Risk
*/
package org.understandinguncertainty.JBS.view
{
	import mx.collections.ArrayCollection;
	
	import org.robotlegs.mvcs.Mediator;
	import org.understandinguncertainty.JBS.model.AppState;
	import org.understandinguncertainty.JBS.model.ICardioModel;
	import org.understandinguncertainty.JBS.model.UserModel;
	import org.understandinguncertainty.JBS.signals.ModelUpdatedSignal;
	import org.understandinguncertainty.JBS.signals.UpdateModelSignal;
	
	public class OutcomesMediator extends Mediator
	{
		
		[Inject]
		public var outcomes:Outcomes;
		
		[Inject]
		public var modelUpdatedSignal:ModelUpdatedSignal;
		
		[Inject]
		public var runModel:ICardioModel;
		
		[Inject(name="userProfile")]
		public var userProfile:UserModel;
		
		[Inject]
		public var appState:AppState;
		
		public function OutcomesMediator()
		{
			super();
		}
		
		override public function onRegister() : void
		{
			//trace("Outcomes register");
			modelUpdatedSignal.add(updateView);
			runModel.commitProperties();
		}
		
		override public function onRemove():void
		{
			//trace("Outcomes remove");
			modelUpdatedSignal.remove(updateView);
		}
				
		private function updateView() : void
		{
			if(runModel) {
				
				var targetAge:int = userProfile.age + appState.targetInterval;
				var dataProvider:ArrayCollection = runModel.getResultSet();
				if(appState.targetInterval >= dataProvider.length)
					appState.targetInterval = dataProvider.length - 1;
				var targetItem:Object = dataProvider.getItemAt(appState.targetInterval);
				
				outcomes.smileySquare.f = targetItem.fdash;
				outcomes.smileySquare.f_int = targetItem.fdash_int;
				outcomes.smileySquare.m = targetItem.mdash;
				outcomes.smileySquare.m_int = targetItem.mdash_int;
				outcomes.targetIntervalLabel.text=appState.targetInterval.toString();
				outcomes.ageLabel.text=(appState.minimumAge+appState.targetInterval).toString();				
			}
		}
		
	}
}