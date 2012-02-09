/*
This file forms part of the JBS3Risk Cardiovascular Assessment Tool.
It is ©2012 University of Cambridge.
It is released under version 3 of the GNU General Public License
Source code, including a copy of the license is available at https://github.com/BritCardSoc/JBS3Risk
*/
package org.understandinguncertainty.JBS.view
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import mx.collections.ArrayList;
	import mx.graphics.SolidColor;
	import mx.graphics.SolidColorStroke;
	
	import org.robotlegs.mvcs.Mediator;
	import org.understandinguncertainty.JBS.model.AppState;
	import org.understandinguncertainty.JBS.model.ICardioModel;
	import org.understandinguncertainty.JBS.model.UserModel;
	import org.understandinguncertainty.JBS.model.vo.ShapeData;
	
	public class DifferenceBalanceMediator extends Mediator
	{
		public var differenceBalance:DifferenceBalance;
		
		[Inject]
		public var appState:AppState;
		
		[Inject(name="userProfile")]
		public var userProfile:UserModel;
		
		[Inject]
		public var runModel:ICardioModel;
		
		public function DifferenceBalanceMediator()
		{
			super();
		}
		
		public function get fontSize():int
		{
			return differenceBalance.label.getStyle("fontSize") as int;
		}
		public function set fontSize(size:int):void
		{
			differenceBalance.label.setStyle("fontSize", size);
			//differenceBalance.leftNumber.setStyle("fontSize", size);
			//differenceBalance.rightNumber.setStyle("fontSize", size);
		}
		
		public function get labelPercentWidth():Number {
			return differenceBalance.label.percentWidth;
		}
		public function set labelPercentWidth(pw:Number):void
		{
			differenceBalance.label.percentWidth = pw;
			differenceBalance.leftPeople.percentWidth = differenceBalance.rightPeople.percentWidth = (100 - pw)/2;
		}
		
		public function get text():String
		{
			return differenceBalance.label.text;
		}
		public function set text(s:String):void
		{
			
			var prefix:String = "";
			if(_showDifferences && (leftNumber > 0 || rightNumber > 0)) {
				var d:Number = Math.round(Math.abs(leftNumber - rightNumber));
				if(d > 0) {
					var diff:String = d.toString();
					prefix = "extra "+d+" ";
				}
				else {
					prefix = "no extra ";
				}
			}

			differenceBalance.label.text = prefix + s;
		}
		
		public function get gap():int 
		{
			return differenceBalance.gap;
		}
		public function set gap(g:int):void
		{
			differenceBalance.gap = g;
		}
		
		private var _maxColumns:int = 20;
		public function get maxColumns():int
		{
			return _maxColumns;
		}
		public function set maxColumns(n:int):void
		{
			_maxColumns = n;
			invalidateData();
		}
		
		
		private var _stroke:SolidColorStroke = new SolidColorStroke(0xCCCCCC, 2, 1, false, "normal", "none", "miter", 10);
		public function get stroke():SolidColorStroke
		{
			return _stroke;
		}
		public function set stroke(s:SolidColorStroke):void
		{
			_stroke = s;
			invalidateData()
		}
		
		private var _fill:SolidColor = new SolidColor(0x880000, 1);
		public function get fill():SolidColor
		{
			return _fill;
		}
		public function set fill(s:SolidColor):void
		{
			_fill = s;
			invalidateData()
		}
		
		private var _denominatorFill:SolidColor = new SolidColor(0xffffff, 1);
		public function get denominatorFill():SolidColor
		{
			return _denominatorFill;
		}
		public function set denominatorFill(s:SolidColor):void
		{
			_denominatorFill = s;
			invalidateData()
		}
		
		private var _leftNumber:Number;
		public function get leftNumber():Number
		{
			return _leftNumber;
		}
		public function set leftNumber(n:Number):void
		{
			_leftNumber = n;
//			differenceBalance.leftNumber.text = Math.round(n).toString();
			calculateFractions();
		}
		
		private var _rightNumber:Number;
		public function get rightNumber():Number
		{
			return _rightNumber;
		}
		public function set rightNumber(n:Number):void
		{
			_rightNumber = n;
//			differenceBalance.rightNumber.text = Math.round(n).toString();
			calculateFractions();
		}
		
		private var _showDifferences:Boolean
		public function get showDifferences():Boolean
		{
			return _showDifferences;
		}
		public function set showDifferences(show:Boolean):void
		{
			_showDifferences = show;
			calculateFractions();
		}
		
		protected var _leftNumerator:Number;
		protected var _leftDenominator:Number;
		protected var _rightNumerator:Number;
		protected var _rightDenominator:Number;
		
		protected function calculateFractions():void
		{
			_leftNumerator = _leftDenominator = _leftNumber;
			_rightNumerator = _rightDenominator = _rightNumber;
			differenceBalance.leftArrow.visible = false;
			differenceBalance.rightArrow.visible = false;

			if(_showDifferences) {
				_leftNumerator = _rightNumerator = 0;
				if(_leftNumber > _rightNumber) {
					_leftNumerator = _leftNumber - _rightNumber;
					_rightNumerator = 0;
					differenceBalance.leftArrow.visible = true;
				}
				else if(_leftNumber < _rightNumber) {
					_rightNumerator = _rightNumber - _leftNumber;
					_leftNumerator = 0;
					differenceBalance.rightArrow.visible = true;
				}
			}
			invalidateData();
		}
				
		private var dpLeft:ArrayList;
		private var dpRight:ArrayList;
		
		private function invalidateData():void
		{						
			dpLeft = new ArrayList([]);
			dpRight = new ArrayList([]);
			
			var shape:String = userProfile.gender == "male" ? "man" : "woman";
			updateLeft(shape);
			updateRight(shape);
			
			if(timer == null) {
				startUpdate();
			}
		}
		
		private function updateLeft(shape:String):void
		{

			// We display 1000 people maximum, but allow tenths of a person
			var n:int = Math.floor(_leftNumerator);
			var tenths:int = Math.round((_leftNumerator - n)*10);
			
			if(_leftDenominator > 1000) {
				var outOf1000:Number;
				outOf1000 = 1000 * _leftNumerator/_leftDenominator;
				n = Math.floor(outOf1000);
				tenths = Math.round((outOf1000 - n)*10);
				_leftDenominator = 1000;
			}
			
			// Draw Numerator
			for(var i:int = 0; i < n; i++) {
				
				dpLeft.addItem(new ShapeData(shape, fill, stroke, 10, 10));					
			}
			if(tenths > 0) {
				var dtenths:int = 10;
				if(_leftDenominator < Math.ceil(_leftNumerator)) {
					dtenths = tenthsOf(_leftDenominator);
				}
				dpLeft.addItem(new ShapeData(shape, fill, stroke, tenths, dtenths));
				
				// we've used up one more person to display the fraction, so need to adjust remainder
				if(dtenths < 10)
					return;
				n++;
			}
			
			// Draw remainder
			var remainder:int = Math.floor(_leftDenominator - n);
			for(i=0; i < remainder; i++) {
				dpLeft.addItem(new ShapeData(shape, _denominatorFill, stroke, 10, 10));	
			}			
			dtenths = tenthsOf(_leftDenominator);
			if(dtenths > 0 && dtenths < 10)
				dpLeft.addItem(new ShapeData(shape, _denominatorFill, stroke, dtenths, dtenths));	
		}
		
		private function tenthsOf(n:Number):int
		{
			return Math.round(10*(n - Math.floor(n)));
		}
		
		private function updateRight(shape:String):void
		{

			// We display 1000 people maximum, but allow tenths of a person
			var n:int = Math.floor(_rightNumerator);
			var tenths:int = Math.round((_rightNumerator - n)*10);
			
			if(_rightDenominator > 1000) {
				var outOf1000:Number;
				outOf1000 = 1000 * _rightNumerator/_rightDenominator;
				n = Math.floor(outOf1000);
				tenths = Math.round((outOf1000 - n)*10);
				_rightDenominator = 1000;
			}
			
			// Draw Numerator
			for(var i:int = 0; i < n; i++) {
				
				dpRight.addItem(new ShapeData(shape, fill, stroke, 10, 10));					
			}
			if(tenths > 0) {
				var dtenths:int = 10;
				if(_rightDenominator < Math.ceil(_rightNumerator)) {
					dtenths = tenthsOf(_rightDenominator);
				}
				dpRight.addItem(new ShapeData(shape, fill, stroke, tenths, dtenths));
				
				if(dtenths < 10)
					return;
				// we've used up one more person to display the fraction, so need to adjust remainder
				n++;
			}
			
			// Draw remainder
			var remainder:int = Math.floor(_rightDenominator - n);
			for(i=0; i < remainder; i++) {
				dpRight.addItem(new ShapeData(shape, _denominatorFill, stroke, 10, 10));	
			}
			dtenths = tenthsOf(_rightDenominator);
			if(dtenths > 0 && dtenths < 10)
				dpRight.addItem(new ShapeData(shape, _denominatorFill, stroke, dtenths, dtenths));	
		}
		
		// Update display 10 at a time
		private function startUpdate():void
		{

			// Calculate desired rowCount
			var leftRowCount:int = Math.ceil(_leftNumber / _maxColumns);
			var rightRowCount:int = Math.ceil(_rightNumber / _maxColumns);
			var requestedRowCount:int = Math.max(leftRowCount, rightRowCount);
			
			var people:People = differenceBalance.leftPeople;
			people.requestedRowCount = requestedRowCount;
			if(people.dataProvider)
				people.dataProvider.removeAll();
			else
				people.dataProvider = new ArrayList([]);
		
			people = differenceBalance.rightPeople;
			people.requestedRowCount = requestedRowCount;
			if(people.dataProvider)
				people.dataProvider.removeAll();
			else
				people.dataProvider = new ArrayList([]);
		
			
			// add number labels
			differenceBalance.leftNumber.text = differenceBalance.rightNumber.text = "";
			if(_showDifferences) {
				if(_leftNumerator > 0)
					differenceBalance.leftNumber.text = Math.round(_leftNumerator).toString();
				else if(_rightNumerator > 0)
					differenceBalance.rightNumber.text = Math.round(_rightNumerator).toString();
			}
			else {
				if(leftNumber > 0)
					differenceBalance.leftNumber.text = Math.round(leftNumber).toString();
				if(rightNumber > 0)
				differenceBalance.rightNumber.text = Math.round(rightNumber).toString();
			}
			
			displaySome();
			
			//trace("end updateDisplay");
		}
		
		private function displaySome(event:TimerEvent = null):void
		{
			var dp:ArrayList = differenceBalance.leftPeople.dataProvider as ArrayList;
			
			var limitLeft:int = Math.min(dpLeft.length, dp.length + 100);
			for(var i:int = dp.length; i < limitLeft; i++) {
				dp.addItem(dpLeft.getItemAt(i));
			}
			
			dp = differenceBalance.rightPeople.dataProvider as ArrayList;
			var limitRight:int = Math.min(dpRight.length, dp.length + 100);
			for(i = dp.length; i < limitRight; i++) {
				dp.addItem(dpRight.getItemAt(i));
			}
			
			if(limitLeft < dpLeft.length || limitRight < dpRight.length) {
				if(timer == null) {
					timer = new Timer(10);
					timer.addEventListener(TimerEvent.TIMER, displaySome);
					timer.start();
				}
			}
			else {
				// we're done
				if(timer) {
					timer.stop();
					timer.removeEventListener(TimerEvent.TIMER, displaySome);
					timer = null;
				}
			}
		}
		
		private var timer:Timer;

	}
}