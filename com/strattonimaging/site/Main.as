package com.strattonimaging.site
{
	import com.bigspaceship.display.PreloaderClip;
	import com.bigspaceship.display.SiteLoader;
	import com.bigspaceship.loading.BigLoader;
	import com.bigspaceship.utils.Environment;
	import com.bigspaceship.utils.Out;
	import com.strattonimaging.site.display.MainView;
	import com.strattonimaging.site.events.ScreenEvent;
	import com.strattonimaging.site.model.SiteModel;
	
	import flash.display.MovieClip;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	
	import net.ored.util.Resize;
	
	import nl.demonsters.debugger.MonsterDebugger;
	
	[SWF (width="960", height="570", backgroundColor="#ffffff", frameRate="30")]
	public class Main extends MovieClip
	{
		private var _mainview										:MainView;
		private var _preloader										:PreloaderClip;
		private var _siteModel:SiteModel;
		
		//demonster debugger
		private var debugger:MonsterDebugger;
		//master loader
		private var _loader											:BigLoader;
		private var _loadList										:XMLList;
		private var _loadState										:String;
		
		
		
		public function Main()
		{
			super();
			if(!stage) addEventListener(Event.ADDED_TO_STAGE,_initialize,false,0,true);
			else _initialize();
			
		}//end constructor
		
		private function _initialize($evt:Event = null):void{
						
			removeEventListener(Event.ADDED_TO_STAGE,_initialize);
			// Init the debuggers
			debugger = new MonsterDebugger(this);
			Out.enableAllLevels(true);
			Out.status(this,"_initialize(); Main the next generation");
			
			//site wide config
			_siteModel = SiteModel.getInstance();
			_siteModel.initialize(stage.loaderInfo);
			
			if(!Environment.IS_IN_BROWSER){
				stage.scaleMode = StageScaleMode.NO_SCALE;
				stage.align = StageAlign.TOP_LEFT;
				Resize.setStage(stage);
			}//end if 
			
			
			_mainview = new MainView(this);
			_mainview.addEventListener(ScreenEvent.REQUEST_LOAD,_loadScreen,false,0,true);
			_mainview.addEventListener(ScreenEvent.REQUEST_LOAD_CANCEL,_loadScreenCancel,false,0,true);

			if(SiteLoader.getInstance()) _preloader = SiteLoader.getInstance().preloader_mc;
			
			if(_preloader) {
				_preloader.addEventListener(Event.INIT,_preloaderOnAnimateIn,false,0,true);
				_preloader.addEventListener(Event.COMPLETE,_preloaderOnAnimateOut,false,0,true);
				_mainview.addPreloader(_preloader);
			}
			
			_loadState = Constants.LOAD_STATE_INIT;
			_loadConfigXml();
			
		}//end initialize function
		
		/***********************************************************/
		//loading functions
		/***********************************************************/
		//load config xml
		
		private function _loadConfigXml():void{
			_loader = new BigLoader();
			
			var configURL:String = _siteModel.getBaseURL() + SiteModel.CONFIG_XML_PATH;
			
			Out.debug(this,"Config URL: " + configURL);
			_loader.add(configURL, "config");
			_loader.addEventListener(Event.COMPLETE, _onConfigXMLLoaded,false,0,true);			
			_loader.start();			
		}//end function
		
		private function _onConfigXMLLoaded($evt:Event):void{
			_siteModel.configXml = new XML(_loader.getLoadedAssetById("config"));
			
			_loader.removeEventListener(Event.COMPLETE, _onConfigXMLLoaded);
			_loaderCleanUp();
			
			// initial load begins here
			_loadState = Constants.LOAD_STATE_INITIAL_ASSETS_BEGIN;
			_loadList = _siteModel.getNodeByType(SiteModel.CONFIG_LOADABLES, SiteModel.CONFIG_COMPONENTS).component;
			Out.status(this, "_onConfigXMLLoaded :: loadlist.length = "+ _loadList.length());
			if(_loadList.length() > 0) _startLoad();
			else _onFrontloadComplete();
		}//end function
		
		private function _startLoad():void{
			_loaderCleanUp();
			_loader = new BigLoader();
			_loader.addEventListener(ProgressEvent.PROGRESS, _onLoadProgress, false, 0, true);
			_loader.addEventListener(Event.COMPLETE, _onComponentLoadComplete, false, 0, true);
			
			var n:uint;
			for (n=0; n < _loadList.length(); n++){
				var swfPath:String = _loadList[n].@swf || "";
				var xmlPath:String = _loadList[n].@xml || "";
				
				if (swfPath != "") _loader.add(_siteModel.getFilePath(swfPath, "swf"), _loadList[n].@id + "_" + Constants.TYPE_SWF);//spits out an id that looks like this "header_swf"
				if (xmlPath != "") _loader.add(_siteModel.getFilePath(xmlPath, "xml"), _loadList[n].@id + "_" + Constants.TYPE_XML);//spits out an id that looks like this "header_swf"
			}//end for
			
			_loader.start();
		}//end _startLoad function
		
		private function _onComponentLoadComplete($evt:Event):void{
			Out.status(this,"_onComponentLoadComplete();");
			for(var i:int=0;i<_loadList.length();i++) {
				Out.info(this, _loadList[i].toXMLString());
				
				var swfPath:String = _loadList[i].@swf || "";
				var xmlPath:String = _loadList[i].@xml || "";
				
				var swf:MovieClip = (swfPath != "") ? _loader.getLoadedAssetById(_loadList[i].@id + "_" + Constants.TYPE_SWF) : new MovieClip();
				var xml:XML = (xmlPath != "") ? XML(_loader.getLoadedAssetById(_loadList[i].@id + "_" + Constants.TYPE_XML)) : new XML();
				
				if(_loadList[i].@id == Constants.COMPONENT_ASSETS) {
					_siteModel.siteAssets = swf;
				}
				else if(_loadList[i].@id == Constants.COMPONENT_SECTION_LOADER) {
					_mainview.addAsset(_loadList[i].@id,swf,xml);
				}
				else {
					if(_loadState == Constants.LOAD_STATE_INITIAL_ASSETS_BEGIN) _mainview.addAsset(_loadList[i].@id,swf,xml);
					else _mainview.addScreen(_loadList[i].@id,swf,xml);					
				}
				
			}//end for
			
			_loadList = null;
			
			if(_loadState == Constants.LOAD_STATE_INITIAL_ASSETS_BEGIN) _onFrontloadComplete();
			else if(_loadState == Constants.LOAD_STATE_INITIAL_SCREEN_BEGIN || _loadState == Constants.LOAD_STATE_SCREEN_BEGIN) _onScreenloadComplete();
			else Out.fatal(this,"_onComponentLoadComplete() :: strange state encountered :: " + _loadState);
		}//end onComponentLoadComplete
		
		private function _onScreenloadComplete():void
		{
			Out.status(this,"_onScreenloadComplete();");
			var lastLoadState:String = _loadState;
			_loadState = Constants.LOAD_STATE_SCREEN_COMPONENT_BEGIN;
			
			_mainview.addEventListener(ProgressEvent.PROGRESS,_onLoadProgress,false,0,true);
			_mainview.addEventListener(Event.COMPLETE,_onLoadScreenSpecificComplete,false,0,true);
			_mainview.loadScreenSpecifics();
		}//end function
		
		private function _onLoadScreenSpecificComplete($evt:Event):void {
			Out.status(this,"_onLoadScreenSpecificComplete()");
			_loadState = Constants.LOAD_STATE_SCREEN_COMPLETE;
			
			if(_preloader) _preloader.setComplete();
			else _preloaderOnAnimateOut();
		}//end onLoadScreenSpecificComplete function
		
		private function _onFrontloadComplete():void {	
			Out.status(this,"_onFrontloadComplete();");
			
			_loadState = Constants.LOAD_STATE_INITIAL_ASSETS_COMPLETE;
			
			// jk: force the first screen to load.
			_siteModel.getInitialPath();
		}
		/**our master loading tidy up function**/
		private function _loaderCleanUp():void {
			if(_loader) {
				_loader.addEventListener(ProgressEvent.PROGRESS,_onLoadProgress);
				_loader.addEventListener(Event.COMPLETE, _onComponentLoadComplete);
				_loader.destroy();
				_loader = null;
			}
		}//end function
		
		/***********************************************************/
		//ScreenEvent Handlers
		/***********************************************************/
		/**
		 * Handles the ScreenEvents on the main view, fired when we need to switch screens
		 * @param $evt
		 * 
		 */		
		private function _loadScreen($evt:ScreenEvent = null):void {
			var lastLoadState:String = _loadState;
			
			_loadState = (_loadState == Constants.LOAD_STATE_INITIAL_ASSETS_COMPLETE) ? Constants.LOAD_STATE_INITIAL_SCREEN_BEGIN: Constants.LOAD_STATE_SCREEN_BEGIN;
			_loadList = _siteModel.configXml.loadables.component.(@id == _siteModel.currentScreen);
			
			switch(lastLoadState)
			{
				case Constants.LOAD_STATE_INITIAL_ASSETS_BEGIN:
				case Constants.LOAD_STATE_INITIAL_SCREEN_BEGIN:
					Out.fatal(this,"Something is wrong... _loadScreen() called before initial load finished.");
					break;
				
				case Constants.LOAD_STATE_SCREEN_COMPONENT_BEGIN:
					_loadScreenCancel();
					break;
				
				case Constants.LOAD_STATE_SCREEN_BEGIN:
				case Constants.LOAD_STATE_SCREEN_COMPLETE:
					if(_preloader) _preloader.animateIn();
					else _preloaderOnAnimateIn();
					break;
				
				case Constants.LOAD_STATE_INITIAL_ASSETS_COMPLETE:
					_startLoad();
					break;
				
				default:
					Out.fatal(this,"_loadScreen() called at strange stage: " + lastLoadState);
					break;
			}//end switch
		}//end function _loadScreen
		
		/**
		 * Handles the ScreenEvent fired in the main view when someone interrupts the loading of a screen. 
		 * @param $evt
		 * 
		 */		
		private function _loadScreenCancel($evt:ScreenEvent = null):void {
			Out.status(this,"_loadScreenCancel();");
			if($evt != null) _loadState = Constants.LOAD_STATE_SCREEN_COMPLETE;
			
			_mainview.cancelLoadScreenSpecifics();
			if(_preloader) _preloader.cancel();						
		}//end function
		
		/***********************************************************/
		// preloader functions
		/***********************************************************/
		private function _preloaderOnAnimateIn($evt:Event = null):void {
			Out.status(this,"_preloaderOnAnimateIn();");
			_startLoad();						
		}
		
		private function _preloaderOnAnimateOut($evt:Event = null):void {
			
			Out.status(this,"we need to destroy the preloader and make a new one;");
			
			if(_preloader) {
					_preloader.removeEventListener(Event.INIT,_preloaderOnAnimateIn);
					_preloader.removeEventListener(Event.COMPLETE,_preloaderOnAnimateOut);
					_preloader = null;
					Out.debug(this,"we tried to destroy it, can you see it? ok make a new one");
			}
					
		 			//making a new preloader
				 	_preloader = new PreloaderClip();
					_mainview.addPreloader(_preloader);
					_preloader.addEventListener(Event.INIT,_preloaderOnAnimateIn,false,0,true);
					_preloader.addEventListener(Event.COMPLETE,_preloaderOnAnimateOut,false,0,true);
					_mainview.addPreloader(_preloader);
			if(!_mainview.isNextScreenLoaded) {
				
				Out.debug(this,"the next screen isn't loaded we need to load it;");
				_loadScreen();
			}
			else _mainview.screenOnLoaded();	
			
		
			
			
		}//end function
		
		/**
		 * here is the infamous progress event handler
		 * it controls the main preloader with the progress of
		 * all the loaders.
		 *  
		 * @param $evt
		 * 
		 */		
		private function _onLoadProgress($evt:ProgressEvent):void {
			var itemsLoaded:Number = 0;
			var itemsTotal:Number = 0;
			
			switch(_loadState)
			{
				case Constants.LOAD_STATE_SCREEN_BEGIN:
					itemsLoaded = 0;
					itemsTotal = 2;
					break;
				
				case Constants.LOAD_STATE_SCREEN_COMPLETE:
					itemsLoaded = 2;
					itemsTotal = 2;
					break;
				
				case Constants.LOAD_STATE_SCREEN_COMPONENT_BEGIN:
					itemsLoaded = 1;
					itemsTotal = 2;
					break;
				
				case Constants.LOAD_STATE_INITIAL_SCREEN_BEGIN:
				case Constants.LOAD_STATE_INITIAL_ASSETS_COMPLETE:
					itemsLoaded = 1;
					itemsTotal = 3;
					break;
				
				case Constants.LOAD_STATE_INITIAL_ASSETS_BEGIN:
					itemsLoaded = 0;
					itemsTotal = 3;
					break;
			}
			
			if(_preloader) _preloader.updateProgress($evt.bytesLoaded,$evt.bytesTotal,itemsLoaded,itemsTotal);
		}


	}//end class
}//end package