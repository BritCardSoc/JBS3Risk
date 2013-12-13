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
	
	public class HeartAgeMediator extends Mediator
	{
		[Inject]
		public var heartAge:HeartAge;
		
		[Inject]
		public var runModel:ICardioModel;
		
		[Inject]
		public var appState:AppState;
		
		[Inject(name="userProfile")]
		public var userProfile:UserModel;
		
		[Inject]
		public var modelUpdatedSignal:ModelUpdatedSignal;
		
		public var meanAge:Number;
						
		override public function onRegister() : void
		{
			//trace("heartAge register");		
			appState.interventionAge = userProfile.age;
			
			modelUpdatedSignal.add(updateView);
			runModel.commitProperties();
		}
		
		override public function onRemove():void
		{
			//trace("heartAge remove");
			modelUpdatedSignal.remove(updateView);
		}
		
		private function updateView():void
		{
			if(appState.selectedScreenName != "heartAge") {
				
				// flashScore_gp may not be valid
				// trace("HEARTAGE SCREEN MISMATCH");
				
				return;
			}
/*			
			if(runModel.yearGain >= 0.1) {
				var yg:String = runModel.yearGain.toPrecision(2);
				heartAge.gainText.visible = true;
				heartAge.gainText.text = "gaining " + yg + " years through interventions"
			}
			else {
				heartAge.gainText.visible = false;
			}
			
			meanAge = runModel.meanAge;
			heartAge.meanSurvival.text = "On average, expect to survive to\n" + Math.floor(meanAge) + "\nwithout a heart attack or stroke";
			var yGain:Number = Math.max(0, runModel.yearGain);
*/			
			/*
			heartAge.thermometer.dataProvider = new ArrayCollection([{
				meanYears:runModel.meanAge - yGain, 
				yearGain:yGain, 
				summary:""
			}]);

			heartAge.hAxis.minimum = userProfile.age;
			heartAge.hAxis.maximum = 102; //5*Math.ceil((runModel.meanAge + 5)/5);
			*/
			// runModel.commitProperties();
			heartAge.heartAgeText.text = runModel.heartAgeText;

		}
	}
}