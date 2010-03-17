package com.strattonimaging.site
{
	import com.bigspaceship.display.PreloaderClip;
	import com.bigspaceship.display.SiteLoader;
	import com.bigspaceship.utils.Out;
	import com.carlcalderon.arthropod.Debug;
	import com.strattonimaging.site.display.MainView;
	import com.strattonimaging.site.model.SiteModel;
	
	import flash.display.MovieClip;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	
	[SWF (width="980", height="742", backgroundColor="#DDDDDD", frameRate="30")]
	public class Main extends MovieClip
	{
		private var _mainview										:MainView;
		private var _preloader										:PreloaderClip;
		private var _siteModel:SiteModel;
		
		public function Main()
		{
			super();
			Out.enableAllLevels(true);
			//			if(Environment.IS_IN_BROWSER && !Environment.IS_BIGSPACESHIP) Out.disableAllLevels(); 
			
			_siteModel = SiteModel.getInstance();
			
			if(!stage) addEventListener(Event.ADDED_TO_STAGE,_initialize,false,0,true);
			else _initialize();
		}//end constructor
		
		private function _initialize($evt:Event = null):void{
			Out.status(this,"_initialize();");
			removeEventListener(Event.ADDED_TO_STAGE,_initialize);
			
			_siteModel.initialize(stage.loaderInfo);
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			if(SiteLoader.getInstance()) _preloader = SiteLoader.getInstance().preloader_mc;
			
			//TODO: create the site!
		}//end function
	}
}