/*
This file forms part of the JBS3Risk Cardiovascular Assessment Tool.
It is ©2012 University of Cambridge.
It is released under version 3 of the GNU General Public License
Source code, including a copy of the license is available at https://github.com/BritCardSoc/JBS3Risk
*/
package org.understandinguncertainty.JBS.view
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.collections.ArrayCollection;
	
	import org.robotlegs.mvcs.Mediator;
	import org.understandinguncertainty.JBS.components.InterventionCheck;
	import org.understandinguncertainty.JBS.components.InterventionStepper;
	import org.understandinguncertainty.JBS.model.AppState;
	import org.understandinguncertainty.JBS.model.ICardioModel;
	import org.understandinguncertainty.JBS.model.UserModel;
	import org.understandinguncertainty.JBS.signals.InterventionEditedSignal;
	import org.understandinguncertainty.JBS.signals.UpdateModelSignal;
	import org.understandinguncertainty.QRLifetime.vo.QParametersVO;
	import org.understandinguncertainty.personal.VariableList;
	import org.understandinguncertainty.personal.types.BooleanPersonalVariable;
	
	public class InterventionsPanelMediator extends Mediator
	{
		[Inject]
		public var interventionsPanel:InterventionsPanel;
		
		[Inject(name="userProfile")]
		public var userProfile:UserModel;
		
		[Inject(name="interventionProfile")]
		public var interventionProfile:UserModel;
		
		[Inject]
		public var runModel:ICardioModel;
		
		[Inject]
		public var appState:AppState;
		
		[Inject]
		public var interventionEditedSignal:InterventionEditedSignal;
		
		public function InterventionsPanelMediator()
		{
			super();
		}
		
		override public function onRegister() : void
		{
			var inter:VariableList = interventionProfile.variableList;
			
			// Set stepper limits
			interventionsPanel.sbp.minimum = QParametersVO.lowerLimits().sbp;
			interventionsPanel.sbp.maximum = QParametersVO.upperLimits().sbp;

			interventionsPanel.totalCholesterol.minimum = 0;
			interventionsPanel.totalCholesterol.maximum = 20;

			interventionsPanel.hdlCholesterol.minimum = 0;
			interventionsPanel.hdlCholesterol.maximum = 12;
			
			interventionsPanel.sbp.addEventListener(Event.CHANGE, stepperChanged);
			interventionsPanel.sbp.addEventListener(MouseEvent.CLICK, resetSBP);
			
			interventionsPanel.totalCholesterol.addEventListener(Event.CHANGE, stepperChanged);
			interventionsPanel.totalCholesterol.addEventListener(MouseEvent.CLICK, resetTotalCholesterol);
			
			interventionsPanel.hdlCholesterol.addEventListener(Event.CHANGE, stepperChanged);
			interventionsPanel.hdlCholesterol.addEventListener(MouseEvent.CLICK, resetHDLCholesterol);
			
			interventionsPanel.resetButton.addEventListener(MouseEvent.CLICK, resetAll);
			
			interventionsPanel.futureSmokingCategory.dataProvider = new ArrayCollection([
				"No",
				"I quit",
				"less than 10/day",
				"less than 20/day",
				"20+/day"
			]);
			interventionsPanel.futureSmokingCategory.addEventListener(Event.CHANGE, futureSmokingChanged);

			interventionsPanel.conversionFactor = appState.mmol ? 1 : appState.mmolConvert;
			
			setInterventions(interventionProfile.variableList);
		}
		
		override public function onRemove():void
		{
			interventionsPanel.sbp.removeEventListener(Event.CHANGE, stepperChanged);
			interventionsPanel.sbp.removeEventListener(MouseEvent.CLICK, resetSBP);

			interventionsPanel.totalCholesterol.removeEventListener(Event.CHANGE, stepperChanged);
			interventionsPanel.totalCholesterol.removeEventListener(MouseEvent.CLICK, resetTotalCholesterol);
			
			interventionsPanel.hdlCholesterol.removeEventListener(Event.CHANGE, stepperChanged);
			interventionsPanel.hdlCholesterol.removeEventListener(MouseEvent.CLICK, resetHDLCholesterol);
			
			interventionsPanel.resetButton.removeEventListener(MouseEvent.CLICK, resetAll);
		}
		
		
		private function setInterventions(user:VariableList):void
		{	
			interventionsPanel.sbp.original = interventionsPanel.sbp.value = user.systolicBloodPressure.value as Number;
			
			if(appState.mmol) {
				interventionsPanel.totalCholesterol.original = interventionsPanel.totalCholesterol.value = user.totalCholesterol_mmol_L.value;
				interventionsPanel.totalCholesterol.maximum = 20;
				interventionsPanel.totalCholesterol.stepSize = 0.1;
				interventionsPanel.totalCholesterol.fixed = 1;
				interventionsPanel.hdlCholesterol.original = interventionsPanel.hdlCholesterol.value = user.hdlCholesterol_mmol_L.value;
				interventionsPanel.hdlCholesterol.maximum = 12;
				interventionsPanel.hdlCholesterol.stepSize = 0.1;
				interventionsPanel.hdlCholesterol.fixed = 1;
				interventionsPanel.nonHDLField.text = "NonHDL Cholesterol: " + (user.totalCholesterol_mmol_L.value - user.hdlCholesterol_mmol_L.value).toFixed(1);
			}
			else {
				interventionsPanel.totalCholesterol.maximum = QProfileMediator.mol2mg(20);
				interventionsPanel.totalCholesterol.stepSize = 5;
				interventionsPanel.totalCholesterol.fixed = 0;
				interventionsPanel.hdlCholesterol.maximum = QProfileMediator.mol2mg(12);
				interventionsPanel.hdlCholesterol.stepSize = 1;
				interventionsPanel.hdlCholesterol.fixed = 0;
				interventionsPanel.totalCholesterol.original = interventionsPanel.totalCholesterol.value = QProfileMediator.mol2mg(user.totalCholesterol_mmol_L.value);
				interventionsPanel.hdlCholesterol.original = interventionsPanel.hdlCholesterol.value = QProfileMediator.mol2mg(user.hdlCholesterol_mmol_L.value);
				interventionsPanel.nonHDLField.text = "NonHDL Cholesterol: " + QProfileMediator.mol2mg(user.totalCholesterol_mmol_L.value - user.hdlCholesterol_mmol_L.value).toFixed(0);
			}
			
			interventionsPanel.futureSmokingCategory.selectedIndex = user.smokerGroup.value as Number;
			
			
			interventionsPanel.bmiField.text = "BMI: " + user.bmi.toPrecision(3);
				
			runModel.commitProperties();
		}
		

		private function stepperChanged(event:Event):void
		{
			var inter:VariableList = interventionProfile.variableList;
			
			inter.systolicBloodPressure.value = interventionsPanel.sbp.value;
			
			if(appState.mmol) {
				inter.totalCholesterol_mmol_L.value = interventionsPanel.totalCholesterol.value;
				inter.hdlCholesterol_mmol_L.value = interventionsPanel.hdlCholesterol.value;
				interventionsPanel.nonHDLField.text = "NonHDL Cholesterol: " + (interventionsPanel.totalCholesterol.value - interventionsPanel.hdlCholesterol.value).toFixed(1);
			}
			else {
				inter.totalCholesterol_mmol_L.value = QProfileMediator.mg2mol(interventionsPanel.totalCholesterol.value);
				inter.hdlCholesterol_mmol_L.value = QProfileMediator.mg2mol(interventionsPanel.hdlCholesterol.value);
				interventionsPanel.nonHDLField.text = "NonHDL Cholesterol: " + (interventionsPanel.totalCholesterol.value - interventionsPanel.hdlCholesterol.value).toFixed(0);;				
			}
			inter.smokerGroup.value = interventionsPanel.futureSmokingCategory.selectedIndex;
			
			
			runModel.commitProperties();
		}
		/*
		private function stepper2Changed(event:Event):void
		{
			var conversion:Number = appState.mmol ? 1 : 1/appState.mmolConvert;
			var inter:VariableList = interventionProfile.variableList;
			
			inter.systolicBloodPressure.value = interventionsPanel.sbp.value;
			inter.totalCholesterol_mmol_L.value = interventionsPanel.totalCholesterol.value;
			inter.hdlCholesterol_mmol_L.value = interventionsPanel.hdlCholesterol.value;
			inter.smokerGroup.value = interventionsPanel.futureSmokingCategory.selectedIndex;
			
			interventionsPanel.nonHDLField.text = "NonHDL Cholesterol: " + (inter.totalCholesterol_mmol_L.value - inter.hdlCholesterol_mmol_L.value).toPrecision(2);
			
			runModel.commitProperties();
		}
		
		private function stepper3Changed(event:Event):void
		{
			var conversion:Number = appState.mmol ? 1 : 1/appState.mmolConvert;
			var inter:VariableList = interventionProfile.variableList;
			
			inter.systolicBloodPressure.value = interventionsPanel.sbp.value;
			inter.totalCholesterol_mmol_L.value = interventionsPanel.totalCholesterol.value;
			inter.hdlCholesterol_mmol_L.value = interventionsPanel.hdlCholesterol.value;
			inter.smokerGroup.value = interventionsPanel.futureSmokingCategory.selectedIndex;
			
			interventionsPanel.nonHDLField.text = "NonHDL Cholesterol: " + (inter.totalCholesterol_mmol_L.value - inter.hdlCholesterol_mmol_L.value).toPrecision(2);
			
			runModel.commitProperties();
		}
		*/
		private function futureSmokingChanged(event:Event):void 
		{
			var inter:VariableList = interventionProfile.variableList;

			var newSmokerCategory:int = interventionsPanel.futureSmokingCategory.selectedIndex;
			var oldSmokerCategory:int = userProfile.smoke_cat;
			if(oldSmokerCategory > 0 && newSmokerCategory == 0)
				newSmokerCategory = 1;
			if(oldSmokerCategory == 0 && newSmokerCategory == 1)
				newSmokerCategory = 0;
			interventionsPanel.futureSmokingCategory.selectedIndex = newSmokerCategory;
			inter.smokerGroup.value = newSmokerCategory;			

			runModel.commitProperties();
		}
		
		private function resetAll(event:MouseEvent):void
		{
			interventionProfile.variableList = userProfile.variableList.clone();
			setInterventions(userProfile.variableList);
		}
		
		private function resetSBP(event:MouseEvent):void
		{
			var user:VariableList = userProfile.variableList;
			interventionProfile.variableList.systolicBloodPressure.value = user.systolicBloodPressure.value;
			interventionsPanel.sbp.value = user.systolicBloodPressure.value as Number;

			runModel.commitProperties();
		}
		
		private function resetTotalCholesterol(event:MouseEvent):void
		{
			var user:VariableList = userProfile.variableList;
			interventionProfile.variableList.totalCholesterol_mmol_L = user.totalCholesterol_mmol_L;

			runModel.commitProperties();
			
		}
		
		private function resetHDLCholesterol(event:MouseEvent):void
		{
			var user:VariableList = userProfile.variableList;
			interventionProfile.variableList.hdlCholesterol_mmol_L = user.totalCholesterol_mmol_L;

			runModel.commitProperties();
			
		}
		
	}
}