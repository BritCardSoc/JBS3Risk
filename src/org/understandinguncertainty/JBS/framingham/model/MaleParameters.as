/*
This file forms part of the JBS3Risk Cardiovascular Assessment Tool.
It is ©2012 University of Cambridge.
It is released under version 3 of the GNU General Public License
Source code, including a copy of the license is available at https://github.com/BritCardSoc/JBS3Risk

NB This file is not compiled into the current swf

*/
/** @inheritDoc */
package org.understandinguncertainty.JBS.framingham.model
{
	import org.understandinguncertainty.JBS.model.vo.BetasVO;

	public class MaleParameters implements FraminghamParameters
	{
		
		private var _beta:BetasVO;
		/** @inheritDoc */
		public function get beta():BetasVO {return _beta};
		
		private var _xbar:BetasVO;
		/** @inheritDoc */
		public function get xbar():BetasVO {return _xbar};

		private var _q:BetasVO;
		
		/** @inheritDoc */
		public function get q():BetasVO {return _q};
		
		/**
		 * Constructor 
		 */
		function MaleParameters()
		{
			_beta = new BetasVO();
			_beta.age 						= 3.06117;
			_beta.totalCholesterol_mmol_L 	= 1.1237;
			_beta.hdlCholesterol_mmol_L 	= -0.93263;
			_beta.systolicBloodPressure		= 1.93303;	
			_beta.SBPTreated				= 1.99881;
			_beta.smoker					= 0.65451;
			_beta.diabetic					= 0.57367;
			
			_xbar = new BetasVO();
			_xbar.age						= 3.856;
			_xbar.totalCholesterol_mmol_L	= 5.342;
			_xbar.hdlCholesterol_mmol_L		= 3.7686;
			_xbar.systolicBloodPressure		= 4.3544;		
			_xbar.SBPTreated				= 0.5019;
			_xbar.smoker					= 0.3522;
			_xbar.diabetic					= 0.0065;
			
			_q = new BetasVO();
			_q.age = 1;
			_q.totalCholesterol_mmol_L = 1;
			_q.hdlCholesterol_mmol_L = 1;
			_q.systolicBloodPressure = 1;
			_q.smoker = 1;
			_q.diabetic = 1;
		}
		
		public function get averageHazard():Number {return 23.9466034} // framingham miscalculates this as 23.9802

		// Calculates using model_notes_ds.pdf
		public function get a():Number {return 0.009026653};
		
		// Original usng only 'Spec for analysis of Cardio program.doc' estimate
		//public function get a():Number {return 0.008745};
		
		/* From UK interim life tables England & Wales 2006-8 adjusted by the factor 
		non-circulatory deaths/all deaths for each age taken from
		data/Table_5.9-1.xls
		
		See calculation in data/nonCVb2008.xls
		*/
		public function get b():Array {return [
		0.005326,
		0.000388,
		0.000228,
		0.000163,
		0.000134,
		0.000129,
		0.000103,
		0.000097,
		0.000123,
		0.000117,
		0.000096,
		0.000108,
		0.000110,
		0.000149,
		0.000166,
		0.000222,
		0.000324,
		0.000474,
		0.000526,
		0.000573,
		0.000642,
		0.000607,
		0.000643,
		0.000644,
		0.000657,
		0.000660,
		0.000709,
		0.000727,
		0.000751,
		0.000771,
		0.000816,
		0.000863,
		0.000930,
		0.000974,
		0.001022,
		0.001056,
		0.001051,
		0.001083,
		0.001184,
		0.001234,
		0.001250,
		0.001358,
		0.001476,
		0.001564,
		0.001678,
		0.001722,
		0.001853,
		0.002054,
		0.002201,
		0.002432,
		0.002587,
		0.002867,
		0.003073,
		0.003501,
		0.003795,
		0.004248,
		0.004630,
		0.004909,
		0.005340,
		0.005758,
		0.006182,
		0.007012,
		0.007850,
		0.008647,
		0.009499,
		0.010365,
		0.011306,
		0.012298,
		0.013767,
		0.014920,
		0.015737,
		0.017486,
		0.019524,
		0.021525,
		0.023703,
		0.025926,
		0.028938,
		0.032101,
		0.035580,
		0.040150,
		0.043028,
		0.047964,
		0.053689,
		0.059210,
		0.065975,
		0.070936,
		0.078693,
		0.081186,
		0.088856,
		0.096176,
		0.110717,
		0.124613,
		0.134759,
		0.146285,
		0.154983,
		0.181383,
		0.196132,
		0.214201,
		0.221136,
		0.231504,
		0.253204
		]};
/* Old Values
		
		/* From UK interim life tables England & Wales 2006-8 adjusted by the factor 
		non-circulatory deaths/all deaths for each age taken from
		data/Table_2_Death_Registrations_Cause.xls. 
		
		See calculation in data/nonCVb2006-8.xls
		
		public function get b():Array {return [
			0.005293,
			0.000381,
			0.000224,
			0.000161,
			0.000132,
			0.000124,
			0.000099,
			0.000094,
			0.000118,
			0.000112,
			0.000095,
			0.000108,
			0.000109,
			0.000149,
			0.000166,
			0.000220,
			0.000321,
			0.000468,
			0.000520,
			0.000566,
			0.000628,
			0.000594,
			0.000629,
			0.000630,
			0.000643,
			0.000629,
			0.000676,
			0.000693,
			0.000715,
			0.000735,
			0.000796,
			0.000841,
			0.000907,
			0.000950,
			0.000996,
			0.000984,
			0.000979,
			0.001008,
			0.001103,
			0.001149,
			0.001227,
			0.001334,
			0.001450,
			0.001536,
			0.001647,
			0.001614,
			0.001737,
			0.001925,
			0.002063,
			0.002279,
			0.002512,
			0.002783,
			0.002983,
			0.003399,
			0.003684,
			0.004053,
			0.004417,
			0.004684,
			0.005095,
			0.005493,
			0.005996,
			0.006801,
			0.007615,
			0.008387,
			0.009213,
			0.009862,
			0.010758,
			0.011701,
			0.013100,
			0.014197,
			0.015395,
			0.017106,
			0.019100,
			0.021057,
			0.023188,
			0.024588,
			0.027445,
			0.030445,
			0.033744,
			0.038078,
			0.041925,
			0.046734,
			0.052313,
			0.057692,
			0.064284,
			0.068846,
			0.076375,
			0.078794,
			0.086239,
			0.093342,
			0.105776,
			0.119051,
			0.128744,
			0.139756,
			0.148066,
			0.164212,
			0.177565,
			0.193924,
			0.200202,
			0.209589,
			0.229235 
		]};
*/
	}
}
