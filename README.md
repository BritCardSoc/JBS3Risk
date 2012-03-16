COPYRIGHT and LICENSING
-----------------------
The JBS3 Cardiovascular Risk Assessment was created by the [Understanding Uncertainty team](http://understandinguncertainty.org) of the University of Cambridge, 
working with the [British Cardiovascular Society](http://www.bcs.com). 
The current version was released in 2012 and is copyright the University of Cambridge. 
It is released under [version 3 of the GNU General Public License](http://www.gnu.org/licenses/gpl.html).
The source code, containing a copy of this license is [published on GitHub](https://github.com/BritCardSoc/JBS3Risk).

RISK MODEL
----------
The tool contains a risk model derived from the open source C distribution of the [QRISK® cardiovascular lifetime risk calculator](http://qrisk.org/lifetime/index.php), and ported into actionscript3. The source code for the port is published at [QR-lifetime-2011-flash](http://github.com/BritCardSoc/QR-lifetime-2011-flash). It uses data read in from a verbatim copy of the data tables found in [QRISK®-lifetime-2011](http://qrisk.org/lifetime/QRISK-lifetime-2011-opensource.v1.0.tgz).

*	[Q65_derivation_cvd_time_40_0.csv](https://github.com/BritCardSoc/JBS3Risk/src/Q65_derivation_cvd_time_40_0.csv)
*	[Q65_derivation_cvd_time_40_1.csv](https://github.com/BritCardSoc/JBS3Risk/src/Q65_derivation_cvd_time_40_1.csv)
	
Further details of the implementation used in this calculator, 
including details of the interventions model are in the [pubs directory on GitHub](https://github.com/BritCardSoc/JBS3Risk).

CREDITS
-------
We'd like to thank the creators of the following third party libraries:

* 	[QRISK®-lifetime-2011](http://qrisk.org/lifetime/QRISK-lifetime-2011-opensource.v1.0.tgz) released by ClinRisk Ltd.
* 	[AS3-Signals](http://github.com/robertpenner/as3-signals) by Robert Penner
* 	[The Robotlegs framework v1](http://github.com/robotlegs/robotlegs-framework)
* 	[Signals-extensions-CommandSignal](http://github.com/joelhooks/signals-extensions-CommandSignal) by Joel Hooks
* 	[SwiftSuspenders](http://github.com/tschneidereit/SwiftSuspenders) by Till Schneidereit.

DEPENDENCIES
------------
As JBS3Risk is dependent on open source libraries which may change independently, we are publishing snapshots of the distributions we use alongside this repository. They may be installed and linked to JBS3Risk by importing them as Flex Projects alongside JBS3Risk within the Flash Builder 4 development environment. It may be more convenient to ignore library sources and build JBS3Risk using the compiled swc files which are included in the lib directory. 

These are the snapshots you need if building from source:

*	[QR-lifetime-2011-flash](http://github.com/BritCardSoc/QR-lifetime-2011-flash) 
* 	[AS3-Signals](http://github.com/BritCardSoc/as3-signals)
* 	[The Robotlegs framework](http://github.com/BritCardSoc/robotlegs-framework)
* 	[Signals-extensions-CommandSignal](http://github.com/BritCardSoc/signals-extensions-CommandSignal) 
* 	[SwiftSuspenders](http://github.com/BritCardSoc/SwiftSuspenders) 

LANGUAGE
--------
This is a Flash Builder 4 web project written in actionscript 3 and mxml. 
To compile, download the distribution and create a new Flex Web Project using the distribution folder as
the project folder. The sources may also be compiled and linked with the [free Adobe FLEX SDK](http://www.adobe.com/cfusion/entitlement/index.cfm?e=flex4sdk). 

This version uses the Flex SDK version 4.1 build 16076.

SAMPLE FILES
------------
The src folder contains a number of sample xml files which may be loaded into the Profile screen.

USAGE
-----
Launch the animation in a web browser. On the Profile screen, fill in your personal data. 
You may save your personal data to your local disk for later use. Once valid data is available
on the Profile screen, the output screens will be enabled.					

