/*
This file forms part of the JBS3Risk Cardiovascular Assessment Tool.
It is ©2012 University of Cambridge.
It is released under version 3 of the GNU General Public License
Source code, including a copy of the license is available at https://github.com/BritCardSoc/JBS3Risk
*/
package org.understandinguncertainty.JBS.service
{
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	import mx.controls.Alert;
	
	public class Web
	{
		public static function getURL(url:String, window:String = null):void
		{
			var req:URLRequest = new URLRequest(url);
			try
			{
				navigateToURL(req, window);
			}
			catch (e:Error)
			{
				Alert.show(e.message, "Failed to connect", Alert.OK);
			}
		}
	}
}