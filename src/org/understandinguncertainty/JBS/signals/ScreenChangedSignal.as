/*
This file forms part of the JBS3Risk Cardiovascular Assessment Tool.
It is ©2012 University of Cambridge.
It is released under version 3 of the GNU General Public License
Source code, including a copy of the license is available at https://github.com/BritCardSoc/JBS3Risk
*/
package org.understandinguncertainty.JBS.signals
{
	import org.osflash.signals.Signal;
	
	public class ScreenChangedSignal extends Signal
	{
		public function ScreenChangedSignal()
		{
			super(String); // new screen index
		}
	}
}