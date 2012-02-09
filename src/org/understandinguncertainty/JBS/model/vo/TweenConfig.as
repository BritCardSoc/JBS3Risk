/*
This file forms part of the JBS3Risk Cardiovascular Assessment Tool.
It is ©2012 University of Cambridge.
It is released under version 3 of the GNU General Public License
Source code, including a copy of the license is available at https://github.com/BritCardSoc/JBS3Risk
*/
package org.understandinguncertainty.JBS.model.vo
{
	import mx.utils.XMLUtil;
	
	import org.maths.XMLUtilities;

	/**
	 * 
	 * Stores the parameters needed to calculate the effect of an intervention after it is applied
	 * @author gmp26
	 * 
	 */
	public class TweenConfig
	{
		public var name:String;			// parameter name
		public var delay:int;			// delay after intervention start time before we start tweening
		public var duration:int;		// how long to tween for
		public var proportion:Number;	// proportion of desired parameter change that is eventually achieved
		
		function TweenConfig(initObj:Object)
		{
			this.name = initObj.name ? initObj.name : "unknown";
			this.delay = initObj.delay ? initObj.delay : 0;
			this.duration = initObj.duration ? initObj.duration : 0;
			this.proportion = initObj.proportion ? initObj.proportion : 1;
		}
		
		public function toXML():String
		{
			var xml:XML = new XML();
			xml = <tweenConfig name={name} delay={delay} duration={duration} proportion={proportion} />;
		}
		
		public function fromXML(x:XML):void
		{
			// set defaults
			delay = 0;
			duration = 0;
			proportion = 1;
			
			// return if this is wrong xml
			if(x.name() != "tweenConfig")
				return;
			
			// read in attributes
			delay = XMLUtilities.intAttr(x.@delay, delay);
			duration = XMLUtilities.intAttr(x.@duration, duration);
			proportion = XMLUtilities.intAttr(x.@proportion, proportion);
		}
	}
}