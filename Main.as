package
{
	import com.bigspaceship.display.IPreloader;
	import com.bigspaceship.display.SiteLoader;
	import com.bigspaceship.loading.BigLoader;
	import com.bigspaceship.utils.Environment;
	import com.bigspaceship.utils.Out;
	import com.bigspaceship.utils.out.adapters.ArthropodAdapter;
	import com.greensock.plugins.BlurFilterPlugin;
	import com.greensock.plugins.TweenPlugin;
	import com.strattonimaging.site.display.MainView;
	import com.strattonimaging.site.events.ScreenEvent;
	import com.strattonimaging.site.model.Constants;
	import com.strattonimaging.site.model.SiteModel;
	
	import flash.display.MovieClip;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.ui.Mouse;
	
	import net.ored.util.ORedUtils;
	import net.ored.util.Resize;
	
	import nl.demonsters.debugger.MonsterDebugger;
	
	[SWF (width="1000", height="643", backgroundColor="#ffffff", frameRate="30")]
	public class Main extends MovieClip
	{
		private var _mainview										:MainView;
		private var _preloader										:IPreloader;
		private var _m:SiteModel;
		
		//demonster debugger
		private var debugger:MonsterDebugger;
		//master loader
		private var _configLoader									:URLLoader;
		private var _loader											:BigLoader;
		private var _loadList										:XMLList;
		private var _loadState										:String;
		
		public var isInitial										:Boolean = true;
		
		public function Main()
		{
			super();
			if(!stage) addEventListener(Event.ADDED_TO_STAGE,_initialize,false,0,true);
			else _initialize();
			
		}//end constructor
		
		private function _initialize($evt:Event = null):void{
						
			removeEventListener(Event.ADDED_TO_STAGE,_initialize);
			// Init the debuggers
			_setMouseListeners();
			debugger = new MonsterDebugger(this);
			
			//site wide config
			_m = SiteModel.getInstance();
			_m.initialize(stage.loaderInfo);
			
			if(!Environment.IS_IN_BROWSER || !Environment.IS_ON_SERVER){
				ORedUtils.turnOutOn();
				
				Out.status(this,"_initialize(); Main the next generation ");
				Out.warning(this, "!Environment.IS_IN_BROWSER");
				stage.scaleMode = StageScaleMode.NO_SCALE;
				stage.align = StageAlign.TOP_LEFT;
				Resize.setStage(stage);
			}else{
				Out.warning(this, "Environment.IS_IN_BROWSER "+SiteLoader(parent).preloader.mc);
				_preloader = SiteLoader(parent).preloader as IPreloader;
			}
			
			
			_mainview = new MainView(this);
			_mainview.addEventListener(ScreenEvent.REQUEST_LOAD,_loadScreen,false,0,true);
			_mainview.addEventListener(ScreenEvent.REQUEST_LOAD_CANCEL,_loadScreenCancel,false,0,true);

			
			if(_preloader) {
				_preloader.addEventListener(Event.INIT,_preloaderOnAnimateIn,false,0,true);
				_preloader.addEventListener(Event.COMPLETE,_preloaderOnAnimateOut,false,0,true);
				_mainview.addPreloader(_preloader as IPreloader);
			}else Out.warning(this, "NO PRELOADER");
			
			_loadState = Constants.LOAD_STATE_INIT;
			_loadConfigXml();

			TweenPlugin.activate([BlurFilterPlugin]);

		}//end initialize function
		
		/***********************************************************/
		//loading functions
		/***********************************************************/
		//load config xml
		
		private function _loadConfigXml():void{
			_configLoader = new URLLoader();
			
			var configURL:String = _m.baseUrl + Constants.CONFIG_XML_PATH;
			
			Out.debug(this,"Config URL: " + configURL);
			_configLoader.addEventListener(Event.COMPLETE, _onConfigXMLLoaded,false,0,true);			
			_configLoader.load(new URLRequest(configURL));			
		}//end function
		
		private function _onConfigXMLLoaded($evt:Event):void{
			_m.configXml = new XML($evt.target.data);
			_configLoader.removeEventListener(Event.COMPLETE,_onConfigXMLLoaded);		
			_configLoader = null;
			
			// initial load begins here
			_loadState = Constants.LOAD_STATE_INITIAL_ASSETS_BEGIN;
			_loadList = _m.getNodeByType(Constants.CONFIG_LOADABLES, Constants.CONFIG_COMPONENTS).component;
			Out.debug(this,"LOAD_STATE_INITIAL_ASSETS_BEGIN");
			Out.status(this, "_onConfigXMLLoaded :: loadlist.length = "+ _loadList.length());
			if(_loadList.length() > 0) _startLoad();
			else _onFrontloadComplete();
		}//end function
		
		private function _startLoad():void{
			Out.debug(this, "_loadList[n].@id "+_loadList[n].@id);
			_loaderCleanUp();
			_loader = new BigLoader();
			_loader.addEventListener(ProgressEvent.PROGRESS, _onLoadProgress, false, 0, true);
			_loader.addEventListener(Event.COMPLETE, _onComponentLoadComplete, false, 0, true);
			
			var n:uint;
			for (n=0; n < _loadList.length(); n++){
				var swfPath:String = _loadList[n].@swf || "";
				var xmlPath:String = _loadList[n].@xml || "";
				
				if (swfPath != "") _loader.add(_m.getFilePath(swfPath, "swf"), _loadList[n].@id + "_" + Constants.TYPE_SWF);//spits out an id that looks like this "header_swf"
				if (xmlPath != "") _loader.add(_m.getFilePath(xmlPath, "xml", true), _loadList[n].@id + "_" + Constants.TYPE_XML);//spits out an id that looks like this "header_swf"
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
					_m.siteAssets = swf;
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
			Out.status(this,"_onScreenloadComplete(); LOAD_STATE_SCREEN_COMPONENT_BEGIN");
			var lastLoadState:String = _loadState;
			_loadState = Constants.LOAD_STATE_SCREEN_COMPONENT_BEGIN;
			
			_mainview.addEventListener(ProgressEvent.PROGRESS,_onLoadProgress,false,0,true);
			_mainview.addEventListener(Event.COMPLETE,_onLoadScreenSpecificComplete,false,0,true);
			_mainview.loadScreenSpecifics();
		}//end function
		
		private function _onLoadScreenSpecificComplete($evt:Event):void {
			Out.status(this,"_onLoadScreenSpecificComplete() LOAD_STATE_SCREEN_COMPLETE");
			_loadState = Constants.LOAD_STATE_SCREEN_COMPLETE;
			
			if(_preloader)
			 	_preloader.setComplete();
			else 
				_preloaderOnAnimateOut();
		}//end onLoadScreenSpecificComplete function
		
		private function _onFrontloadComplete():void {	
			Out.status(this,"_onFrontloadComplete(); LOAD_STATE_INITIAL_ASSETS_COMPLETE");
			
			_loadState = Constants.LOAD_STATE_INITIAL_ASSETS_COMPLETE;
			
			// force the first screen to load.
			_m.getInitialPath();
			
			
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
			Out.status(this, "loadScreen");
			if(isInitial) isInitial = false;
			else	_createSectionLoader();
			var lastLoadState:String = _loadState;
			
			_loadState = (_loadState == Constants.LOAD_STATE_INITIAL_ASSETS_COMPLETE) ? Constants.LOAD_STATE_INITIAL_SCREEN_BEGIN: Constants.LOAD_STATE_SCREEN_BEGIN;
			_loadList = _m.configXml.loadables.component.(@id == _m.currentScreen);
			
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
			Out.status(this,"_loadScreenCancel(); LOAD_STATE_SCREEN_COMPLETE");
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
		private function _createSectionLoader():void{
			Out.status(this, "createSectionLoader():");
			//making a new preloader
				 	_preloader = _mainview.getSectionLoader();
					//_preloader = SectionLoader(Lib.createMovieClip("sectionLoader", "./swf/site/section_loader.swf"));
					_preloader.addEventListener(Event.INIT,_preloaderOnAnimateIn,false,0,true);
					_preloader.addEventListener(Event.COMPLETE,_preloaderOnAnimateOut,false,0,true);
					_mainview.addPreloader(_preloader);
		}
		private function _preloaderOnAnimateOut($evt:Event = null):void {
			
			Out.status(this,"_preloaderOnAnimateOut");
			
			if(_preloader) {
					_preloader.removeEventListener(Event.INIT,_preloaderOnAnimateIn);
					_preloader.removeEventListener(Event.COMPLETE,_preloaderOnAnimateOut);
					_preloader = null;
					Out.debug(this,"we tried to destroy it, can you see it? ok make a new one");
			}
	
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
			
			if(_preloader) {
				//Out.debug(this, " bl="+$evt.bytesLoaded+" bt="+$evt.bytesTotal+" il="+itemsLoaded+" it="+itemsTotal);
				_preloader.updateProgress($evt.bytesLoaded,$evt.bytesTotal,itemsLoaded,itemsTotal);
			}
		}//end function
// =================================================
// ================ Debug Stuff
// =================================================

		private function _setMouseListeners():void{		
				
			addEventListener( MouseEvent.MOUSE_UP,     _mouse_MOUSEUP_handler );
			addEventListener( MouseEvent.MOUSE_DOWN,   _mouse_MOUSEDOWN_handler );
			addEventListener( MouseEvent.MOUSE_OVER,   _mouse_MOUSEOVER_handler );
			//addEventListener( MouseEvent.CLICK, _checkMouseEventTrail );			
		
		}
		
		private function _checkMouseEventTrail($e:MouseEvent):void{
			var p:* = $e.target;
			while(p){
				Out.debug( this, ">> " + p.name +" : " + p);
				p = p.parent;
			}
			Out.debug( this, " " );
		}
		private function _mouse_MOUSEDOWN_handler($me:MouseEvent):void{
			Mouse.prototype.isDown		=	true;
		}
		
		private function _mouse_MOUSEUP_handler($me:MouseEvent):void{
			Mouse.prototype.isDown		=	false;			
		}
		
		private function _mouse_MOUSEOVER_handler($me:MouseEvent):void{
			Mouse.prototype.currentItem	=	$me.target;
		};


	}//end class
}//end package