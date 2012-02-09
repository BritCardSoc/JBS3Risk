/*
This file forms part of the JBS3Risk Cardiovascular Assessment Tool.
It is ©2012 University of Cambridge.
It is released under version 3 of the GNU General Public License
Source code, including a copy of the license is available at https://github.com/BritCardSoc/JBS3Risk
*/
package org.understandinguncertainty.personal
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.FileReference;
	import flash.utils.*;
	
	import mx.controls.Alert;
	
	import org.understandinguncertainty.personal.interfaces.IPersonalVariable;
	import org.understandinguncertainty.personal.interfaces.IPersonalisationStore;
	
	public class PersonalisationFileStore extends EventDispatcher implements IPersonalisationStore
	{
		private var _variableList:VariableList;
		
		private var loadFile:FileReference;
		private var saveFile:FileReference;
		
		public static const DATAREADY:String = "dataReady";
		
		public function PersonalisationFileStore(vList:VariableList) {
			
			_variableList = vList;
		}
		
		[Deprecated(replacement='variableList')]
		public function get variable():VariableList {
			return variableList;
		}
		
		public function get variableList():VariableList {
			return _variableList;
		}

		/**
		 * 
		 * @return a clone of the PersonalisationFileStore variableList which can safely store the 
		 * variables even when the store is deleted.
		 * 
		 */
		private var inProgress:Boolean = false;
		
		/**
		 * Load the store from a file
		 */
		public function load():void {
			if(inProgress) return;
			inProgress = true;
			if(!loadFile) loadFile = new FileReference();
			loadFile.addEventListener(Event.CANCEL, loadFileCancelled);
			loadFile.addEventListener(Event.SELECT, loadFileSelected);
			loadFile.browse();
		}
		
		private function loadFileSelected(event:Event):void {
			var f:FileReference = event.target as FileReference;
			f.addEventListener(Event.COMPLETE, loadFileCompleted);
			f.addEventListener(flash.events.IOErrorEvent.IO_ERROR, loadError);
			f.load();
		}
		
		private function loadFileCancelled(event:Event):void { 
			var f:FileReference = event.target as FileReference;
			inProgress = false;
		}
		
		private function loadFileCompleted(event:Event):void {
			var f:FileReference = event.target as FileReference;
			var s:String = f.data.toString(); 
			var filedata:XML = new XML(s);
						
			variableList.readXML(filedata);
			
			dispatchEvent(new Event(DATAREADY));
			inProgress = false;
		}
		
		private function loadError(event:Event):void {
			trace("loadError");
			inProgress = false;
		}
		
		/**
		 * Save the store to persistent memory
		 */
		public function save():void {
			if(inProgress) return;
			inProgress = true;
			if(!saveFile) saveFile = new FileReference();
			saveFile.addEventListener(Event.CANCEL, saveFileCancelled);
			saveFile.addEventListener(Event.COMPLETE, saveFileCompleted);
			saveFile.addEventListener(flash.events.IOErrorEvent.IO_ERROR, saveError);
			saveFile.save(variableList.writeXML(), "personaldata.xml");
		}
		
		public function saveFileCancelled(event:Event):void {
			var f:FileReference = event.target as FileReference;
			inProgress = false;
		}
		
		private function saveFileCompleted(event:Event):void {
			var f:FileReference = event.target as FileReference;
			inProgress = false;
		}

		private function saveError(event:Event):void {
			//trace("saveError");
			inProgress = false;
		}		
		
		/**
		 * Empty this personalisation store
		 */
		public function clear():void {
			_variableList = new VariableList();
		}
		
		/**
		 * return a reference to a personalisation variable
		 */
		public function  getVariable(instanceName:String):IPersonalVariable {
			return variableList.getVariable(instanceName);
		}
	}
}