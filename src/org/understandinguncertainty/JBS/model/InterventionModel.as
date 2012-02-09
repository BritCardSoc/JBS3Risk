/*
This file forms part of the JBS3Risk Cardiovascular Assessment Tool.
It is ©2012 University of Cambridge.
It is released under version 3 of the GNU General Public License
Source code, including a copy of the license is available at https://github.com/BritCardSoc/JBS3Risk
*/
package org.understandinguncertainty.JBS.model
{

	/**
	 * Class which models interventions
	 */
	public class InterventionModel
	{
		public function cholesterolIntervention(a:Number, difference:Number, difference_int:Number):Number
		{
			// Cholesterol adjustment
			return a + (difference - difference_int)*Math.log(0.78);
		}
		
		public function sbpIntervention(a:Number, sbp:Number, sbp_int:Number):Number
		{
			// Blood Pressure adjustment
			return a + (sbp - sbp_int)*Math.log(0.966);
		}
		
		public function smokingIntervention(a:Number, LHR:Number, LHR_int:Number):Number
		{
			// smoking adjustment
			return a + LHR - LHR_int;
		}
	}
}