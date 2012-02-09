/*
This file forms part of the JBS3Risk Cardiovascular Assessment Tool.
It is ©2012 University of Cambridge.
It is released under version 3 of the GNU General Public License
Source code, including a copy of the license is available at https://github.com/BritCardSoc/JBS3Risk
*/
package org.understandinguncertainty.JBS.model.vo
{
	public class BetasVO
	{
		// framingham
		public var age:Number;
		public var totalCholesterol_mmol_L:Number;
		public var hdlCholesterol_mmol_L:Number;
		public var systolicBloodPressure:Number;		
		public var SBPTreated:Number;
		public var smoker:Number;
		public var diabetic:Number;
		
		// qrsk betas
		public var age_1:Number;
		public var age_2:Number;
		public var bmi_1:Number;
		public var rati:Number;
		public var sbp:Number;
		public var town:Number;
		public var b_AF:Number;
		public var b_ra:Number;
		public var b_renal:Number;
		public var b_treatedhyp:Number;
		public var b_type2:Number;
		public var fh_cvd:Number;
		public var smok:Number;

	}
}