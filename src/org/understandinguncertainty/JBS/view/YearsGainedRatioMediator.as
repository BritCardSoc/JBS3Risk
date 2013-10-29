/*
This file forms part of the JBS3Risk Cardiovascular Assessment Tool.
It is ©2012 University of Cambridge.
It is released under version 3 of the GNU General Public License
Source code, including a copy of the license is available at https://github.com/BritCardSoc/JBS3Risk
*/
package org.understandinguncertainty.JBS.view
{
	import flash.events.Event;
	
	import mx.charts.ChartItem;
	import mx.charts.HitData;
	import mx.charts.LinearAxis;
	import mx.charts.series.AreaSeries;
	import mx.charts.series.items.ColumnSeriesItem;
	import mx.collections.ArrayCollection;
	import mx.graphics.IFill;
	import mx.graphics.SolidColor;
	
	import org.robotlegs.mvcs.Mediator;
	import org.understandinguncertainty.JBS.model.AppState;
	import org.understandinguncertainty.JBS.model.ICardioModel;
	import org.understandinguncertainty.JBS.model.UserModel;
	import org.understandinguncertainty.JBS.signals.ModelUpdatedSignal;
	import org.understandinguncertainty.JBS.signals.UpdateModelSignal;
	import org.understandinguncertainty.QRLifetime.vo.QResultVO;
	
	import spark.components.RadioButtonGroup;
	import spark.components.RichText;
	
	public class YearsGainedRatioMediator extends Mediator
	{
		[Inject]
		public var yearsGainedChart:YearsGainedRatio;
		
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
			yearsGainedChart.chanceAxis.maximum = 10;
			yearsGainedChart.chart.dataProvider=runModel.gainsByYear;
			yearsGainedChart.series.fillFunction = colouring;
			yearsGainedChart.chart.dataTipFunction = dataTipFunction;
			yearsGainedChart.endTreatmentAge.addEventListener(Event.CHANGE, changeEndTreatment);
			appState.interventionAge = userProfile.age;
			runModel.endTreatmentAge = yearsGainedChart.endTreatmentAge.selectedValue as int;
			runModel.commitProperties();
		}
		
		override public function onRemove():void
		{
			//trace("OutlookChart remove");
			yearsGainedChart.endTreatmentAge.removeEventListener(Event.CHANGE, changeEndTreatment);
			modelUpdatedSignal.remove(updateView);
		}
		
		private function changeEndTreatment(event:Event):void {
			runModel.endTreatmentAge = event.currentTarget.selectedValue;
			runModel.commitProperties();			
		}
		
		
		public function colouring(item:ChartItem, index:Number):IFill {
			var curItem:ColumnSeriesItem = ColumnSeriesItem(item);
			if (curItem.yNumber >= 0)
				return yearsGainedChart.betterFill;
			else
				return yearsGainedChart.badFill;
		}
		
		public var gainedLost:String;
		
		private function updateView():void
		{
			
			var max:Number = 0;
			var min:Number = 100;
			for(var i:int=0; i < runModel.gainsByYear.length; i++) {
				var obj:Object = runModel.gainsByYear.getItemAt(i);
				var v:Number = obj.ratio;
				if (v>max)
					max = v;
				if (v< min)
					min = v;
			}
			max = max > 0 ? /*max + (max - min)/2*/ 0.4 : 0;
			min = min < 0 ? /*min + (min - max)/2 */ -0.4: 0;
			yearsGainedChart.chanceAxis.maximum = max;
			yearsGainedChart.chanceAxis.minimum = min;
			
			yearsGainedChart.chart.dataProvider = runModel.gainsByYear;
			yearsGainedChart.ageAxis.minimum = appState.minimumAge - 5;
			yearsGainedChart.ageAxis.maximum = 70 + 5;

		}
		
		
		private function dataTipFunction(hitData:HitData):String
		{
			var item:Object = hitData.item;
			
			return item.ratio.toFixed(2) + " gain/year";
		}
		

		
		private function addPercent(rounded:Number, oldValue:Number, axis:LinearAxis):String
		{
			return rounded.toFixed(0).replace(/\./,"") + "%";
		}
		
	}
}