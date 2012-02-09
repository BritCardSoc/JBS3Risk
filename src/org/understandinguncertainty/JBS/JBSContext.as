/*
This file forms part of the JBS3Risk Cardiovascular Assessment Tool.
It is ©2012 University of Cambridge.
It is released under version 3 of the GNU General Public License
Source code, including a copy of the license is available at https://github.com/BritCardSoc/JBS3Risk
*/
package org.understandinguncertainty.JBS
{
	import flash.display.DisplayObjectContainer;
	
	import mx.resources.IResourceManager;
	import mx.resources.ResourceManager;
	
	import org.robotlegs.mvcs.SignalContext;
	import org.understandinguncertainty.JBS.controller.SetupInterventionProfile;
	import org.understandinguncertainty.JBS.model.AppState;
	import org.understandinguncertainty.JBS.model.ICardioModel;
	import org.understandinguncertainty.JBS.model.QRunModel;
	import org.understandinguncertainty.JBS.model.RunModel;
	import org.understandinguncertainty.JBS.model.UserModel;
	import org.understandinguncertainty.JBS.signals.ClearInterventionsSignal;
	import org.understandinguncertainty.JBS.signals.InterventionEditedSignal;
	import org.understandinguncertainty.JBS.signals.ModelUpdatedSignal;
	import org.understandinguncertainty.JBS.signals.NextScreenSignal;
	import org.understandinguncertainty.JBS.signals.NumbersAvailableSignal;
	import org.understandinguncertainty.JBS.signals.ProfileCommitSignal;
	import org.understandinguncertainty.JBS.signals.ProfileLoadSignal;
	import org.understandinguncertainty.JBS.signals.ProfileSaveSignal;
	import org.understandinguncertainty.JBS.signals.ProfileValidSignal;
	import org.understandinguncertainty.JBS.signals.ReleaseScreenSignal;
	import org.understandinguncertainty.JBS.signals.ScreenChangedSignal;
	import org.understandinguncertainty.JBS.signals.ScreensNamedSignal;
	import org.understandinguncertainty.JBS.signals.ShowDifferencesChangedSignal;
	import org.understandinguncertainty.JBS.signals.UpdateModelSignal;
	import org.understandinguncertainty.JBS.view.AgeSettings;
	import org.understandinguncertainty.JBS.view.AgeSettingsMediator;
	import org.understandinguncertainty.JBS.view.BadBalance;
	import org.understandinguncertainty.JBS.view.BadBalanceMediator;
	import org.understandinguncertainty.JBS.view.Balance;
	import org.understandinguncertainty.JBS.view.BalanceMediator;
	import org.understandinguncertainty.JBS.view.Compare;
	import org.understandinguncertainty.JBS.view.CompareMediator;
	import org.understandinguncertainty.JBS.view.DeadBalance;
	import org.understandinguncertainty.JBS.view.DeadBalanceMediator;
	import org.understandinguncertainty.JBS.view.DeanfieldChart;
	import org.understandinguncertainty.JBS.view.DeanfieldChartMediator;
	import org.understandinguncertainty.JBS.view.DifferenceBalance;
	import org.understandinguncertainty.JBS.view.DifferenceBalanceMediator;
	import org.understandinguncertainty.JBS.view.GoodBalance;
	import org.understandinguncertainty.JBS.view.GoodBalanceMediator;
	import org.understandinguncertainty.JBS.view.HeartAge;
	import org.understandinguncertainty.JBS.view.HeartAgeMediator;
	import org.understandinguncertainty.JBS.view.InterventionsPanel;
	import org.understandinguncertainty.JBS.view.InterventionsPanelMediator;
	import org.understandinguncertainty.JBS.view.Main;
	import org.understandinguncertainty.JBS.view.MainMediator;
	import org.understandinguncertainty.JBS.view.MainPanel;
	import org.understandinguncertainty.JBS.view.MainPanelMediator;
	import org.understandinguncertainty.JBS.view.Outcomes;
	import org.understandinguncertainty.JBS.view.OutcomesMediator;
	import org.understandinguncertainty.JBS.view.RiskByAge;
	import org.understandinguncertainty.JBS.view.RiskByAgeMediator;
	import org.understandinguncertainty.JBS.view.Profile;
	import org.understandinguncertainty.JBS.view.ProfileMediator;
	import org.understandinguncertainty.JBS.view.QProfile;
	import org.understandinguncertainty.JBS.view.QProfileMediator;
	import org.understandinguncertainty.JBS.view.ScreenSelector;
	import org.understandinguncertainty.JBS.view.ScreenSelectorMediator;
	
	public class JBSContext extends SignalContext
	{
				
		public function JBSContext(contextView:DisplayObjectContainer=null, autoStartup:Boolean=true)
		{
			super(contextView, autoStartup);
		}
		
		override public function startup() : void
		{
			
			// inject ResourceManager
			injector.mapValue(IResourceManager, ResourceManager.getInstance());

			// Model
			injector.mapSingleton(AppState);
			
			var userProfile:UserModel = new UserModel();
			injector.mapValue(UserModel, userProfile, "userProfile");
			
			var interventionProfile:UserModel = new UserModel();
			injector.mapValue(UserModel, interventionProfile, "interventionProfile");	
			

			// RunModel uses Framingham
			// injector.mapSingletonOf(ICardioModel, RunModel); 
			injector.mapSingletonOf(ICardioModel, QRunModel);
			
			// Signals
			injector.mapSingleton(ProfileValidSignal);
			injector.mapSingleton(ProfileLoadSignal);
			injector.mapSingleton(ProfileSaveSignal);
			injector.mapSingleton(ProfileCommitSignal);
			injector.mapSingleton(ReleaseScreenSignal);
			injector.mapSingleton(ScreenChangedSignal);
			injector.mapSingleton(ScreensNamedSignal);
			injector.mapSingleton(NextScreenSignal);
			injector.mapSingleton(ClearInterventionsSignal);
			injector.mapSingleton(ShowDifferencesChangedSignal);
			
			injector.mapSingleton(InterventionEditedSignal);
			injector.mapSingleton(UpdateModelSignal);
			injector.mapSingleton(ModelUpdatedSignal);
			injector.mapSingleton(NumbersAvailableSignal);

			// View
			mediatorMap.mapView(Main, MainMediator);
			mediatorMap.mapView(MainPanel, MainPanelMediator);
			mediatorMap.mapView(ScreenSelector, ScreenSelectorMediator);
			
			// Profile and ProfileMediator adopt a FRamingham profile
			//mediatorMap.mapView(Profile, ProfileMediator);
			mediatorMap.mapView(QProfile, QProfileMediator);
			
			mediatorMap.mapView(InterventionsPanel, InterventionsPanelMediator);
			mediatorMap.mapView(HeartAge, HeartAgeMediator);
			mediatorMap.mapView(AgeSettings, AgeSettingsMediator);
			mediatorMap.mapView(DeanfieldChart, DeanfieldChartMediator);
			mediatorMap.mapView(RiskByAge, RiskByAgeMediator);
			mediatorMap.mapView(Outcomes, OutcomesMediator);
			
			mediatorMap.mapView(Balance, BalanceMediator);
				mediatorMap.mapView(GoodBalance, GoodBalanceMediator);
				mediatorMap.mapView(BadBalance, BadBalanceMediator);
				mediatorMap.mapView(DeadBalance, DeadBalanceMediator);
			
			mediatorMap.mapView(Compare, CompareMediator);
			
						
			super.startup();
		}
	}
}