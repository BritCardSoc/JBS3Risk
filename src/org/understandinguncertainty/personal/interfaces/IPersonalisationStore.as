/*
This file forms part of the JBS3Risk Cardiovascular Assessment Tool.
It is ©2012 University of Cambridge.
It is released under version 3 of the GNU General Public License
Source code, including a copy of the license is available at https://github.com/BritCardSoc/JBS3Risk
*/
package org.understandinguncertainty.personal.interfaces
{
	import org.understandinguncertainty.personal.VariableList;
	
	public interface IPersonalisationStore
	{
		/**
		 * Load the store from some persistent memory
		 */
		function load():void;
		
		/**
		 * Save the store to persistent memory
		 */
		function save():void;
		
		/**
		 * Empty this personalisation store
		 */
		function clear():void;

		[Deprecated(replacement='Use variableList if you need a reference')]
		/**
		 * <p>Returning a reference is dangerous as it might prevent garbage collection</p>
		 * @return a reference to the list of defined variables.
		 * 
		 */
		function get variable():VariableList;
		
		/**
		 * <p>Returning a reference can be dangerous as it might prevent garbage collection</p>
		 * @return a reference to the list of defined variables.
		 * 
		 */
		function get variableList():VariableList;

		/**
		 * <p>The safe way to get a local copy of the variables.</p>
		 * @return a clone of the variableList.
		 * 
		 */
//		function get cloneVariableList():VariableList;
		
	}
}