/*
This file forms part of the JBS3Risk Cardiovascular Assessment Tool.
It is ©2012 University of Cambridge.
It is released under version 3 of the GNU General Public License
Source code, including a copy of the license is available at https://github.com/BritCardSoc/JBS3Risk
*/
package org.understandinguncertainty.JBS.model
{
	import mx.collections.ArrayCollection;
	
	import org.understandinguncertainty.JBS.model.vo.ColourNumbersVO;

	public interface ICardioModel
	{
		function get gainsByYear():ArrayCollection;
		
		function getResultSet():ArrayCollection;
		function get yearGain():Number;
		function get meanAge():Number;
		
		function set heartAge(i:Number):void
		function get heartAge():Number;
		
		function get heartAgeText():String;
		function set heartAgeText(value:String):void;
		
		function get endTreatmentAge():int;
		function set endTreatmentAge(age:int):void;
		

		/**
		 * returns the minimum acceptable value of the outlook (-ve) vertical axis slider
		 */
		function get peakYellowPadded():Number;
		
		/**
		 * @return counts of each colour in balance views
		 */
		function get colourNumbers():ColourNumbersVO
			
		/** 
		 * Recalculates the model based on current properties
		 */
		function commitProperties():void

		/**
		 * @param b sets whether to show differences in the UI
		 */
		function set showDifferences(b:Boolean):void
		
		/**
		 * @return whether to show differences in the UI
		 */
		function get showDifferences():Boolean
		
		/**
		 * @return peak cardiovascular risk
		 */   
		function get peakf():Number;
	}
}