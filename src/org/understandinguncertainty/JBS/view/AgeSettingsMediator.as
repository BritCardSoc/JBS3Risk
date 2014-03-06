package org.understandinguncertainty.JBS.view
{
	import flash.events.Event;
	
	import org.robotlegs.mvcs.Mediator;
	import org.understandinguncertainty.JBS.model.AppState;
	import org.understandinguncertainty.JBS.model.ICardioModel;
	import org.understandinguncertainty.JBS.model.UserModel;
	import org.understandinguncertainty.JBS.signals.ModelUpdatedSignal;
	
	import spark.components.NumericStepper;
	
	public class AgeSettingsMediator extends Mediator
	{
		[Inject]
		public var ageSettings:AgeSettings;
		
		[Inject]
		public var runModel:ICardioModel;
		
		[Inject]
		public var appState:AppState;
		
		[Inject(name="userProfile")]
		public var userProfile:UserModel;
		
		[Inject]
		public var modelUpdatedSignal:ModelUpdatedSignal;
		
		override public function onRegister():void 
		{
			ageSettings.targetInterval.addEventListener(Event.CHANGE, updateTargetInterval)
			ageSettings.interventionAgeStepper.addEventListener(Event.CHANGE, updateInterventionAge);
			modelUpdatedSignal.add(updateView);
			runModel.commitProperties();
			updateView();
		}
		
		override public function onRemove():void
		{
			ageSettings.targetInterval.removeEventListener(Event.CHANGE, updateTargetInterval);
			ageSettings.interventionAgeStepper.removeEventListener(Event.CHANGE, updateInterventionAge);
			modelUpdatedSignal.remove(updateView);
		}
		
		public function updateView():void
		{
			ageSettings.interventionAgeStepper.minimum = userProfile.age;
			ageSettings.interventionAgeStepper.maximum = appState.maximumAge;
			ageSettings.interventionAgeStepper.value = appState.interventionAge;
						
			var ts:NumericStepper = ageSettings.targetInterval;
			ts.value = appState.targetInterval;
			ts.maximum = appState.maximumAge-userProfile.age;
		}
		
		private function updateTargetInterval(event:Event):void
		{
			appState.targetInterval = ageSettings.targetInterval.value;
			runModel.commitProperties();
		}		

		private function updateInterventionAge(event:Event):void
		{
			appState.interventionAge = ageSettings.interventionAgeStepper.value;
			runModel.commitProperties();
		}		
	}
}