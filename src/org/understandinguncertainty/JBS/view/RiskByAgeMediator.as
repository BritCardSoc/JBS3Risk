/*
This file forms part of the JBS3Risk Cardiovascular Assessment Tool.
It is ©2012 University of Cambridge.
It is released under version 3 of the GNU General Public License
Source code, including a copy of the license is available at https://github.com/BritCardSoc/JBS3Risk
*/
package org.understandinguncertainty.JBS.view
{
	import flash.events.Event;
	
	import mx.charts.HitData;
	import mx.charts.LinearAxis;
	import mx.charts.series.LineSeries;
	import mx.collections.ArrayCollection;
	
	import org.robotlegs.mvcs.Mediator;
	import org.understandinguncertainty.JBS.model.AppState;
	import org.understandinguncertainty.JBS.model.ICardioModel;
	import org.understandinguncertainty.JBS.model.UserModel;
	import org.understandinguncertainty.JBS.signals.ModelUpdatedSignal;
	import org.understandinguncertainty.JBS.signals.UpdateModelSignal;
	import org.understandinguncertainty.QRLifetime.vo.QResultVO;
	
	import spark.components.RichText;
	
	public class RiskByAgeMediator extends Mediator
	{
		[Inject]
		public var riskByAgeChart:RiskByAge;
		
		[Inject]
		public var runModel:ICardioModel;
		
		[Inject]
		public var appState:AppState;
		
		[Inject]
		public var modelUpdatedSignal:ModelUpdatedSignal;
		
		[Inject(name="userProfile")]
		public var userProfile:UserModel;

		[Inject(name="interventionProfile")]
		public var interventionProfile:UserModel;
		
		private const interventionColour:uint = 0x000000;
		private const targetColour:uint = 0xcc0000;
		
		override public function onRegister() : void
		{
			//trace("OutlookChart register");
			modelUpdatedSignal.add(updateView);
			riskByAgeChart.chanceAxis.maximum = 100;
			riskByAgeChart.lineChart.dataProvider=runModel.getResultSet();

			runModel.commitProperties();
		}
		
		override public function onRemove():void
		{
			//trace("OutlookChart remove");
			modelUpdatedSignal.remove(updateView);
		}
		
		public var gainedLost:String;

		private function updateView():void
		{
			
			riskByAgeChart.withSeries.visible = 
				riskByAgeChart.withLegend.visible = (appState.interventionAge < 95);
			riskByAgeChart.lineChart.dataProvider = runModel.getResultSet();
			riskByAgeChart.ageAxis.minimum = appState.minimumAge;
			riskByAgeChart.chanceAxis.maximum = 10*Math.ceil(runModel.peakf/10);

			annotate();
			
			if(runModel.yearGain > 0) {
				riskByAgeChart.yearGain.text = runModel.yearGain.toPrecision(2);
				gainedLost = "gained"
			}
			else {
				riskByAgeChart.yearGain.text = (-runModel.yearGain).toPrecision(2);
				gainedLost = "lost"					
			}
			
			riskByAgeChart.lineChart.dataTipFunction = dataTipFunction;
			riskByAgeChart.chanceAxis.labelFunction = addPercent;
		}
		
		private function annotate(event:Event = null):void
		{
			
			riskByAgeChart.dataCanvas.clear();
			riskByAgeChart.dataCanvas.removeAllChildren();
			
			riskByAgeChart.dataCanvas.lineStyle(2, interventionColour, 0.6);
			
			var intAge:int = appState.interventionAge; 
			riskByAgeChart.lineChart.validateNow();	// so chanceAxis scales are correct here
			riskByAgeChart.dataCanvas.moveTo(intAge, riskByAgeChart.chanceAxis.minimum);
			riskByAgeChart.dataCanvas.lineTo(intAge, riskByAgeChart.chanceAxis.maximum);
			
			var intLabel:RichText = new RichText();
			intLabel.text = "Intervention Start Age";
			intLabel.setStyle("fontSize", 14);
			intLabel.setStyle("color", interventionColour);
			intLabel.alpha = 0.6;
			intLabel.rotation = -90;
			riskByAgeChart.dataCanvas.addDataChild(intLabel, intAge+0.2, (riskByAgeChart.chanceAxis.minimum + riskByAgeChart.chanceAxis.maximum)/4);
			
			/* add legends */
			var visibleInterventions:Boolean = !userProfile.variableList.equals(interventionProfile.variableList);

			// determine mid-age without intervention risk
			var midAge_int:int = Math.round((intAge + riskByAgeChart.ageAxis.maximum)/2);
			var midAge:int = Math.round((riskByAgeChart.ageAxis.minimum + riskByAgeChart.ageAxis.maximum)/2);
			var result:Object = runModel.getResultSet().getItemAt(midAge - appState.minimumAge);
			var result_int:Object = runModel.getResultSet().getItemAt(midAge_int - appState.minimumAge);
			if(result.fdash_int < result.fdash) {
				riskByAgeChart.dataCanvas.addDataChild(riskByAgeChart.withoutLegend, null, null, midAge, result.fdash);
				if(visibleInterventions)
					riskByAgeChart.dataCanvas.addDataChild(riskByAgeChart.withLegend, midAge_int, result_int.fdash_int);
			}
			else {
				riskByAgeChart.dataCanvas.addDataChild(riskByAgeChart.withoutLegend, midAge, result.fdash);
				if(visibleInterventions)
					riskByAgeChart.dataCanvas.addDataChild(riskByAgeChart.withLegend, null, null, midAge_int, result_int.fdash_int);
			}
		}
		
		private function dataTipFunction(hitData:HitData):String
		{
			var series:LineSeries = hitData.element as LineSeries;
			var s:String = series.legendData[0].label + "\n" + (hitData.item[series.yField]).toPrecision(3) + "%";
			return(s);
		}

		
		private function addPercent(rounded:Number, oldValue:Number, axis:LinearAxis):String
		{
			return rounded.toFixed(0).replace(/\./,"") + "%";
		}
		
	}
}