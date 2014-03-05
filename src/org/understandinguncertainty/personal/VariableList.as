/*
This file forms part of the JBS3Risk Cardiovascular Assessment Tool.
It is ©2012 University of Cambridge.
It is released under version 3 of the GNU General Public License
Source code, including a copy of the license is available at https://github.com/BritCardSoc/JBS3Risk
*/
package org.understandinguncertainty.personal
{
	import flash.utils.describeType;
	
	import org.understandinguncertainty.personal.interfaces.IPersonalVariable;
	import org.understandinguncertainty.personal.types.AgePersonalVariable;
	import org.understandinguncertainty.personal.types.BooleanPersonalVariable;
	import org.understandinguncertainty.personal.types.NumberPersonalVariable;
	import org.understandinguncertainty.personal.types.StringPersonalVariable;
	import org.understandinguncertainty.personal.variables.*;
	
	/**
	 * The VariableList defines all variables that we might be interested in. You should never
	 * delete a variable from this list even if you don't need it since other animations or plugins
	 * may require it, and it is ONLY variables in this list that are ever saved to personal files.
	 *   
	 * @author gmp26
	 * 
	 */
	public class VariableList {
		
		public var age:AgePersonalVariable = new AgePersonalVariable("age", 0);
		public var active:BooleanPersonalVariable = new BooleanPersonalVariable("active", true);
		public var fiveaday:BooleanPersonalVariable = new BooleanPersonalVariable("fiveaday", true);
		public var gender:StringPersonalVariable = new StringPersonalVariable("gender", "male");
		public var moderateAlcohol:BooleanPersonalVariable = new BooleanPersonalVariable("moderateAlcohol", true);
		public var smokerGroup:NumberPersonalVariable = new NumberPersonalVariable("smokerGroup", true);
		public var nonSmoker:BooleanPersonalVariable = new BooleanPersonalVariable("nonSmoker", true);
		public var quitSmoker:BooleanPersonalVariable = new BooleanPersonalVariable("quitSmoker", false);
		
		public var dateOfBirth:DateOfBirth; // = new DateOfBirth("dateOfBirth", new Date((new Date()).time - 40*365.25*24*60*60000));

		public var totalCholesterol_mmol_L:NumberPersonalVariable = new NumberPersonalVariable("totalCholesterol_mmol_L", 5.5);
		public var hdlCholesterol_mmol_L:NumberPersonalVariable = new NumberPersonalVariable("hdlCholesterol_mmol_L", 1.16);
		public var systolicBloodPressure:NumberPersonalVariable = new NumberPersonalVariable("systolicBloodPressure", 130);
		
		
		public var height_m:NumberPersonalVariable = new NumberPersonalVariable("height_m", 1.7);
		public var weight_kg:NumberPersonalVariable = new NumberPersonalVariable("weight_kg", 65);
		public var SBPTreated:BooleanPersonalVariable = new BooleanPersonalVariable("SBPTreated", false);
		public var diabetic:BooleanPersonalVariable = new BooleanPersonalVariable("diabetic", false);
		
		public var chronicRenalDisease:BooleanPersonalVariable = new BooleanPersonalVariable("chronicRenalDisease", false);
		public var atrialFibrillation:BooleanPersonalVariable = new BooleanPersonalVariable("atrialFibrillation", false);
		public var rheumatoidArthritis:BooleanPersonalVariable = new BooleanPersonalVariable("rheumatoidArthritis", false);
		public var relativeHadCVD:BooleanPersonalVariable = new BooleanPersonalVariable("relativeHadCVD", false);
		public var ethnicGroup:NumberPersonalVariable = new NumberPersonalVariable("ethnicGroup", 0);
		public var postCode:StringPersonalVariable = new StringPersonalVariable("postCode", "");
		
		public var townsend:NumberPersonalVariable = new NumberPersonalVariable("townsend", 0);
		public var townsendGroup:NumberPersonalVariable = new NumberPersonalVariable("townsendGroup", 2);
		
				
		function VariableList() {
			
			// set default age to 40 
			var today:Date = new Date();
			var fortyYearsAgo:Date = today;
			fortyYearsAgo.fullYear -= 40;
			dateOfBirth = new DateOfBirth("dateOfBirth", fortyYearsAgo);
			
			// inject dependencies that may exist between different variables
//			yearOfBirth.dateOfBirth = dateOfBirth;
//			dateOfBirth.yearOfBirth = yearOfBirth;
//			age.yearOfBirth = yearOfBirth;
			age.dateOfBirth = dateOfBirth;
		}

		public function toString():String
		{
			var s:String = "age:" + (age.value as int);
			s += " sex:" + (gender.value as String);
			s += " tc:" + (totalCholesterol_mmol_L.value as Number);
			s += " hdl:" + (hdlCholesterol_mmol_L.value as Number);
			s += " sbp:" + (systolicBloodPressure.value as Number) + "\n";
			s += " sbpt:" + (SBPTreated.value as Boolean);
			s += " diab:" + (diabetic.value as Boolean);
			s += " smok:" + !(nonSmoker.value as Boolean);
			s += " qsmk:" + (quitSmoker.value as Boolean);
			s += " actv:" + (active.value as Boolean);
			return s;
		}
		
		
		public function getVariable(name:String):IPersonalVariable {
			return this[name] as IPersonalVariable;
		}
		
		/* Some derived variables */
		public function get cholRatio():Number
		{
			var t:Number = Number(totalCholesterol_mmol_L.value);
			var h:Number = Number(hdlCholesterol_mmol_L.value);
			return t/h;
		}
		
		// WARNING: only use this for interventions - it should not persist
		public function set cholRatio(ratio:Number):void
		{
			totalCholesterol_mmol_L.value = ratio*Number(hdlCholesterol_mmol_L.value);
		}
		
		public function get bmi():Number
		{
			var w:Number = Number(weight_kg.value);
			var h:Number = Number(height_m.value);
			//trace("bmi ="+(w/(h*h)), " w =", w, " h =", h);
			return w/(h*h);
		}

		public function get feet():Number
		{
			return Math.floor(Number(height_m.value) * 3.2808399 + 1/24);
		}
		
		public function get inches():Number
		{
			return Math.round((Number(height_m.value) * 3.2808399 + 1/24 - feet)*12);
		}
		
		public function get stones():Number
		{
			return Math.floor(Number(weight_kg.value) * 0.157473044 + 1/28);			
		}
		
		public function get pounds():Number
		{
			return Math.round((Number(weight_kg.value) * 0.157473044 + 1/28 - stones)*14);						
		}
		
		public function get lbs():Number
		{
			return Math.round(Number(weight_kg.value) * 2.20462262);
		}

		
		/**
		 * If this works well, use it in lieu of clone() so we don't get clone errors when we add or delete variables.
		 * 
		 * @return a clone of the VariableList using introspection
		 * 
		 */
		public function clone():VariableList {
			var copy:VariableList = new VariableList();
			var vList:XMLList = describeType(this).variable;
			var len:int = vList.length();
			for(var i:int = 0; i < len; i++) {
				var name:String = vList[i].@name;
				var fromVar:IPersonalVariable = this[name] as IPersonalVariable;
				var toVar:IPersonalVariable = copy[name] as IPersonalVariable;
				toVar.value = fromVar.value;
			}
			return copy;
		}
		
		public function equals(other:VariableList):Boolean {
			var vList:XMLList = describeType(this).variable;
			var len:int = vList.length();
			for(var i:int = 0; i < len; i++) {
				var name:String = vList[i].@name;
				var fromVar:IPersonalVariable = this[name] as IPersonalVariable;
				var toVar:IPersonalVariable = other[name] as IPersonalVariable;
				if(toVar.value != fromVar.value)
					return false;
			}
			return true;
		}
		
		/**
		 * <p>Write the variable list serialised into XML</p> 
		 * @return the XML
		 * 
		 */
		public function writeXML():XML {
			var written:XML = <personalData/>;
			var vList:XMLList = describeType(this).variable;
			for(var i:int = 0; i < vList.length(); i++) {
				var name:String = vList[i].@name;
				var pv:IPersonalVariable = this[name] as IPersonalVariable;
				if(pv == null || pv.value == null) continue;
				var stringValue:String = pv.toString();
				if(stringValue==null) continue;
				var xml:XML = <{name}>{stringValue}</{name}>;
				written.appendChild(xml);
			}
			return written;
		}
		
		/**
		 * Read XML into the variable list 
		 * @param xml the XML to read
		 * 
		 */
		public function readXML(xml:XML):void {
			
			var vList:XMLList = describeType(this).variable;
			for(var i:int = 0; i < vList.length(); i++) {
				var name:String = vList[i].@name;
				var nameValue:XMLList = xml.child(name);
				var pv:IPersonalVariable = this[name] as IPersonalVariable;
				if(pv == null)
					throw new Error("Check " + name, "Unknown Personalisation Variable");
				if(nameValue != null && nameValue.length() == 1)
					pv.fromString(nameValue.toString());
			}
			
		}

	}
}