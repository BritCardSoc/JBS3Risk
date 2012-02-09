/*
This file forms part of the JBS3Risk Cardiovascular Assessment Tool.
It is ©2012 University of Cambridge.
It is released under version 3 of the GNU General Public License
Source code, including a copy of the license is available at https://github.com/BritCardSoc/JBS3Risk

NB This file is not compiled into the current swf

*/
package org.understandinguncertainty.JBS.framingham.model
{
	import org.understandinguncertainty.JBS.model.vo.BetasVO;

	public class FemaleParameters implements FraminghamParameters
	{

		private var _beta:BetasVO;
		public function get beta():BetasVO {return _beta};

		private var _xbar:BetasVO;
		public function get xbar():BetasVO {return _xbar};

		private var _q:BetasVO;
		
		/** @inheritDoc */
		public function get q():BetasVO {return _q};

		function FemaleParameters()
		{
			_beta = new BetasVO();
			_beta.age 						= 2.32888;
			_beta.totalCholesterol_mmol_L 	= 1.20904;
			_beta.hdlCholesterol_mmol_L 	= -0.70833;
			_beta.systolicBloodPressure		= 2.76157;	
			_beta.SBPTreated				= 2.82263;
			_beta.smoker					= 0.52873;
			_beta.diabetic					= 0.69154;

			_xbar = new BetasVO();
			_xbar.age						= 3.8686;
			_xbar.totalCholesterol_mmol_L	= 5.3504;
			_xbar.hdlCholesterol_mmol_L		= 4.0176;
			_xbar.systolicBloodPressure		= 4.24;		
			_xbar.SBPTreated				= 0.5826;
			_xbar.smoker					= 0.3423;
			_xbar.diabetic					= 0.0376;

			_q = new BetasVO();
			_q.age = 1;
			_q.totalCholesterol_mmol_L = 1;
			_q.hdlCholesterol_mmol_L = 1;
			_q.systolicBloodPressure = 1;
			_q.smoker = 1;
			_q.diabetic = 1;
		}
		
		public function get averageHazard():Number {return 26.1931};

		// Calculated using model_notes_ds.pdf
		public function get a():Number {return 0.004188793};
		
		// Original usng only 'Spec for analysis of Cardio program.doc' estimate
		//public function get a():Number {return 0.00375};

		/* From UK interim life tables England & Wales 2006-8 adjusted by the factor 
		non-circulatory deaths/all deaths for each age taken from
		data/Table5.9-1.xls. 
		
		See calculation in data/nonCVb2008.xls
		*/
		
		public function get b():Array {return [
			0.004358,
			0.000337,
			0.000193,
			0.000156,
			0.000118,
			0.000095,
			0.000093,
			0.000074,
			0.000084,
			0.000072,
			0.000086,
			0.000089,
			0.000096,
			0.000111,
			0.000109,
			0.000143,
			0.000166,
			0.000225,
			0.000249,
			0.000244,
			0.000222,
			0.000244,
			0.000235,
			0.000230,
			0.000266,
			0.000261,
			0.000319,
			0.000280,
			0.000333,
			0.000358,
			0.000369,
			0.000362,
			0.000425,
			0.000491,
			0.000522,
			0.000527,
			0.000540,
			0.000634,
			0.000697,
			0.000786,
			0.000842,
			0.000901,
			0.000980,
			0.001099,
			0.001169,
			0.001312,
			0.001387,
			0.001542,
			0.001779,
			0.001810,
			0.002154,
			0.002259,
			0.002399,
			0.002655,
			0.002982,
			0.003182,
			0.003458,
			0.003661,
			0.003950,
			0.004456,
			0.004643,
			0.005309,
			0.005610,
			0.006322,
			0.006940,
			0.007145,
			0.007860,
			0.008787,
			0.009656,
			0.010564,
			0.011124,
			0.012149,
			0.013556,
			0.015387,
			0.017252,
			0.017856,
			0.020226,
			0.022683,
			0.025539,
			0.029129,
			0.030711,
			0.034576,
			0.038448,
			0.043554,
			0.049092,
			0.052298,
			0.058154,
			0.063427,
			0.071573,
			0.078025,
			0.090130,
			0.103673,
			0.115312,
			0.127253,
			0.139091,
			0.163045,
			0.176687,
			0.187444,
			0.206861,
			0.218028,
			0.235104
		]};
	
		/* Original values
		
		From UK interim life tables England & Wales 2006-8 adjusted by the factor 
		non-circulatory deaths/all deaths for each age taken from
		data/Table_2_Death_Registrations_Cause.xls. 
		
		See calculation in data/nonCVb2006-8.xls
		
		public function get b():Array {return [
			0.004330,
			0.000323,
			0.000185,
			0.000149,
			0.000113,
			0.000092,
			0.000091,
			0.000072,
			0.000082,
			0.000070,
			0.000084,
			0.000087,
			0.000094,
			0.000109,
			0.000107,
			0.000137,
			0.000158,
			0.000215,
			0.000238,
			0.000233,
			0.000219,
			0.000240,
			0.000232,
			0.000226,
			0.000262,
			0.000247,
			0.000302,
			0.000265,
			0.000316,
			0.000339,
			0.000359,
			0.000352,
			0.000413,
			0.000477,
			0.000507,
			0.000504,
			0.000516,
			0.000606,
			0.000666,
			0.000751,
			0.000826,
			0.000884,
			0.000962,
			0.001079,
			0.001147,
			0.001261,
			0.001333,
			0.001483,
			0.001710,
			0.001740,
			0.002099,
			0.002201,
			0.002338,
			0.002587,
			0.002906,
			0.003042,
			0.003306,
			0.003500,
			0.003777,
			0.004260,
			0.004561,
			0.005214,
			0.005510,
			0.006210,
			0.006816,
			0.006629,
			0.007293,
			0.008153,
			0.008959,
			0.009801,
			0.011003,
			0.012018,
			0.013409,
			0.015220,
			0.017066,
			0.016360,
			0.018531,
			0.020783,
			0.023399,
			0.026688,
			0.029890,
			0.033652,
			0.037421,
			0.042390,
			0.047780,
			0.050553,
			0.056214,
			0.061310,
			0.069185,
			0.075421,
			0.085525,
			0.098376,
			0.109420,
			0.120752,
			0.131984,
			0.144201,
			0.156267,
			0.165781,
			0.182954,
			0.192830,
			0.207932 
		]};
		
*/
	}
}
