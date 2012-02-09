/*
This file forms part of the JBS3Risk Cardiovascular Assessment Tool.
It is ©2012 University of Cambridge.
It is released under version 3 of the GNU General Public License
Source code, including a copy of the license is available at https://github.com/BritCardSoc/JBS3Risk
*/
package org.understandinguncertainty.JBS.controller
{
	import org.understandinguncertainty.JBS.model.UserModel;
	import org.understandinguncertainty.JBS.signals.ClearInterventionsSignal;

	public class SetupInterventionProfile
	{

		[Inject(name="userProfile")]
		public var user:UserModel;
	
		[Inject(name="interventionProfile")]
		public var inter:UserModel;
		
		[Inject]
		public var clearInterventionsSignal:ClearInterventionsSignal;
		
		/**
		 * Reset the interventions model to be the same as the user model.
		 * Then update the interventions panel?
		 */
		public function execute():void
		{
			//trace("Moved from Profile Screen");
			inter.variableList = user.variableList.clone();
			
			clearInterventionsSignal.dispatch();
		}
	}
}