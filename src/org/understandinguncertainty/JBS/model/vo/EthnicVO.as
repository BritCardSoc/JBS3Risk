/*
This file forms part of the JBS3Risk Cardiovascular Assessment Tool.
It is ©2012 University of Cambridge.
It is released under version 3 of the GNU General Public License
Source code, including a copy of the license is available at https://github.com/BritCardSoc/JBS3Risk
*/
package org.understandinguncertainty.JBS.model.vo
{
	public class EthnicVO
	{		
		//See qrsk2 CVD Search Def Table2
		public var nhsCode:int; 
		public var nhsGroup: String;
		
		static public const NOT_RECORDED:String = "Not recorded";
		static public const WHITE:String = "White";
		static public const INDIAN:String = "Indian";
		static public const PAKISTANI:String = "Pakistani";
		static public const BANGLADESHI:String = "Bangladeshi";
		static public const OTHER_ASIAN:String = "Other Asian";
		static public const BLACK_CARIBBEAN:String = "Black Caribbean";
		static public const BLACK_AFRICAN:String = "Black African";
		static public const CHINESE:String = "Chinese";
		static public const OTHER_ETHNIC_GROUP:String = "Other ethnic group";
		
		public function EthnicVO(nhsCode:int, nhsGroup:String)
		{
			this.nhsCode = nhsCode;
			this.nhsGroup = nhsGroup;
		}
		
		private var transform3:Array = [
			1,1,1,1,
			9,9,9,9,
			2,3,4,5,6,7,
			9,8,9,1
		];
		
		public function get epsilon():int {
			return transform3[nhsCode];
		}
		
		
		private var epsilonGenderMap:Array = [
			[0,				0],
			[0,				0],
			[0.35824692,	0.37126994],
			[0.59029885,	0.68049689],
			[0.29907399,	0.51493365],
			[0.13956593,	0.31605348	
		];
		
		
		public function getE(gender:String) {
			
		}
	}
}