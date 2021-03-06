package com.strattonimaging.site.display
{
	import __AS3__.vec.Vector;
	
	import com.asual.swfaddress.SWFAddressEvent;
	import com.bigspaceship.display.AnimationState;
	import com.bigspaceship.display.IPreloader;
	import com.bigspaceship.display.Standard;
	import com.bigspaceship.events.AnimationEvent;
	import com.bigspaceship.events.NavigationEvent;
	import com.bigspaceship.utils.Lib;
	import com.bigspaceship.utils.Out;
	import com.bigspaceship.utils.SimpleSequencer;
	import com.strattonimaging.site.display.components.Background;
	import com.strattonimaging.site.display.components.Footer;
	import com.strattonimaging.site.display.components.Header;
	import com.strattonimaging.site.display.components.ftp.FtpClient;
	import com.strattonimaging.site.display.screens.Connect;
	import com.strattonimaging.site.display.screens.Home;
	import com.strattonimaging.site.display.screens.Learn;
	import com.strattonimaging.site.display.screens.Screen;
	import com.strattonimaging.site.display.screens.craft.Craft;
	import com.strattonimaging.site.display.screens.credits.Credits;
	import com.strattonimaging.site.events.ScreenEvent;
	import com.strattonimaging.site.model.Constants;
	import com.strattonimaging.site.model.SiteModel;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.utils.Dictionary;
	
	import net.ored.util.Resize;

	public class MainView extends Standard
	{
		private var _layers					:Vector.<Sprite>;
		private var _screens				:Dictionary;
		
		private var _header					:Header;
		private var _footer					:Footer;
		private var _ftp					:FtpClient;
		private var _background				:Background;
		private var _sl						:MovieClip;
		
		private var _m						:SiteModel;
		
		private var _sequencer				:SimpleSequencer;
		
		private var _screenNext				:String;
		private var _screenLoading			:String;
		
		
		private var _isInitialIn			:Boolean = true;
		
		//is the preloader in?
		private var _bPreloaderIn			:Boolean;
		
		public function MainView($mc:MovieClip, $useWeakReference:Boolean=false)
		{
			super($mc, $useWeakReference);
			
			//setup variable
			_m = SiteModel.getInstance();
			_m.addEventListener(SWFAddressEvent.CHANGE,_screenOnURLChange,false,0,true);
			_m.addEventListener(NavigationEvent.NAVIGATE,_goToNextScreen,false,0,true);
		
			_layers = new Vector.<Sprite>(Constants.LAYERS_TOTAL);
			_screens = new Dictionary();
			
			for(var i:int=0;i<Constants.LAYERS_TOTAL;i++) {
				_layers[i] = new Sprite();	
				_mc.addChild(_layers[i]);
			}
			
			_mc.stage.addEventListener(Event.RESIZE,Resize.onResize,false,0,true);
			
		}//end constructor
		
		/***********************************************************/
		//loading functions
		/***********************************************************/
		// this is called when a screen is in the middle of loading custom stuff and the user clicks to a different screen. rather than cancel load let's just ignore future loads for the time being.
		public function cancelLoadScreenSpecifics():void {
			if(_screenLoading && _screens[_screenLoading]) {
				_screens[_screenLoading].removeEventListener(ProgressEvent.PROGRESS,dispatchEvent);
				_screens[_screenLoading].removeEventListener(Event.COMPLETE,dispatchEvent);
			}
			_screenLoading = null;	
		}
		
		public function loadScreenSpecifics():void {	
			Out.status(this, "loadScreenSpecifics");
			_screenLoading = _m.currentScreen;
			_screens[_screenLoading].addEventListener(ProgressEvent.PROGRESS,dispatchEvent,false,0,true);
			_screens[_screenLoading].addEventListener(Event.COMPLETE,dispatchEvent,false,0,true);
			_screens[_screenLoading].beginCustomLoad();
		}
		public function get isNextScreenLoaded():Boolean { return _screens[_m.nextScreen] != null; }
		
		public function addAsset($id:String,$swf:MovieClip,$xml:XML):void
		{
			switch($id)
			{
				case Constants.COMPONENT_BACKGROUND:
					_background = new Background($swf);
					_layers[Constants.LAYERS_BACKGROUND].addChild(_background.mc);
					break;
				case Constants.COMPONENT_FOOTER:
					_footer = new Footer($swf,$xml);
					_layers[Constants.LAYERS_FOOTER].addChild(_footer.mc);
					break;
				case Constants.COMPONENT_HEADER:
					_header = new Header($swf,$xml);
					_layers[Constants.LAYERS_HEADER].addChild(_header.mc);
					break;
				case Constants.COMPONENT_FTP:
					_ftp = new FtpClient($swf,$xml);
					_layers[Constants.LAYERS_FTPCLIENT].addChild(_ftp.mc);
					break;
				case Constants.COMPONENT_SECTION_LOADER:
					Out.debug(this, "adding sl");
					_sl = Lib.createMovieClip("com.strattonimaging.site.display.components.SectionLoader", $swf);
					_layers[Constants.LAYERS_LOADER].addChild(_sl);
					break;
				
				/*
				TODO: Create these other components and screens
				
				case Constants.COMPONENT_AUDIO:
					var _audio:AudioManager = AudioManager.getInstance();
					_audio.addAudioLibrary(Constants.COMPONENT_AUDIO,$swf);
					break;	*/			
			}
		}//end function add components 
		public function addPreloader($preloader:IPreloader):void { 
			Out.status(this, "addPreloader():");
			
			_layers[Constants.LAYERS_LOADER_2].addChild($preloader.mc);
		}
		public function getSectionLoader():IPreloader { return _sl as IPreloader; }
		public function addScreen($id:String,$swf:MovieClip,$xml:XML):void
		{
			switch($id){
				
				case Constants.SCREEN_HOME:
					_screens[$id] = new Home($swf,$xml);
					break;
				case Constants.SCREEN_LEARN:
					_screens[$id] = new Learn($swf,$xml);
					break;
				case Constants.SCREEN_CRAFT:
					_screens[$id] = new Craft($swf,$xml);
					_m.siteAssets = $swf;
					break;
				case Constants.SCREEN_CREDITS:
					_screens[$id] = new Credits($swf,$xml);
					break;
				case Constants.SCREEN_CONNECT:
					_screens[$id] = new Connect($swf,$xml);
					break;
			
				
				default:	
					Out.warning(this,"No Screen with this ID: " + $id + ". Using StandardInOutXML.");
					_screens[$id] = new Screen($swf,$xml);
					break;
			}
			
			_layers[Constants.LAYERS_SCREEN].addChild(_screens[$id].mc);
		}//end function add screen
		
		/***********************************************************/
		//animation functions
		/***********************************************************/
		public function _goToNextScreen($evt:NavigationEvent = null):void {
			Out.status(this, "_goToNextScreen");
			//Out.debug(this, "current screen state: "+_screens[_m.currentScreen].state);
			if(!_sequencer) {
				if(!_screens[_m.currentScreen] || _screens[_m.currentScreen].state == AnimationState.OUT) _screenOnAnimateOut();
				else if(_screens[_m.currentScreen].state == AnimationState.IN) _animateScreenOut();
			}
		}//end function
		
		public function screenOnLoaded():void {
			Out.status(this, "screenOnLoaded(): _bPreloaderIn: "+_bPreloaderIn);
			_bPreloaderIn = false;
			cancelLoadScreenSpecifics();
			_screenOnAnimateOut();
		}
		
		private function _animateScreenOut():void {
			Out.status(this,"_animateScreenOut();");
			
			_sequencer = new SimpleSequencer("out");
			_sequencer.addEventListener(Event.COMPLETE,_screenOnAnimateOut,false,0,true);			
			_sequencer.addStep(1,_screens[_m.currentScreen],_screens[_m.currentScreen].animateOut,AnimationEvent.OUT, {$forceAnim:true});
			
			_sequencer.start();
		}//end function
		
		private function _screenOnAnimateOut($evt:Event = null):void {
			Out.status(this,"_screenOnAnimateOut();");
			_destroySequencer();
			
			_m.currentScreen = _m.nextScreen;
			
			if(_screens[_m.currentScreen]) {
				
				if(_bPreloaderIn) dispatchEvent(new ScreenEvent(ScreenEvent.REQUEST_LOAD_CANCEL));
				else _animateScreenIn();
			}
			else {
				_bPreloaderIn = true;
				dispatchEvent(new ScreenEvent(ScreenEvent.REQUEST_LOAD));
			}
		}//end function
		
		private function _animateScreenIn():void{
			Out.status(this,"_animateScreenIn();");
			
			cancelLoadScreenSpecifics();
			
			_sequencer = new SimpleSequencer("in");
			_sequencer.addEventListener(Event.COMPLETE,_screenOnAnimateIn,false,0,true);
			
			if(_isInitialIn) {
				_isInitialIn = false;
				Out.info(this, "_animateScreenIn THE FIRST TIME ONLY");
				_sequencer.addStep(1,_background,_background.animateIn,AnimationEvent.IN);
				_sequencer.addStep(2,_footer,_footer.animateIn,AnimationEvent.IN);
				_sequencer.addStep(3,_header,_header.animateIn,AnimationEvent.IN);	
				_sequencer.addStep(4,_ftp,_ftp.animateIn,AnimationEvent.IN);	
			}
			
			_header.setActiveScreen();
			
			_sequencer.addStep(4,_screens[_m.currentScreen],_screens[_m.currentScreen].animateIn,AnimationEvent.IN);
			_sequencer.start();			
		}
		
		private function _screenOnAnimateIn($evt:Event):void {
			Out.status(this,"_screenOnAnimateIn();");
			_destroySequencer();
			if(_m.nextScreen != _m.currentScreen) _goToNextScreen();
		
		}		
		
		private function _screenOnURLChange($evt:Event):void {
			if(_screens[_m.currentScreen]) _screens[_m.currentScreen].onURLChange();	
		}//end function
		
		/***********************************************************/
		//cleanup functions
		/***********************************************************/
		private function _destroySequencer():void{
			if(_sequencer) {
				_sequencer.removeEventListener(Event.COMPLETE,_screenOnAnimateIn);
				_sequencer.removeEventListener(Event.COMPLETE,_screenOnAnimateOut);
				_sequencer = null;
			}
		}//end function
	}//end class
}//end package