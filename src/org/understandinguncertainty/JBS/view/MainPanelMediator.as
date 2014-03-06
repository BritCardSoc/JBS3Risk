/*
This file forms part of the JBS3Risk Cardiovascular Assessment Tool.
It is ©2012 University of Cambridge.
It is released under version 3 of the GNU General Public License
Source code, including a copy of the license is available at https://github.com/BritCardSoc/JBS3Risk
*/
package org.understandinguncertainty.JBS.view
{
	import mx.states.State;
	
	import org.robotlegs.mvcs.Mediator;
	import org.understandinguncertainty.JBS.signals.ReleaseScreenSignal;
	import org.understandinguncertainty.JBS.signals.ScreenChangedSignal;
	import org.understandinguncertainty.JBS.signals.ScreensNamedSignal;
	
	public class MainPanelMediator extends Mediator
	{

		[Inject]
		public var mainPanel:MainPanel;
		
		[Inject]
		public var screenChangedSignal:ScreenChangedSignal;
		
		[Inject]
		public var releaseScreenSignal:ReleaseScreenSignal;
				
		[Inject]
		public var screensNamedSignal:ScreensNamedSignal;
		
		override public function onRegister():void
		{
			screenChangedSignal.add(changeScreen);
			screensNamedSignal.dispatch(screens);
		}
		
		override public function onRemove():void
		{
			screenChangedSignal.remove(changeScreen);
		}
		
		private function changeScreen(s:String):void
		{
			selectedScreen = s;
		}
		
		private var _screens:Array;

		public function get screens():Array 
		{
			if(_screens) return _screens;
			
			var states:Array = mainPanel.states;
			_screens = [];
			for(var i:int = 0; i < states.length; i++) {
				_screens[i] = (states[i] as State).name;
			}
			return _screens;
		}
				
		public function get selectedScreen():String
		{
			return mainPanel.currentState;
		}
		public function set selectedScreen(s:String):void
		{
			mainPanel.currentState = s;
			trace("switching mainPanel state to "+s);
			
			if(s == "profile") {
				releaseScreenSignal.dispatch();
			}
		}

	}
}