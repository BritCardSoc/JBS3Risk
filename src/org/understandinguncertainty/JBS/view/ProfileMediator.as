/*
This file forms part of the JBS3Risk Cardiovascular Assessment Tool.
It is ©2012 University of Cambridge.
It is released under version 3 of the GNU General Public License
Source code, including a copy of the license is available at https://github.com/BritCardSoc/JBS3Risk
*/
package org.understandinguncertainty.JBS.view
{
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.core.FlexGlobals;
	
	import org.robotlegs.mvcs.Mediator;
	import org.understandinguncertainty.JBS.model.AppState;
	import org.understandinguncertainty.JBS.model.ICardioModel;
	import org.understandinguncertainty.JBS.model.UserModel;
	import org.understandinguncertainty.JBS.signals.ClearInterventionsSignal;
	import org.understandinguncertainty.JBS.signals.NextScreenSignal;
	import org.understandinguncertainty.JBS.signals.ProfileCommitSignal;
	import org.understandinguncertainty.JBS.signals.ProfileLoadSignal;
	import org.understandinguncertainty.JBS.signals.ProfileSaveSignal;
	import org.understandinguncertainty.JBS.signals.ProfileValidSignal;
	import org.understandinguncertainty.personal.PersonalisationFileStore;
	import org.understandinguncertainty.personal.VariableList;
	
	public class ProfileMediator extends Mediator
	{
		
		[Inject]
		public var profile:Profile;
		
		[Inject]
		public var profileValidSignal:ProfileValidSignal;
		
		[Inject]
		public var profileLoadSignal:ProfileLoadSignal;
		
		[Inject]
		public var profileSaveSignal:ProfileSaveSignal;
		
		[Inject]
		public var profileCommitSignal:ProfileCommitSignal;
		
		[Inject]
		public var nextScreenSignal:NextScreenSignal;
		
		[Inject(name="userProfile")]
		public var userProfile:UserModel;		
		
		[Inject]
		public var runModel:ICardioModel;
		
		[Inject]
		public var appState:AppState;
		
		[Inject(name="userProfile")]
		public var user:UserModel;
		
		[Inject(name="interventionProfile")]
		public var inter:UserModel;
		
		[Inject]
		public var clearInterventionsSignal:ClearInterventionsSignal;
		
		private var ps:PersonalisationFileStore;
		
		override public function onRegister():void
		{
			//trace("Profile Register");
			ps = userProfile.personalData;

			profile.totalCholUnits.dataProvider = cholUnitFactors;
			profile.hdlCholUnits.dataProvider = cholUnitFactors;
			
			profile.totalCholUnits.selectedIndex = 0;
			profile.hdlCholUnits.selectedIndex = 0;
			appState.mmol = (cholesterolUnit == mmol_L);				

			validate();
			addEventListeners();
			loadFromURL();
		}
		
		override public function onRemove():void
		{
			removeEventListeners();
			runModel.commitProperties();
		}
		
		private function addEventListeners():void {
			profileCommitSignal.add(commitProfile);
			profileLoadSignal.add(loadPersonalDetails);
			profileSaveSignal.add(savePersonalDetails);
			
			profile.dd.addEventListener(Event.CHANGE, validate);
			profile.mm.addEventListener(Event.CHANGE, validate);
			profile.yyyy.addEventListener(Event.CHANGE, validate);
			
			profile.totalCholesterolInput.addEventListener(Event.CHANGE, validate);
			profile.hdlCholesterolInput.addEventListener(Event.CHANGE, validate);
			profile.systolicBloodPressureInput.addEventListener(Event.CHANGE, validate);
			
			profile.totalCholUnits.addEventListener(Event.CHANGE, changedUnits);
			profile.hdlCholUnits.addEventListener(Event.CHANGE, changedUnits);
			
			profile.saveButton.addEventListener(MouseEvent.CLICK, save);
			profile.loadButton.addEventListener(MouseEvent.CLICK, load);
			profile.nextButton.addEventListener(MouseEvent.CLICK, nextScreen);	
		}
		
		private function removeEventListeners():void {
			profileCommitSignal.remove(commitProfile);
			profileLoadSignal.remove(loadPersonalDetails);
			profileSaveSignal.remove(savePersonalDetails);

			profile.dd.removeEventListener(Event.CHANGE, validate);
			profile.mm.removeEventListener(Event.CHANGE, validate);
			profile.yyyy.removeEventListener(Event.CHANGE, validate);
			
			profile.totalCholesterolInput.removeEventListener(Event.CHANGE, validate);
			profile.hdlCholesterolInput.removeEventListener(Event.CHANGE, validate);
			profile.systolicBloodPressureInput.removeEventListener(Event.CHANGE, validate);
			
			profile.totalCholUnits.removeEventListener(Event.CHANGE, changedUnits);
			profile.hdlCholUnits.removeEventListener(Event.CHANGE, changedUnits);
			
			profile.saveButton.removeEventListener(MouseEvent.CLICK, save);
			profile.loadButton.removeEventListener(MouseEvent.CLICK, load);
			profile.nextButton.removeEventListener(MouseEvent.CLICK, nextScreen);	
		}
		
		private function save(event:MouseEvent):void
		{
			profileSaveSignal.dispatch();
		}
		
		private function load(event:MouseEvent):void 
		{
			profileLoadSignal.dispatch();
		}
		
		private function nextScreen(event:MouseEvent):void
		{
			nextScreenSignal.dispatch("profile");
		}
		
		
		private function loadPersonalDetails(event:Event = null):void {
			ps.addEventListener(PersonalisationFileStore.DATAREADY, showPersonalData, false, 0, true);
			ps.load();
		}
		
		private function savePersonalDetails():void {
			setPersonalDetails();
			ps.save();
		}
		
		//
		// populate the form with variable list data
		//
		private function showPersonalData(event:Event=null):void {
			var pvars:VariableList = ps.variableList;
			var dob:Date = pvars.dateOfBirth.value as Date;
			profile.yyyy.text = dob.fullYear.toString();
//			trace("spd", profile.yyyy.text);
			profile.mm.text = (dob.month + 1).toString();
			profile.dd.text = dob.date.toString();
			profile.gender.selectedValue = pvars.gender.toString(); 
			profile.smoker.selected = !pvars.nonSmoker.value;
			profile.quitSmoker.selected = pvars.quitSmoker.value;
			profile.active.selected = pvars.active.value;
			profile.diabetic.selected = pvars.diabetic.value;
			
			hdlCholesterol_mmol_L = Number(pvars.hdlCholesterol_mmol_L);
			totalCholesterol_mmol_L = Number(pvars.totalCholesterol_mmol_L);
			
			profile.systolicBloodPressure = Number(pvars.systolicBloodPressure);
			profile.SBPTreated.selected = pvars.SBPTreated.value;
						
			validate();
			
		}
		
		//
		// glean a variable list from the form data
		//
		private function setPersonalDetails():void {
			var pvars:VariableList = ps.variableList;
			pvars.dateOfBirth.fromString([profile.dd.text, profile.mm.text, profile.yyyy.text].join(":"));
			pvars.gender.fromString(profile.gender.selectedValue as String);
			pvars.nonSmoker.value = !profile.smoker.selected;
			pvars.quitSmoker.value = profile.quitSmoker.selected;
			pvars.active.value = profile.active.selected;
			pvars.diabetic.value = profile.diabetic.selected
			pvars.hdlCholesterol_mmol_L.value = hdlCholesterol_mmol_L;
			pvars.totalCholesterol_mmol_L.value = totalCholesterol_mmol_L;
			pvars.systolicBloodPressure.value = profile.systolicBloodPressure;
			pvars.SBPTreated.value = profile.SBPTreated.selected;
			
			userProfile.isValid = false;
		}
		
		//
		//---- View click events ----
		// 		
		private function commitProfile():void {
			//trace("commitProfile");

			// Set the user profile bvariableList BEFORE cloning it into the interventions profile
			setPersonalDetails();			
			inter.variableList = user.variableList.clone();
			
			
			//trace("profile = " + user.variableList);
			//trace("profile_int = " + inter.variableList);
			
			clearInterventionsSignal.dispatch();
			
		}
		
		/*------- load from URL ----------*/
		public var configURL:String;
		
		private var loader:URLLoader;
		
		public function loadFromURL():void
		{
			// Acquire configURL from flashVar "config" 
			configURL = FlexGlobals.topLevelApplication.parameters.config;
			if(!configURL || configURL.match(/^\s*$/)) {
				showPersonalData(null);
				return;
			}
			
			//Alert.show("configURL = "+configURL);
			
			var request:URLRequest = new URLRequest(configURL);
			if(!loader) {
				loader = new URLLoader(request);
				addLoaderListeners();
			}
			try {
				loader.load(request);
			}
			catch(e:Error) {
				Alert.show(e.message, "Error opening "+configURL, Alert.OK);
			}
		}
		
		private function readLoader(event:Event):void
		{
			//trace(loader.data);
			var pvars:VariableList = ps.variableList;
			pvars.readXML(new XML(loader.data));
			showPersonalData();
		}
		
		private function addLoaderListeners():void {
			loader.addEventListener(Event.COMPLETE, readLoader, false, 0, true);
			loader.addEventListener(Event.OPEN, openHandler, false, 0, true);
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler, false, 0, true);
			loader.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler, false, 0, true);
			loader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler, false, 0, true);
		}
		
		private function openHandler(event:Event):void {
			Alert.show(event.toString(), "Open");
		}
		
		private function securityErrorHandler(event:SecurityErrorEvent):void {
			Alert.show(event.toString(), "Network error");
		}
		
		private function httpStatusHandler(event:HTTPStatusEvent):void {
			Alert.show(event.toString(),"HTTP error");
		}
		
		private function ioErrorHandler(event:IOErrorEvent):void {
			Alert.show(event.toString(),"Network error");
		}
		
		public function validate(event:Event = null):void {
			// we don't want lazy validation here!
			var e1:Boolean = (profile.hdlCholValidator.validate().results != null);
			var e2:Boolean = (profile.totalCholValidator.validate().results != null);
			var e3:Boolean = (profile.dateValidator.validate().results != null)
			var e4:Boolean = (profile.sbpValidator.validate().results != null);

			if(e1 || e2 || e3 || e4) {
				isValid = false;
				profile.nextButton.enabled = false;
				profileValidSignal.dispatch(false);
			}
			else {
				isValid = true;
				profile.nextButton.enabled = true;
				profileValidSignal.dispatch(true);
			}
		}
		
		private var isValid:Boolean = false;
		
		
		private function updateCholesterolRatio():void
		{
			var cholesterolRatio:Number = totalCholesterol / hdlCholesterol;
		}
		
		public function get totalCholesterol():Number
		{
			return Number(profile.totalCholesterolInput.text);
		}
		public function set totalCholesterol(value:Number):void
		{
			profile.totalCholesterolInput.text = value.toPrecision(3);
			updateCholesterolRatio();
		}
		
		public function get hdlCholesterol():Number
		{
			return Number(profile.hdlCholesterolInput.text);
		}
		public function set hdlCholesterol(value:Number):void
		{
			profile.hdlCholesterolInput.text = value.toPrecision(3);
			updateCholesterolRatio();
		}
		

		private function currentYear():int 
		{
			var d:Date = new Date();
			return d.fullYear;
		}
		
		
		private const cholConversionFactor:Number = 38.7;
		private var mmol_L:String = "mmol/L";
		private var mg_dL:String = "mg/dL";
		
		public function get cholesterolUnit():String
		{
			if(profile.totalCholUnits.selectedIndex < 0) {
				profile.totalCholUnits.selectedIndex = 0;
				profile.hdlCholUnits.selectedIndex = 0;
			}
			return profile.totalCholUnits.selectedItem.unit;
		}
		
		private var _cholesterolFactor:Number = 1;
		public function get cholesterolFactor():Number
		{
			return _cholesterolFactor;
		}
		public function set cholesterolFactor(f:Number):void
		{
			_cholesterolFactor = f;
			
			profile.totalCholValidator.minValue = f;
			profile.totalCholValidator.maxValue = 20*f;
			
			profile.hdlCholValidator.minValue = 0.1*cholesterolFactor;
			profile.hdlCholValidator.maxValue = 12*cholesterolFactor;
			
		}
		
		public function get totalCholesterol_mmol_L():Number
		{
			if(cholesterolUnit == mmol_L)
				return totalCholesterol;
			else
				return totalCholesterol / cholConversionFactor;
		}
		public function set totalCholesterol_mmol_L(value:Number):void
		{
			if(cholesterolUnit == mmol_L)
				totalCholesterol = value;
			else
				totalCholesterol = value * cholConversionFactor;
			
		}
		
		public function get hdlCholesterol_mmol_L():Number
		{
			if(cholesterolUnit == mmol_L)
				return hdlCholesterol;
			else
				return hdlCholesterol / cholConversionFactor;
		}
		public function set hdlCholesterol_mmol_L(value:Number):void
		{
			if(cholesterolUnit == mmol_L)
				hdlCholesterol = value;
			else
				hdlCholesterol = value * cholConversionFactor;
		}
		
		
		private var cholUnitFactors:ArrayCollection = new ArrayCollection([
			{unit:"mmol/L", factor: 1},
			{unit:"mg/dL", factor: 1 / cholConversionFactor},
		]);
		
		
		
		
		private function changedUnits(event:Event):void
		{
			if(event.currentTarget == profile.totalCholUnits) {
				profile.hdlCholUnits.selectedIndex = profile.totalCholUnits.selectedIndex;
			}
			else {
				profile.totalCholUnits.selectedIndex = profile.hdlCholUnits.selectedIndex;					
			}
			cholesterolFactor = (cholesterolUnit == mmol_L) ? 1 : cholConversionFactor;
			appState.mmol = (cholesterolUnit == mmol_L);
			validate();
		}
		
		private var _metres:Number = 1.75;
		public function get metres():Number
		{
			return _metres;
		}
		public function set metres(m:Number):void
		{
			_metres = m;
		}
		
		public var kg:Number = 1.75;
		public var bmi:Number = 1;
		
		
		private var feet:Number = 5;
		
		public var inches:Number = 10;
		public var stones:Number = 10;
		public var pounds:Number = 0;
		public var lbs:Number = 150;
				
	}
}