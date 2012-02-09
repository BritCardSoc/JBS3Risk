/*
This file forms part of the JBS3Risk Cardiovascular Assessment Tool.
It is ©2012 University of Cambridge.
It is released under version 3 of the GNU General Public License
Source code, including a copy of the license is available at https://github.com/BritCardSoc/JBS3Risk

NB This file is not compiled into the current swf

*/
/**
 * Parameters for Framningham model [Dag2009]
 * See http://circ.ahajournals.org/cgi/content/full/117/6/743
 *
 * See MaleParameter and FemaleParameter subclasses for actual values. 
 */
package org.understandinguncertainty.JBS.framingham.model
{
	import org.understandinguncertainty.JBS.model.vo.BetasVO;

	public interface FraminghamParameters
	{
		
		// Dag2009 table 2
		function get beta():BetasVO;
		
		// Appendix 1 case 1 and case 2 xbar values
		function get xbar():BetasVO;
		
		// sum (beta_i * xbar_i)
		function get averageHazard():Number;
		
		// baseline risk - see DJS notes
		function get a():Number;
		
		// ONS: England & Wales 2005-2007 interim life tables
		function get b():Array;
		
		/**
		 * 
		 * @return the interpolation parameter to use when calculating the effect 
		 * of intervention. q = 0 means intervention has no effect. q = 1 means the
		 * value after intervention has the full effect.
		 * e.g. For a smoker, if we set q to 0.5, then the benefit of stopping smoking
		 * is half the benefit of never having smoked.
		 *  
		 */
		function get q():BetasVO;
		
	}
}