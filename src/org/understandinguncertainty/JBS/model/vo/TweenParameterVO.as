/*
This file forms part of the JBS3Risk Cardiovascular Assessment Tool.
It is ©2012 University of Cambridge.
It is released under version 3 of the GNU General Public License
Source code, including a copy of the license is available at https://github.com/BritCardSoc/JBS3Risk
*/
package org.understandinguncertainty.JBS.model.vo
{
	public class TweenParameterVO
	{
		public var bmi:TweenConfig = new TweenConfig(0,1,1);
		public var bmi:TweenConfig = new TweenConfig(0,1,1);
		
		tweenConfig:XML = <interventionTweens>
				<tweenConfig name="bmi" delay="0" duration="0" proportion="1"/>
				<tweenConfig name="smoking" delay="0" duration="0" proportion="1"/>
			</interventionTweens>;
		
		function tween(parameter:String, t:int, from:Number, to:Number):Number
		{
						
		}
		
		
	}
}