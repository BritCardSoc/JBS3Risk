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
	import flash.events.TimerEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.utils.Timer;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.controls.ToolTip;
	import mx.core.FlexGlobals;
	import mx.managers.ToolTipManager;
	import mx.validators.NumberValidator;
	import mx.validators.Validator;
	
	import org.robotlegs.mvcs.Mediator;
	import org.understandinguncertainty.JBS.model.AppState;
	import org.understandinguncertainty.JBS.model.ICardioModel;
	import org.understandinguncertainty.JBS.model.UserModel;
	import org.understandinguncertainty.JBS.signals.NextScreenSignal;
	import org.understandinguncertainty.JBS.signals.ProfileCommitSignal;
	import org.understandinguncertainty.JBS.signals.ProfileCommittedSignal;
	import org.understandinguncertainty.JBS.signals.ProfileLoadSignal;
	import org.understandinguncertainty.JBS.signals.ProfileSaveSignal;
	import org.understandinguncertainty.JBS.signals.ProfileValidSignal;
	import org.understandinguncertainty.QRLifetime.FlashScore2011;
	import org.understandinguncertainty.QRLifetime.vo.QParametersVO;
	import org.understandinguncertainty.personal.PersonalisationFileStore;
	import org.understandinguncertainty.personal.VariableList;
	
	import spark.components.NumericStepper;
	
	public class QProfileMediator extends Mediator
	{
		
		[Inject]
		public var profile:QProfile;
		
		[Inject]
		public var profileValidSignal:ProfileValidSignal;
		
		[Inject]
		public var profileLoadSignal:ProfileLoadSignal;
		
		[Inject]
		public var profileSaveSignal:ProfileSaveSignal;
		
		[Inject]
		public var profileCommitSignal:ProfileCommitSignal;
		
		[Inject]
		public var profileCommittedSignal:ProfileCommittedSignal;
		
		[Inject]
		public var nextScreenSignal:NextScreenSignal;
		
		[Inject(name="userProfile")]
		public var userProfile:UserModel;		
		
		[Inject]
		public var runModel:ICardioModel;
		
		[Inject]
		public var appState:AppState;
		
		//[Inject(name="userProfile")]
		//public var user:UserModel;
		
		[Inject(name="interventionProfile")]
		public var inter:UserModel;
		
//		[Inject]
//		public var clearInterventionsSignal:ClearInterventionsSignal;
		
		private var ps:PersonalisationFileStore;
		
		private var timer:Timer = new Timer(100,1);
		
		override public function onRegister():void
		{
			//trace("Profile Register");
			ps = userProfile.personalData;

			// Ethnic group selection (should chinese be 'far eastern' ? 
			profile.ethnicGroup.dataProvider = new ArrayCollection([
				"White or not stated",
				"Indian",
				"Pakistani",
				"Bangladeshi",
				"Other Asian",
				"Black Caribbean",
				"Black African",
				"Chinese",
				"Other ethnic group"
				]);
			
			// Townsend quintile selection
			profile.townsendGroup.dataProvider = new ArrayCollection([
				"1: Affluent",
				"2: ",
				"3: Average",
				"4: ",
				"5: Least affluent",
				]);
			
			profile.smokerGroup.dataProvider = new ArrayCollection([
				"No",
				"I quit",
				"I smoke less than 10/day",
				"I smoke less than 20/day",
				"I smoke 20+/day"
				]);
			
			profile.cholUnits.dataProvider = cholUnitFactors;
			
			profile.cholUnits.selectedIndex = 0;
			appState.mmol = (cholesterolUnit == mmol_L);				
			
			validate();
			addEventListeners();
			loadFromURL();
		}
		
		override public function onRemove():void
		{
			removeEventListeners();
			//runModel.commitProperties();
		}
		
		private function addEventListeners():void {
			profileCommitSignal.add(selectScreen);
			profileLoadSignal.add(loadPersonalDetails);
			profileSaveSignal.add(savePersonalDetails);
			
			profile.cvdAlready.addEventListener(Event.CHANGE, validate);
			profile.termsCheckbox.addEventListener(Event.CHANGE, validate);
			profile.termsButton.addEventListener(MouseEvent.CLICK, visitTerms);
			
			profile.ddStep.addEventListener(Event.CHANGE, validate);
			profile.mmStep.addEventListener(Event.CHANGE, validate);
			profile.yyyyStep.addEventListener(Event.CHANGE, validate);
			
			profile.height_mStep.addEventListener(Event.CHANGE, validate);
			profile.weight_kgStep.addEventListener(Event.CHANGE, validate);
			
			profile.townsendGroup.addEventListener(Event.CHANGE, showTownsendImage);
			
			profile.totalCholesterolStep.addEventListener(Event.CHANGE, molChanged);
			profile.hdlCholesterolStep.addEventListener(Event.CHANGE, molChanged);
			
			profile.totalCholesterolStep_mgdl.addEventListener(Event.CHANGE, mgChanged);
			profile.hdlCholesterolStep_mgdl.addEventListener(Event.CHANGE, mgChanged);
			
			
			profile.systolicBloodPressureInputStep.addEventListener(Event.CHANGE, validate);
			
			profile.cholUnits.addEventListener(Event.CHANGE, changedUnits);
			
			profile.saveButton.addEventListener(MouseEvent.CLICK, save);
			profile.loadButton.addEventListener(MouseEvent.CLICK, load);
			profile.nextButton.addEventListener(MouseEvent.CLICK, nextScreen);

			timer.addEventListener(TimerEvent.TIMER_COMPLETE, finishUnitChange);
			
		}
		
		private function removeEventListeners():void {
			profileCommitSignal.remove(selectScreen);
			profileLoadSignal.remove(loadPersonalDetails);
			profileSaveSignal.remove(savePersonalDetails);

			profile.cvdAlready.removeEventListener(Event.CHANGE, validate);
			profile.termsCheckbox.removeEventListener(Event.CHANGE, validate);
			profile.termsButton.removeEventListener(MouseEvent.CLICK, visitTerms);

			profile.ddStep.removeEventListener(Event.CHANGE, validate);
			profile.mmStep.removeEventListener(Event.CHANGE, validate);
			profile.yyyyStep.removeEventListener(Event.CHANGE, validate);
			
			profile.height_mStep.removeEventListener(Event.CHANGE, validate);
			profile.weight_kgStep.removeEventListener(Event.CHANGE, validate);
			
			profile.townsendGroup.removeEventListener(Event.CHANGE, showTownsendImage);

			profile.totalCholesterolStep.removeEventListener(Event.CHANGE, validate);
			profile.hdlCholesterolStep.removeEventListener(Event.CHANGE, validate);

			profile.totalCholesterolStep_mgdl.removeEventListener(Event.CHANGE, validate);
			profile.hdlCholesterolStep_mgdl.removeEventListener(Event.CHANGE, validate);
			
			profile.systolicBloodPressureInputStep.removeEventListener(Event.CHANGE, validate);
			
			profile.cholUnits.removeEventListener(Event.CHANGE, changedUnits);
			
			profile.saveButton.removeEventListener(MouseEvent.CLICK, save);
			profile.loadButton.removeEventListener(MouseEvent.CLICK, load);
			profile.nextButton.removeEventListener(MouseEvent.CLICK, nextScreen);	

			timer.removeEventListener(TimerEvent.TIMER_COMPLETE, finishUnitChange);
			
		}
		
		private function visitTerms(event:MouseEvent):void
		{
			navigateToURL(new URLRequest("http://www.jbs3risk.co.uk/pages/terms.asp"), "_blank");
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
			commitProfile();
			nextScreenSignal.dispatch("profile");
		}
		
		private function selectScreen(name:String):void
		{
			//# trace("selectScreen "+name);
			commitProfile();
			profileCommittedSignal.dispatch(name);
		}
		
		
		private function loadPersonalDetails(event:Event = null):void {
			ps.addEventListener(PersonalisationFileStore.DATAREADY, showPersonalData, false, 0, true);
			ps.load();
		}
		
		private function savePersonalDetails():void {
			setPersonalDetails();
			ps.save();
		}
		
		private var _cholesterolValidationOn:Boolean = true;
		private function set cholesterolValidationOn(b:Boolean):void {
			_cholesterolValidationOn = b;

			profile.totalCholValidator.enabled = b;
			profile.totalCholValidator_mgdl.enabled = b;
			profile.hdlCholValidator.enabled = b;
			profile.hdlCholValidator_mgdl.enabled = b;
		
		}
		private function get cholesterolValidationOn():Boolean {
			return _cholesterolValidationOn;
		}
		
		//
		// populate the form with variable list data
		//
		private function showPersonalData(event:Event=null):void {
			var pvars:VariableList = ps.variableList;
			var dob:Date = pvars.dateOfBirth.value as Date;
			//trace("profile:showing dob=",dob);
			profile.yyyyStep.value = dob.fullYear; //.toString();
			profile.mmStep.value = (dob.month + 1);
			profile.ddStep.value = dob.date;
			profile.gender.selectedValue = pvars.gender.toString();
			
			// extra Q parameters
			profile.ethnicGroup.selectedIndex = Number(pvars.ethnicGroup);
			profile.height_mStep.value = pvars.height_m.value;
			profile.weight_kgStep.value = pvars.weight_kg.value;
			profile.townsendGroup.selectedIndex = Number(pvars.townsendGroup);
			profile.fh.selected = pvars.relativeHadCVD.value;
			profile.crd.selected = pvars.chronicRenalDisease.value;
			profile.af.selected = pvars.atrialFibrillation.value;
			profile.ra.selected = pvars.rheumatoidArthritis.value;
			profile.smokerGroup.selectedIndex = Number(pvars.smokerGroup);
			
			profile.diabetic.selected = pvars.diabetic.value;
			
			var hdl:Number = Number(pvars.hdlCholesterol_mmol_L);
			var total:Number = Number(pvars.totalCholesterol_mmol_L);
			
			// We validate the cholesterol ratio - which means both hdl and total cholesterol must be
			// set before validation happens. So we disable the validators, then set both, then reenable.
			
			cholesterolValidationOn = false;
			profile.hdlCholesterolStep.value = hdl;
			profile.totalCholesterolStep.value = total;
			profile.hdlCholesterolStep_mgdl.value = mol2mg(hdl);
			profile.totalCholesterolStep_mgdl.value = mol2mg(total);
			
			profile.hdlCholesterolStep.validateNow();
			profile.totalCholesterolStep.validateNow();
			profile.hdlCholesterolStep_mgdl.validateNow();
			profile.totalCholesterolStep_mgdl.validateNow();
			
			cholesterolValidationOn = true;
			
			// calculate nonHDL from values in the Steppers - so the displayed difference is correct whatever the rounding
			var nonHDL:Number = profile.totalCholesterolStep.value - profile.hdlCholesterolStep.value;
			var nonHDL_mgdl:Number = profile.totalCholesterolStep_mgdl.value - profile.hdlCholesterolStep_mgdl.value;
			
			profile.nonHDLField.text = "NonHDL Cholesterol: " + nonHDL.toFixed(1);
			profile.nonHDLField_mgdl.text = "NonHDL Cholesterol: " + nonHDL_mgdl.toFixed(0);
			
			profile.systolicBloodPressure = Number(pvars.systolicBloodPressure);
			profile.SBPTreated.selected = pvars.SBPTreated.value;
						
			validate();
			
		}
		
		//
		// glean a variable list from the form data
		//
		private function setPersonalDetails():void {
			var pvars:VariableList = ps.variableList;
			var s:String = [profile.ddStep.value.toString(), profile.mmStep.value.toString(), profile.yyyyStep.value.toString()].join(":");
			//trace("profile: setting dob=", s);
			pvars.dateOfBirth.fromString(s);
			pvars.gender.fromString(profile.gender.selectedValue as String);
			
			// extra Q parameters
			pvars.ethnicGroup.value = profile.ethnicGroup.selectedIndex;
			pvars.height_m.value = profile.height_mStep.value;
			pvars.weight_kg.value = profile.weight_kgStep.value;
			pvars.townsendGroup.value = profile.townsendGroup.selectedIndex;
			pvars.relativeHadCVD.value = profile.fh.selected;
			pvars.chronicRenalDisease.value = profile.crd.selected;
			pvars.atrialFibrillation.value = profile.af.selected;
			pvars.rheumatoidArthritis.value = profile.ra.selected;
			pvars.smokerGroup.value = profile.smokerGroup.selectedIndex;
			
			pvars.diabetic.value = profile.diabetic.selected
			
			if(appState.mmol) {
				pvars.hdlCholesterol_mmol_L.value = profile.hdlCholesterolStep.value;
				pvars.totalCholesterol_mmol_L.value = profile.totalCholesterolStep.value;
			}
			else {
				pvars.hdlCholesterol_mmol_L.value = mg2mol(profile.hdlCholesterolStep_mgdl.value);
				pvars.totalCholesterol_mmol_L.value = mg2mol(profile.totalCholesterolStep_mgdl.value);				
			}
			
			
			pvars.systolicBloodPressure.value = profile.systolicBloodPressure;
			pvars.SBPTreated.value = profile.SBPTreated.selected;
			
			userProfile.isValid = false;
		}
		
		//
		//---- View click events ----
		// 		
		private function commitProfile():void {
			//# trace("commitProfile");

			// Set the user profile variableList BEFORE cloning it into the interventions profile
			setPersonalDetails();			
			inter.variableList = userProfile.variableList.clone();			
			//clearInterventionsSignal.dispatch();
			
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
		
		
		private function molChanged(event:Event = null):void {
			
			var total:Number = profile.totalCholesterolStep.value;
			var hdl:Number = profile.hdlCholesterolStep.value;
			
			cholesterolValidationOn = false;
			profile.totalCholesterolStep_mgdl.value = mol2mg(total);
			profile.hdlCholesterolStep_mgdl.value = mol2mg(hdl);
			cholesterolValidationOn = true;
			
			var nonHDL:Number = total - hdl;
			
			profile.nonHDLField.text = "NonHDL Cholesterol: " + nonHDL.toFixed(1);			
			profile.nonHDLField_mgdl.text = "NonHDL Cholesterol: " + mol2mg(nonHDL).toFixed(1);			
				
			validate();
		}
		
		private function mgChanged(event:Event = null):void {
			
			var total:Number = profile.totalCholesterolStep_mgdl.value;
			var hdl:Number = profile.hdlCholesterolStep_mgdl.value;
			
			cholesterolValidationOn = false;
			profile.totalCholesterolStep.value = mg2mol(total);
			profile.hdlCholesterolStep.value = mg2mol(hdl);
			cholesterolValidationOn = true;

			var nonHDL:Number = total - hdl;
			
			profile.nonHDLField.text = "NonHDL Cholesterol: " + mg2mol(nonHDL).toFixed(0);			
			profile.nonHDLField_mgdl.text = "NonHDL Cholesterol: " + nonHDL.toFixed(0);			
				
			validate();
		}
		
		
		private function validate(event:Event = null):void {
			
			profile.bmiField.text = "BMI: " + bmi_uncommitted.toPrecision(3);
			
			var e1:Boolean = (profile.hdlCholValidator.validate().results != null);
			var e2:Boolean = (profile.totalCholValidator.validate().results != null);
			var e3:Boolean = (profile.dateValidator.validate().results != null)
			var e4:Boolean = (profile.sbpValidator.validate().results != null);
			var e5:Boolean = (profile.heightValidator.validate().results != null);
			var e6:Boolean = (profile.weightValidator.validate().results != null);
			var e7:Boolean = (profile.hadCVDValidator.validate().results != null);
			var e8:Boolean = (profile.termsValidator.validate().results != null);

			if(e1 || e3 || e4 || e5 || e6 || e7 || e8) {
				isValid = false;
				profile.nextButton.enabled = false;
				profileValidSignal.dispatch(false);
			}
			else {
				isValid = true;
				
				// precalculate to ensure all tables are ready
				var params:QParametersVO = runModel.getQParameters(userProfile);
				var flashScore:FlashScore2011 = new FlashScore2011();
				var path:String = "Q65_derivation_cvd_time_40_"+userProfile.b_gender+ ".csv";
				flashScore.addEventListener(Event.COMPLETE, prefetchDone);

				//# trace("flashScore prefetch");
				flashScore.calculateScore(path, params);
			}
		}
		
		private function prefetchDone(event: Event):void {
			//# trace("prefetch done");
			
			profile.nextButton.enabled = true;
			profileValidSignal.dispatch(true);
		}
		
		private var isValid:Boolean = false;

		private function currentYear():int 
		{
			var d:Date = new Date();
			return d.fullYear;
		}
		
		/*
		 * Cholesterol Conversions
		 */
		public static var cholConversionFactor:Number = 38.7;
		
		private var mmol_L:String = "mmol/L";
		private var mg_dL:String = "mg/dL";
		
		public function get cholesterolUnit():String
		{
			if(profile.cholUnits.selectedIndex < 0) {
				profile.cholUnits.selectedIndex = 0;
			}
			return profile.cholUnits.selectedItem.unit;
		}
	
		public static function mg2mol(mg:Number):Number {
			return mg / cholConversionFactor;
		}
		
		public static function mol2mg(mol:Number):Number {
			return mol * cholConversionFactor;
		}
		
		/* OLD CODE IN COMMENTS */
		
		/*
		public function get totalCholesterol():Number
		{
		return profile.totalCholesterolStep.value;
		}
		public function set totalCholesterol(value:Number):void
		{
		profile.totalCholesterolStep.value = value;
		}
		
		public function get hdlCholesterol():Number
		{
		return profile.hdlCholesterolStep.value;
		}
		public function set hdlCholesterol(value:Number):void
		{
		profile.hdlCholesterolStep.value = value;
		}
		*/

		
		/*
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
		
		
		*/
		private var cholUnitFactors:ArrayCollection = new ArrayCollection([
			{unit:"mmol/L", factor: 1},
			{unit:"mg/dL", factor: 1 / cholConversionFactor},
		]);
		
		// Prevents a yukky screen flash by delaying the change on scrren
		public function finishUnitChange(event: TimerEvent):void {
			profile.mmol.visible = appState.mmol;
			profile.mgdl.visible = !appState.mmol;
		}
		
		
		private function changedUnits(event:Event):void
		{
			appState.mmol = (cholesterolUnit == mmol_L);

			if (appState.mmol) {
				profile.mmol.percentWidth = 100;
				profile.mgdl.width = 0;
				profile.mgdl.visible = false;
			}
			else {
				profile.mgdl.percentWidth = 100;
				profile.mmol.width = 0;
				profile.mmol.visible = false;
			}
			timer.reset();
			timer.start();
		}
		
		/* OLD CODE IN COMMENTS */
		

/*
			profile.totalCholesterolStep.visible = profile.hdlCholesterolStep.visible = appState.mmol;
			
			profile.totalCholesterolStep_mgdl.visible = profile.hdlCholesterolStep_mgdl.visible = !appState.mmol;
		
			// be careful to ensure stepper minimum < value < maximum at all times
			var f:Number;
			if(appState.mmol) {
				// valid range is 0.1..20
				f = 1/cholConversionFactor;
			}
			else {
				// valid range is 0.1..20*cholConversionFactor
				f = cholConversionFactor;
			}
			
			updateCholesterolStepper(profile.totalCholesterolStep, profile.totalCholValidator, f, "total");
			updateCholesterolStepper(profile.hdlCholesterolStep, profile.hdlCholValidator, f, "hdl");
			
			validate();
		}
		
		private function updateCholesterolStepper(stepper:NumericStepper, validator:Validator, f:Number, label:String):void {

			var newMin:Number = 0.000001;	
			var newMax:Number = stepper.maximum * f;
			var newVal:Number = stepper.value * f;
			
			stepper.maximum = Math.max(newMax, stepper.maximum);
			stepper.stepSize = 0.1;
			stepper.valueParseFunction = function(s:String):Number {
				return Math.round(Number(s)*100000)/100000;
			}
			stepper.valueFormatFunction = function(val:Number):String 
			{
				return val.toPrecision(2);
			};
			
			//stepper.validateNow();
			
			stepper.value = newVal;

			if(f > 1) {
				stepper.stepSize = 1;
				newMin = 1;
				stepper.value = Math.round(newVal);
				stepper.valueParseFunction = function(s:String):Number {
					return parseInt(s);
				}
				stepper.valueFormatFunction = function(val:Number):String 
				{
					return val.toPrecision(2);
				};
			}
			//stepper.validateNow();

			stepper.minimum = newMin;
			stepper.maximum = newMax;
//			validator.maxValue = newMax;

			// trace("stepper.value="+stepper.value);
			
			stepper.validateNow();

		}
*/		
		
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
		//public var bmi:Number = 1;
		
		
		private var feet:Number = 5;
		
		public var inches:Number = 10;
		public var stones:Number = 10;
		public var pounds:Number = 0;
		public var lbs:Number = 150;
				
		public function get bmi():Number
		{
			var pvars:VariableList = ps.variableList;
			var m:Number = Number(pvars.height_m);
			var kg:Number = Number(pvars.weight_kg);
			return kg/(m*m);
		}
		
		public function get bmi_uncommitted():Number
		{
			var m:Number = Number(profile.height_mStep.value);
			var kg:Number = Number(profile.weight_kgStep.value);
			return kg/(m*m);
		}
		
		private function showTownsendImage(event:Event):void {
			var band:int = 5-profile.townsendGroup.selectedIndex;
			profile.townsendBand.source = "assets/townsend/band"+band+".jpg";
		}
	}
}