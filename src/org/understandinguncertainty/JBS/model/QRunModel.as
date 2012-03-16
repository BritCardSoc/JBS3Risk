/*
This file forms part of the JBS3Risk Cardiovascular Assessment Tool.
It is ©2012 University of Cambridge.
It is released under version 3 of the GNU General Public License
Source code, including a copy of the license is available at https://github.com/BritCardSoc/JBS3Risk
*/
package org.understandinguncertainty.JBS.model
{
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;
	import mx.resources.IResourceManager;
	
	import org.understandinguncertainty.JBS.model.vo.CalculatedParams;
	import org.understandinguncertainty.JBS.model.vo.ColourNumbersVO;
	import org.understandinguncertainty.JBS.signals.ModelUpdatedSignal;
	import org.understandinguncertainty.JBS.signals.UpdateModelSignal;
	import org.understandinguncertainty.QRLifetime.FlashScore2011;
	import org.understandinguncertainty.QRLifetime.LifetimeRiskTable;
	import org.understandinguncertainty.QRLifetime.vo.LifetimeRiskRow;
	import org.understandinguncertainty.QRLifetime.vo.QParametersVO;
	import org.understandinguncertainty.QRLifetime.vo.QResultVO;
	import org.understandinguncertainty.personal.VariableList;
	import org.understandinguncertainty.personal.types.BooleanPersonalVariable;

	[ResourceBundle("JBS")]
	public class QRunModel extends AbstractRunModel implements ICardioModel
	{	
		private var _showDifferences:Boolean = false;
		
		/**
		 * @param b sets whether to show differences in the UI
		 */
		public function set showDifferences(b:Boolean):void {
			this._showDifferences = b;
		}
		
		/**
		 * @returns whether to show differences in the UI
		 */
		public function get showDifferences():Boolean {
			return _showDifferences;
		}
		
		private function getQParameters(profile:UserModel, checkRange:Boolean = true):QParametersVO
		{
			return new QParametersVO(
				profile.b_gender,
				profile.b_AF, 
				profile.b_ra, 
				profile.b_renal, 
				profile.b_treatedhyp, 
				profile.b_type2, 
				profile.bmi, 
				profile.ethRisk, 
				profile.fh_cvd, 
				profile.rati, 
				profile.sbp, 
				profile.smoke_cat, 
				getTownsendScore(profile), 
				profile.age, 
				0,
				checkRange
			); // noOfFollowUpYears
		}
		
		//
		// baseline parameters used in calculation of Heart age and in Compare screen
		//
		private function getBaselineParameters(profile:UserModel):QParametersVO
		{
			var gender:String = profile.b_gender.toString();
			
			return new QParametersVO(
				profile.b_gender, 				// same gender
				0,0,0,0,0,			  			// zero boolean risk factors
				centerings[gender].bmi,			// centred bmi	
				profile.ethRisk,  				// same ethnic group 
				0,					  			// zero boolean risk factors
				centerings[gender].rati,		// centred chol ratio
				centerings[gender].sbp,			// centred sbp
				0,					  			// non-smoker	
				centerings[gender].town,		// central Townsend score
				profile.age, 	  				// same age
				0);
		}
		
		
		private function getTownsendScore(profile:UserModel):Number
		{
			var variables:VariableList = profile.variableList;
			var quintiles: Array = townsendQuintiles[variables.gender.toString()];
			return quintiles[Number(variables.townsendGroup.value)];
		}
		
		private var results:Array;
		private var flashScore:FlashScore2011;
		private var flashScore_int:FlashScore2011;
		private var flashScore_gp:FlashScore2011;
		private var path:String;
		private var params:QParametersVO;
		private var params_int:QParametersVO;
		private var params_gp:QParametersVO;
		
		//
		// centerings - identical values for cvd and death... 
		//			  - comments are from qrsk lifetime source code
		//
		private var centerings:Object = {
			male: {
				//a += (Math.log(p.bmi/10) - 0.967572152614594) * 0.4325953310683352500000000;
				bmi: 10*Math.exp(0.967572152614594),
				
				//a += (p.rati - 4.439734935760498) * 0.1616093175199347100000000;
				rati: 4.439734935760498,
				
				//a += (p.sbp - 133.265686035156250) * 0.0051706475575211365000000;
				sbp: 133.265686035156250,
				
				//a += (p.town + 0.164980158209801) * 0.0118372789415412600000000;
				town: -0.164980158209801
				
			},
			female: {
				//a += (Math.sqrt(p.bmi/10) - 1.605074524879456) * 0.2813726290228962300000000;
				//a += (Math.sqrt(p.bmi/10) - 1.605074524879456) * -0.1081416642130314200000000;
				bmi: 10*1.605074524879456*1.605074524879456,
					
				//a += (p.rati - 3.705839872360230) * 0.0273178320909109660000000;
				rati: 3.705839872360230,
				
				//a += (p.sbp - 129.823593139648440) * -0.0008337937584279265700000;
				sbp: 129.823593139648440,
				
				//a += (p.town + 0.301369071006775) * 0.0366304184773099120000000;
				town: -0.301369071006775	
					
			}
		};
					
		
		private var townsendQuintiles:Object = {
			male: [-3.95, -2.57, -0.81, 1.66, 5.34],
			female: [-3.95, -2.57, -0.81, 1.66, 5.34]
		}
			
		private var committing:Boolean = false;
		
		
		public function commitProperties():void {

			if(committing) {
				return;
			}
			
			if(userProfile.age == 0)
				return;
			
			appState.minimumAge = userProfile.age;

			sum_e = 0;
			sum_e_int = 0;
			results = [];
			_peakf = 0;
			
			// Push current age onto output array immediately
			results.push({
				age:		userProfile.age,
				green:		100,
				yellow:		100,
				red:		100,					
				
				redNeg:	    0,
				yellowNeg: 	0,
				blueNeg:	0,

				yellowOnly:	100,
				redOnly:	100,
				
				fdash:		0, 
				fdash_int:	0,
				mdash:		0,
				mdash_int:	0,
				f_gp:		0
			});
			
			peakYellowNeg = 20;

			params = getQParameters(userProfile);
			params_int = getQParameters(interventionProfile, false);
			
			// pass intervention age through intervention parameters as age
			params_int.age = appState.interventionAge;
			
			var gender:String = userProfile.gender;
			

				params_int.noOfFollowUpYears = 
					params.noOfFollowUpYears = 
						appState.maximumAge - userProfile.age;
			
			flashScore = new FlashScore2011();

			committing = true;
			path = "Q65_derivation_cvd_time_40_"+userProfile.b_gender+ ".csv";
			
			if(appState.selectedScreenName == "compare" || appState.selectedScreenName == "heartAge") {
				// Need to calculate general population too. Do this first.
				
				// Define the general population as average person with same age, gender and ethnic group with 'good' discrete values.
				params_gp = new QParametersVO(
					userProfile.b_gender, 			// same gender
					0,0,0,0,0,			  			// zero boolean risk factors
					centerings[gender].bmi,			// centred bmi	
					userProfile.ethRisk,  			// same ethnic group 
					0,					  			// zero boolean risk factors
					centerings[gender].rati,		// centred chol ratio
					centerings[gender].sbp,			// centred sbp
					0,					  			// non-smoker	
					centerings[gender].town,		// central Townsend score
					userProfile.age, 	  			// same age
					0);					
				
				params_gp.noOfFollowUpYears = params.noOfFollowUpYears;
					
				flashScore_gp = new FlashScore2011();
				flashScore_gp.addEventListener(Event.COMPLETE, doWithAndWithout);
				flashScore_gp.calculateScore(path, params_gp);				
			}
			else {
				flashScore_gp = null;
				doWithAndWithout();
			}
		}
	
		private function doWithAndWithout(event:Event = null):void
		{
			if(flashScore_gp)
				flashScore_gp.removeEventListener(Event.COMPLETE, doWithAndWithout);
			
			flashScore = new FlashScore2011();
			flashScore.addEventListener(Event.COMPLETE, completionHandler_int);
			flashScore.djsCalculateScoreWithInterventions(path, 
				params, params_int,
				userProfile.totalCholesterol - userProfile.hdlCholesterol,
				interventionProfile.totalCholesterol - interventionProfile.hdlCholesterol
			);
		}
	
		private function completionHandler_int(event:Event):void
		{
			// We have now calculated both with and without intervention and can stuff the results Array
			flashScore.removeEventListener(Event.COMPLETE, completionHandler_int);
			
			var lifeTable:LifetimeRiskTable = flashScore.result.annualRiskTable;
			var lifeTable_int:LifetimeRiskTable = flashScore.result.annualRiskTable_int;
			var lifeTable_gp:LifetimeRiskTable = flashScore_gp ? flashScore_gp.result.annualRiskTable : lifeTable;
			var cachedAge:int = userProfile.age;
			
			for(var i:int = 0; i < lifeTable.rows.length; i++) {
				var row:LifetimeRiskRow = lifeTable.rows[i];
				var row_int:LifetimeRiskRow = lifeTable_int.rows[i];
				var row_gp:LifetimeRiskRow = lifeTable_gp.rows[i];
				
				sum_e += 100*row.S_1;
				sum_e_int += 100*row_int.S_1;
				
				var f:Number = 100*row.cif_cvd;
				var m:Number = 100*row.cif_death;
				var f_int:Number = 100*row_int.cif_cvd;
				var m_int:Number = 100*row_int.cif_death;
				var f_gp:Number = 100*row_gp.cif_death;

				// outlook yellow
				var yellow:Number = f+m - (m_int+f_int);
				
				// cope with rare occasions when m+f > 100
				var greenUnclamped:Number = 100 - Math.max(m + f, m_int + f_int);
				if(greenUnclamped < 0)
					yellow = Math.min(0, yellow + greenUnclamped);
				yellow = Math.max(0,yellow);
				
				var green:Number = Math.min(100, Math.max(0, greenUnclamped));
				var red:Number = f_int;
				
				results.push({
					age:		cachedAge+i,
					
					// for Outlook (+ve)
					green:		green,
					yellow:		green + yellow,		
					red:		green + yellow + red,					
					
					// for Outlook (-ve)
					redNeg:	    f_int,					// f_int == f until interventions are entered
					yellowNeg: 	f_int + yellow,			// yellow is sitting on top of f_int
					blueNeg:	m_int + f_int + yellow, // no longer used
					
					yellowOnly: yellow,
					redOnly:	red,
					
					// for Outcomes
					fdash:		f, 
					fdash_int:	f_int,
					mdash:		m,
					mdash_int:	m_int,
					f_gp:		f_gp
				});
				peakYellowNeg = Math.max(f_int + yellow, peakYellowNeg);
				_peakf = Math.max(_peakf, f);
				_peakf = Math.max(_peakf, f_int);
			}
			
			_resultSet = new ArrayCollection(results);
			
			committing = false;
			modelUpdatedSignal.dispatch();
		}
	
		override public function get heartAge():Number
		{
			return heartAgeUsingHazard;
		}

		/**
		 * TODO:
		 * Extend search to allow younger heart age than actual age.
		 * Currently, minimum heart age is actual age.
		 */
		private function get heartAgeUsingHazard():Number
		{
			// Calculate my current hazard.
			// For heart age purposes we ignore death by other causes since it's irrelevant!
			var myHazard:Number = flashScore.result.annualRiskTable_int.getNoDeathHazardAt(0);
			
			// Hunt through the general population annual risk table till we find a similar risk level
			var gp_annualTable:LifetimeRiskTable = flashScore_gp.result.annualRiskTable;
			
			
			var gplen:int = gp_annualTable.rows.length
			for(var i:int = 0; i+1 < gplen; i++) {
//				trace("gp["+i+"] hazard = " + gp_annualTable.getNoDeathHazardAt(i));
				if(gp_annualTable.getNoDeathHazardAt(i) >= myHazard)
					break;
			}
			
			return i + userProfile.age;
		}

		override public function get heartAgeText():String
		{
			return heartAge.toString();
		}		
		
		
		private var _peakf:Number;
		/**
		 * @return peak cardiovascular risk
		 */   
		public function get peakf():Number 
		{
			return _peakf;	
		}
	}
}
