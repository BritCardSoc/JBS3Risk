/*
This file forms part of the JBS3Risk Cardiovascular Assessment Tool.
It is ©2012 University of Cambridge.
It is released under version 3 of the GNU General Public License
Source code, including a copy of the license is available at https://github.com/BritCardSoc/JBS3Risk
*/
package org.understandinguncertainty.JBS.validators
{
	import mx.validators.ValidationResult;
	import mx.validators.Validator;
	
	public class CholRatioValidator extends Validator
	{
		public function CholRatioValidator()
		{
			super();
		}
		
		override protected function doValidation(value:Object) : Array
		{
			var results:Array = super.doValidation(value);
			
			if (results.length > 0)
				return results;
			
			var ratio:Number = Number(value);
			if(ratio < 1) {
				results.push(new ValidationResult(
					true, "", "OutOfRange", 
					"Cholesterol ratio too small")
					);
			}
			else if(ratio > 12) {
				results.push(new ValidationResult(
					true, "", "OutOfRange", 
					"Cholesterol ratio too big")
					);
			}

			return results;
		}
	}
}