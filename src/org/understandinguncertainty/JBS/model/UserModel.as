/*
This file forms part of the JBS3Risk Cardiovascular Assessment Tool.
It is ©2012 University of Cambridge.
It is released under version 3 of the GNU General Public License
Source code, including a copy of the license is available at https://github.com/BritCardSoc/JBS3Risk
*/
package org.understandinguncertainty.JBS.model
{
	import org.understandinguncertainty.personal.PersonalisationFileStore;
	import org.understandinguncertainty.personal.VariableList;
	
	public class UserModel 
	{
		public var variableList:VariableList;
		public var personalData:PersonalisationFileStore;
		
		[Bindable]
		public var isValid:Boolean = true;

		public function UserModel()
		{
			variableList = new VariableList();
			personalData = new PersonalisationFileStore(variableList);

			super();
		}
		
		public function get gender():String
		{
			return variableList.gender.toString();
		}
		
		public function get age():int 
		{
			var dob:int = variableList.dateOfBirth.getAge();
			if(dob == 0 || isNaN(dob))
				trace("weird age seen:", dob);
			
			return dob;
		}
		
		public function get b_gender():int
		{
			return variableList.gender.toString() == "male" ? 1 : 0;
		}
		
		public function get b_AF():int
		{
			return boolInt(variableList.atrialFibrillation.value);
		}
		
		public function get b_ra():int
		{
			return boolInt(variableList.rheumatoidArthritis.value);	
		}
		
		public function get b_renal():int
		{
			return boolInt(variableList.chronicRenalDisease.value);
		}

		public function get b_treatedhyp():int
		{
			return boolInt(variableList.SBPTreated.value);
		}
		
		public function get b_type2():int
		{
			return boolInt(variableList.diabetic.value);
		}
		
		public function get bmi():Number
		{
			return variableList.bmi;
		}
		
		public function get ethRisk():int
		{
			return Number(variableList.ethnicGroup.value) + 1;
		}
		
		public function get fh_cvd():int
		{
			return boolInt(variableList.relativeHadCVD.value);	
		}

		public function get rati():Number
		{
			var total:Number = Number(variableList.totalCholesterol_mmol_L.value);
			var hdl:Number = Number(variableList.hdlCholesterol_mmol_L.value);
			return total/hdl;
		}
		
		public function get sbp():Number
		{
			return Number(variableList.systolicBloodPressure.value);	
		}
		
		public function get smoke_cat():int
		{
			return Number(variableList.smokerGroup.value);
		}

		public function get totalCholesterol():Number
		{
			return Number(variableList.totalCholesterol_mmol_L.value);	
		}

		public function get hdlCholesterol():Number
		{
			return Number(variableList.hdlCholesterol_mmol_L.value);	
		}
		
		public function boolInt(b:Boolean):int
		{
			return b ? 1 : 0;
		}
		
	}
}