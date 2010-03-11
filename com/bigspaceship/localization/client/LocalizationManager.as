package com.bigspaceship.localization.client
{
	import com.bigspaceship.localization.client.actions.ReplaceTextAction;
	import com.bigspaceship.localization.client.actions.SetLocaleIdAction;
	import com.bigspaceship.localization.client.actions.SetStyleIdAction;
	import com.bigspaceship.localization.client.actions.SetTextAction;
	import com.bigspaceship.localization.client.actions.WrapperAction;
	import com.bigspaceship.localization.client.vo.LanguageVO;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	/**
	 * The LocalizationManager class is a singleton which loads
	 * and initializes all required assets to set text-fields's
	 * text, font and style according to the current language.
	 * 
	 * @author Benjamin Bojko
	 */	
	public class LocalizationManager extends EventDispatcher {
		
		public static var DEBUG:Boolean = true;
		
		//==================================================
		private static var __instance:LocalizationManager;
		
		private var _projectLoader:URLLoader;
		private var _projectXML:XML;
		
		private var _bulkLoadListener:BulkLoadListener;
		
		private var _wrapperManager:WrapperManager;
		private var _languageManager:LanguageManager;
		private var _fontManager:FontManager;
		private var _styleManager:StyleManager;
		
		private var _initialized:Boolean = false;
		
		private var _languageCode:String;
		private var _logFunction:Function = _defaultLogFunction;
		
		
		//==================================================
		// CONSTRUCTOR / SINGLETON
		/**
		 * This constructor cannot be called from outside of this class.
		 * @param $singletonParam
		 */		
		public function LocalizationManager( $singletonParam:SingletonParam ) {
			_projectLoader = new URLLoader();
			_projectLoader.addEventListener( Event.COMPLETE, _projectLoaderComplete );
			_projectLoader.addEventListener( IOErrorEvent.IO_ERROR, _projectLoaderError );
			
			_wrapperManager = new WrapperManager();
			_wrapperManager.addEventListener( Event.INIT, _wrapperQueueInit );
			
			_languageManager = new LanguageManager();
			_fontManager = new FontManager();
			_styleManager = new StyleManager();
			
			_bulkLoadListener = new BulkLoadListener();
			_bulkLoadListener.addEventListener( Event.OPEN, _bulkLoadOpen );
			_bulkLoadListener.addEventListener( Event.COMPLETE, _bulkLoadComplete );
			_bulkLoadListener.addEventListener( ProgressEvent.PROGRESS, _bulkLoadProgress );
			_bulkLoadListener.addEventListener( IOErrorEvent.IO_ERROR, _bulkLoadError );
		}
		
		
		/**
		 * Only one instance allowed.
		 * @return 
		 */		
		public static function getInstance():LocalizationManager {
			if( !__instance ) __instance = new  LocalizationManager( new SingletonParam() );
			return __instance;
		}
		
		
		//==================================================
		// PUBLIC
		/**
		 * Initializes the LocalizationManager and loads the XML at
		 * $projectXmlLocation. When the XML is loaded all text fields
		 * already registered to the manager will be initialized
		 * and a Event.INIT will be fired after that.
		 * 
		 * @param $projectXmlLocation	The path to the project XML file.
		 */
		public function init( $projectXmlLocation:String ):void {
			_projectLoader.load( new URLRequest( $projectXmlLocation ) );
		}
		
		override public function toString():String {
			return "[ LocalizationManager ]";
		}
		
		//==================================================
		// PUBLIC - UTILITY
		/**
		 * Returns the text for that locale Id (if loaded and defined).
		 * @param $id
		 * @return 
		 */		
		public function getLocaleIdText( $localeId:String ):String{
			return _languageManager.getText( $localeId );
		}
		
		
		//==================================================
		// PUBLIC - ACTIONS
		/**
		 * Add an action that will be applied to the text field wrapper
		 * with the action id as soon as a wrapper registers with that id.
		 * 
		 * @param $wrapperAction
		 * 
		 * @return True if the action could be executed immediately because a
		 * text field was already registered to that id, false if no text field
		 * was registered to that id yet and the action could not be executed.
		 */		
		public function addAction( $wrapperAction:WrapperAction ):Boolean {
			return _wrapperManager.addAction( $wrapperAction );
		}
		
		/**
		 * Will set the style id for the wrapper with the assigned ID as soon
		 * as it's initialized.
		 * 
		 * @param $wrapperId
		 * @param $styleId
		 * 
		 * @return True if the action could be executed immediately because a
		 * text field was already registered to that id, false if no text field
		 * was registered to that id yet and the action could not be executed.
		 */	
		public function setStyleId( $wrapperId:String, $styleId:String ):Boolean {
			return _wrapperManager.addAction( new SetStyleIdAction( $wrapperId, $styleId ) );
		}
		
		/**
		 * Will set the locale id for the wrapper with the assigned ID as soon
		 * as it's initialized.
		 * 
		 * @param $wrapperId
		 * @param $localeId
		 * 
		 * @return True if the action could be executed immediately because a
		 * text field was already registered to that id, false if no text field
		 * was registered to that id yet and the action could not be executed.
		 */	
		public function setLocaleId( $wrapperId:String, $localeId:String ):Boolean {
			return _wrapperManager.addAction( new SetLocaleIdAction( $wrapperId, $localeId ) );
		}
		
		/**
		 * Will set the text for the wrapper with the assigned ID as soon
		 * as it's initialized.
		 * 
		 * @param $wrapperId
		 * @param $text
		 * 
		 * @return True if the action could be executed immediately because a
		 * text field was already registered to that id, false if no text field
		 * was registered to that id yet and the action could not be executed.
		 */		
		public function setText( $wrapperId:String, $text:String, $removeLocaleId:Boolean=false ):Boolean {
			return _wrapperManager.addAction( new SetTextAction( $wrapperId, $text, $removeLocaleId ) );
		}
		
		/**
		 * Will replace all entries in $keys with the according entry in $values
		 * for the wrapper with the assigned ID as soon as it's initialized.
		 * 
		 * @param $wrapperId
		 * @param $keys		An Array of either RegExp or String instances.
		 * @param $values	An Array of String instances.
		 * 
		 * @return True if the action could be executed immediately because a
		 * text field was already registered to that id, false if no text field
		 * was registered to that id yet and the action could not be executed.
		 */	
		public function replaceText( $wrapperId:String, $keys:Array, $values:Array ):Boolean {
			return _wrapperManager.addAction( new ReplaceTextAction( $wrapperId, $keys, $values ) );
		}
		
		
		//==================================================
		// PUBLIC - ACCESSORS
		public function get initialized():Boolean					{	return _initialized;			}
		
		/**
		 * If set to true the style manager will check if the fonts
		 * used in a style are embedded or not and set the embedFonts
		 * property of each text field accordingly.
		 * 
		 * If set to false all text fields will have embedFonts set
		 * to true. This may save a little performance during
		 * initialization but it will make usage of system fonts
		 * impossible.
		 */		
		public function get allowSystemFonts():Boolean			{	return _styleManager.checkFontType;	}
		public function set allowSystemFonts($b:Boolean):void	{	_styleManager.checkFontType=$b;		}
		
		public function get loadProgress():Number				{	return _bulkLoadListener.progress;	}
		
		public function get logFunction():Function				{	return logFunction;		}
		public function set logFunction($f:Function):void		{	logFunction = $f;		}
		
		
		/**
		 * Allows the usage of a language other than the user's System's
		 * language or the default language (the first language in the
		 * language XML).
		 * 
		 * <p>The language code must represent the langCode attribute of the
		 * language node inside the project XML. If the langCode is not
		 * found in the XML the LocalizationManager will try to use the
		 * system language. If the system language is also not found in
		 * the XML, the first language node will be used as the default.</p>
		 * 
		 * <p>If the language is changed after the LocalizationManager has
		 * already been initialized, all previously registered wrappers
		 * will be reset and reinitialized with the new language, styles
		 * and fonts. In addition all actions will be reapplied to the
		 * wrappers.</p>
		 * 
		 * <p>If the language is changed while the LocalizationManager is
		 * still loading assets, all loading procedures will be cancelled
		 * and all previously registered wrappers will be reset and
		 * reinitialized with the new language, styles and fonts. In addition
		 * all actions will be reapplied to the wrappers.</p>
		 */		
		public function get languageCode():String				{	return _languageCode;	}
		public function set languageCode($s:String):void		{
			
			// changing language during or after initialization - requires reset
			if( _languageCode!=$s && (_initialized || _bulkLoadListener.progress < 1) ){
				_initialized = false;
				
				_bulkLoadListener.reset();
				_wrapperManager.reset();
				
				_languageManager.cancelLoad();
				_fontManager.cancelLoad();
				_styleManager.cancelLoad();
				
				_languageCode = $s;
				_loadAssets();
				
			// setting language before initialization
			} else {
				_languageCode = $s;
			}
		}
		
		/**
		 * Retrieves all available languages from the project XML.
		 * 
		 * If the project XML is not loaded yet, the function will
		 * return null.
		 * 
		 * @return An Array of LanguageVO or null, if project XML is
		 * not loaded yet.
		 */		
		public function get languages():Array				{
			if( _projectXML ){
				return _languageManager.languages;
			}
			
			return null;
		}
		
		
		//==================================================
		// INTERNAL - UTILITY
		/**
		 * Controls the output of the whole localization package.
		 * @param $msg
		 */		
		internal function log( $msg:Object ):void {
			if( DEBUG ) _logFunction( $msg );
		}
		
		
		//==================================================
		// INTERNAL - ACCESSORS
		internal function get languageManager():LanguageManager		{	return _languageManager;		}
		internal function get fontManager():FontManager				{	return _fontManager;			}
		internal function get styleManager():StyleManager			{	return _styleManager;			}
		internal function get wrapperQueue():WrapperManager			{	return _wrapperManager;			}
		
		
		//==================================================
		// PROTECTED
		/**
		 * Outputs with trace.
		 * @param $msg
		 */	
		protected function _defaultLogFunction( $msg:Object ):void {
			trace( $msg );
		}
		
		/**
		 * Controls the output of this class.
		 * @param $msg
		 */		
		protected function _log( $msg:Object ):void {
			log( this + "\t\t" + $msg );
		}
		
		
		//==================================================
		// PRIVATE - HELPERS
		/**
		 * Loads all the assets defined in the project xml.
		 */		
		private function _loadAssets():void {
			
			_languageManager.init( _projectXML.languages, _languageCode );
			
			var hasText:Boolean		= _languageManager.currentLanguage.textXMLURL && _languageManager.currentLanguage.textXMLURL.length>0;
			var hasFonts:Boolean	= _languageManager.currentLanguage.fontSWFURL && _languageManager.currentLanguage.fontSWFURL.length>0;
			var hasStyles:Boolean	= _languageManager.currentLanguage.styleSheetURL && _languageManager.currentLanguage.styleSheetURL.length>0;
			
			_log( "Starting to load localization assets:" );
			_log( "\tloading text:\t"	+	hasText 	+ (hasText		?	"\t("+_languageManager.currentLanguage.textXMLURL+")"				:"") );
			_log( "\tloading fonts:\t"	+	hasFonts 	+ (hasFonts		?	"\t("+_languageManager.currentLanguage.fontSWFURL+")"				:"") );
			_log( "\tloading styles:\t"	+	hasStyles 	+ (hasStyles	?	"\t("+_languageManager.currentLanguage.styleSheetURL+")"	:"") );
			
			if(hasText)		_bulkLoadListener.add( _languageManager );
			if(hasFonts)	_bulkLoadListener.add( _fontManager );
			if(hasStyles)	_bulkLoadListener.add( _styleManager );
			
			if(hasText)		_languageManager.load( _languageManager.currentLanguage.textXMLURL );
			if(hasFonts)	_fontManager.load( _languageManager.currentLanguage.fontSWFURL );
			if(hasStyles)	_styleManager.load( _languageManager.currentLanguage.styleSheetURL );
			
			if( !hasText && !hasFonts && !hasStyles ){
				_log( "No assets defined for this language. Initializing text field manager to keep things running though." );
				_wrapperManager.init();
			}
		}
		
		
		//==================================================
		// PRIVATE - EVENT HANDLERS
		/**
		 * Project XML loaded.
		 * @param $e
		 */		
		private function _projectLoaderComplete( $e:Event ):void {
			_projectXML = new XML( _projectLoader.data );
			_loadAssets();
		}
		
		
		/**
		 * Project XML load error.
		 * @param $e
		 */		
		private function _projectLoaderError( $e:IOErrorEvent ):void {
			_log("Project file could not be loaded.");
		}
		
		/**
		 * All assets have started their loading process.
		 * @param $e
		 */		
		private function _bulkLoadOpen( $e:Event ):void {
			_log("Started to load all assets.");
		}
		
		/**
		 * Occurs when an asset could not be loaded.
		 * @param $e
		 */	
		private function _bulkLoadError( $e:IOErrorEvent ):void {
			_log("Asset could not be loaded: "+$e.text);
		}
		
		/**
		 * Give information about progress.
		 * @param $e
		 */	
		private function _bulkLoadProgress( $e:Event ):void {
			dispatchEvent( new ProgressEvent(ProgressEvent.PROGRESS, false, false, _bulkLoadListener.bytesLoaded, _bulkLoadListener.bytesTotal) );
		}
		
		/**
		 * All assets have finished loading.
		 * @param $e
		 */	
		private function _bulkLoadComplete( $e:Event ):void {
			_log("All assets loaded successfully");
			_wrapperManager.init();
		}
			
		
		/**
		 * Called when the wrapper queue has been initialized.
		 * @param $e
		 * 
		 */		
		private function _wrapperQueueInit( $e:Event ):void {
			_initialized = true;
			dispatchEvent( new Event( Event.INIT ) );
			_log( "Localization Manager initialized" );
		}
		
		
		
	}
}


internal class SingletonParam {
	
}
