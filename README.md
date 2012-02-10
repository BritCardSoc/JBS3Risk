COPYRIGHT and LICENSING
-----------------------
The JBS3 Cardiovascular Risk Assessment was created by the [Understanding Uncertainty team](http://understandinguncertainty.org) of the University of Cambridge, 
working with the [British Cardiovascular Society](http://www.bcs.com). 
The current version was released in 2012 and is copyright the University of Cambridge. 
It is released under [version 3 of the GNU General Public License](http://www.gnu.org/licenses/gpl.html).
The source code, containing a copy of this license is [published on GitHub](https://github.com/BritCardSoc/JBS3Risk).

RISK MODEL
----------
The tool contains a risk model derived from the open source code distribution of the [QRISK® cardiovascular lifetime risk calculator](http://qrisk.org/lifetime/index.php), and uses a verbatim copy of the associated data tables
	*[Q65_derivation_cvd_time_40_0.csv](https://github.com/BritCardSoc/JBS3Risk/src/Q65_derivation_cvd_time_40_0.csv)
	*[Q65_derivation_cvd_time_40_1.csv](https://github.com/BritCardSoc/JBS3Risk/src/Q65_derivation_cvd_time_40_1.csv)
Further details of the implementation used in this calculator, 
including details of the interventions model are in the [pubs directory on GitHub](https://github.com/BritCardSoc/JBS3Risk).

CREDITS
-------
We'd like to thank the creators of the following third party libraries:
	* [QRISK®-lifetime-2011](http://qrisk.org/lifetime/QRISK-lifetime-2011-opensource.v1.0.tgz) released by ClinRisk Ltd.
	* [AS3-Signals by Robert Penner](http://github.com/robertpenner/as3-signals)
	* [The Robotlegs framework v1](http://github.com/robotlegs/robotlegs-framework)
	* [Signals-extensions-CommandSignal](http://github.com/joelhooks/signals-extensions-CommandSignal) by Joel Hooks
	* [SwiftSuspenders](http://github.com/tschneidereit/SwiftSuspenders) by Till Schneidereit

LANGUAGE
--------
This is a Flash Builder 4 web project written in actionscript 3 and mxml. 
To compile, download the distribution and create a new Flex Web Project using the distribution folder as
the project folder. The sources may also be compiled using the [free Adobe FLEX SDK](http://www.adobe.com/cfusion/entitlement/index.cfm?e=flex4sdk).

SAMPLE FILES
------------
The src folder contains a number of sample xml files which may be loaded into the Profile screen.

USAGE
-----
Launch the animation in a web browser. On the Profile screen, fill in your personal data. 
You may save your personal data to your local disk for later use. Once valid data is available
on the Profile screen, the output screens will be enabled.					

