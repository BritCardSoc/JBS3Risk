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
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import mx.controls.Button;
	
	import org.robotlegs.mvcs.Mediator;
	import org.understandinguncertainty.JBS.model.AppState;
	import org.understandinguncertainty.JBS.signals.NextScreenSignal;
	import org.understandinguncertainty.JBS.signals.ProfileCommitSignal;
	import org.understandinguncertainty.JBS.signals.ProfileCommittedSignal;
	import org.understandinguncertainty.JBS.signals.ProfileValidSignal;
	import org.understandinguncertainty.JBS.signals.ScreenChangedSignal;
	import org.understandinguncertainty.JBS.signals.ScreensNamedSignal;
	
	import spark.components.Group;
	import spark.components.supportClasses.GroupBase;
		
	public class ScreenSelectorMediator extends Mediator
	{
		public function ScreenSelectorMediator()
		{
			super();
		}
		
		[Inject]
		public var profileValidSignal:ProfileValidSignal;
		
		[Inject]
		public var profileCommitSignal:ProfileCommitSignal;
		
		[Inject]
		public var profileCommittedSignal:ProfileCommittedSignal;
		
		[Inject]
		public var screenSelector:ScreenSelector;
		
		[Inject]
		public var screensNamedSignal:ScreensNamedSignal;
		
		[Inject]
		public var screenChangedSignal:ScreenChangedSignal;
		
		[Inject]
		public var nextScreenSignal:NextScreenSignal;
		
		[Inject]
		public var appState:AppState;
		
		// If basic is true we only show the basic screen selection buttons
		private function get basic():Boolean {
			return screenSelector.currentState == 'basic';
		};
		
		override public function onRegister() : void
		{
			profileValidSignal.add(enableCheck);
			screensNamedSignal.add(addThumbnails);
			nextScreenSignal.add(nextScreen);
			profileCommittedSignal.add(dispatchScreenChange);
						
			screenSelector.modeButton.addEventListener(MouseEvent.CLICK, changeMode);
		}
		
		override public function onRemove() : void
		{
			profileValidSignal.remove(enableCheck);
			screensNamedSignal.remove(addThumbnails);
			nextScreenSignal.remove(nextScreen);
			profileCommittedSignal.remove(dispatchScreenChange);
			removeThumbnails();

			screenSelector.modeButton.removeEventListener(MouseEvent.CLICK, changeMode);
		}
		
		private var screenNames:Array;
		private var buttons:Vector.<Button>;
		
		private function addThumbnails(screenNames:Array):void
		{
			this.screenNames = screenNames.concat();
			
			// populate basic thumbnails. We assume basics come before advanced ones
			var basicLength:int = screenSelector.basicThumbnails.numElements;
			populateThumbnailContainer("basicContainer", 0, basicLength);

			// populate advanced thumbnails
			populateThumbnailContainer("advancedContainer", basicLength, this.screenNames.length);

		}
		
		private function populateThumbnailContainer(containerId:String, minIndex:int, len:int):void
		{
			if(buttons == null)
				buttons = new Vector.<Button>();
			
			for(var i:int = minIndex; i < len; i++) {
				var screenName:String = this.screenNames[i] as String;
				var thumbnail:GroupBase = screenSelector[screenName] as GroupBase;
				screenSelector[containerId].addElement(thumbnail);
				buttons[i] = screenSelector[screenName+"Button"] as Button;
				buttons[i].addEventListener(MouseEvent.CLICK, selectScreen);
			}			
		}
		
		private function removeThumbnails():void
		{
			for(var i:int = 0; i < buttons.length; i++) {
				buttons[i].removeEventListener(MouseEvent.CLICK, selectScreen);
			}
		}
		
		private function enableCheck(enabled:Boolean):void {
			var alpha:Number = enabled ? 1 : 0.3;
			
			// skip profile
			for(var i:int = 1; i < screenNames.length; i++) {
				screenSelector[String(screenNames[i])+"Label"].alpha = alpha;
				screenSelector[String(screenNames[i])+"Button"].alpha = alpha;
				screenSelector[String(screenNames[i])+"Button"].enabled = enabled;
			}
		}
				
		private function nextScreen(currentScreen:String):void
		{
			var index:int = screenNames.indexOf(appState.selectedScreenName);
			index = (index + 1) % screenNames.length;
			selectScreenByName(screenNames[index]);
		}
		
		//
		// The screen selector buttons must be named mainPanel.state.name +'Button'
		//
		private function selectScreen(event:MouseEvent):void
		{
			var targetButton:Button = event.target as Button;
			var id:String = targetButton.id;
			var bx:int = id.indexOf("Button");
			if(bx < 1) throw new Error("Invalid button name: " + id);

			selectScreenByName(id.substr(0, bx));

		}
		
		
		private function selectScreenByName(name:String):void
		{
			if(name != appState.selectedScreenName) {
				
				if(appState.selectedScreenName == 'profile') {
					profileCommitSignal.dispatch(name);
				}
				else 
					dispatchScreenChange(name);
					
			}
			
		}
		
		
		private function dispatchScreenChange(name:String):void {
			appState.selectedScreenName = name;
			screenChangedSignal.dispatch(name);			
		}
		
		private function changeMode(event:MouseEvent):void
		{
			if(basic)
				screenSelector.currentState = "advanced";
			else
				screenSelector.currentState = "basic";
		}
/*
		private function toAdvancedMode(event:MouseEvent):void 
		{
			
			removeThumbnails();
			addThumbnails(this.screenNames);
		}
		
		private function toBasicMode(event:MouseEvent):void
		{
			basic = true;
			screenSelector.lessButton.removeEventListener(MouseEvent.CLICK, toBasicMode);
			screenSelector.currentState = "basic";
			screenSelector.moreButton.addEventListener(MouseEvent.CLICK, toAdvancedMode);
			
			removeThumbnails();
			addThumbnails(this.screenNames);

		}
*/
	}
}