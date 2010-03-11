package com.bigspaceship.localization.client
{
	import com.bigspaceship.localization.client.vo.LanguageVO;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.system.Capabilities;
	
	/**
	 * The LanguageManager class defines the current language and
	 * parses its settings from the project XML. It also loads and
	 * parses the XLIFF text file and provides methods to apply
	 * that text to text fields.
	 * 
	 * @author Benjamin Bojko
	 */	
	internal class LanguageManager extends EventDispatcher implements IAssetLoader {
		
		
		private var _languageLoader:URLLoader;
		private var _languageXML:XML;
		private var _languages:Array;	// of LanguageVO
		private var _currentLanguage:LanguageVO;
		
		private var _localeMap:Object;
		
		
		//==================================================
		/**
		 * 
		 */		
		public function LanguageManager(){
			_languageLoader = new URLLoader();
			_languageLoader.addEventListener( Event.COMPLETE, _languageLoaderComplete );
			_languageLoader.addEventListener( IOErrorEvent.IO_ERROR, _languageLoaderError );
		}
		
		
		//==================================================
		// PUBLIC
		/**
		 * Sets the current language and loads its text xml.
		 */
		public function init( $languagesXML:XMLList, $defaultLanguage:String=null ):void {
			_languages = new Array();
			
			// check any languages are defined
			if( $languagesXML.language.length() == 0 ){
				_log( "No languages defined in XML!" );
				return;
			}
			
			// get system languages if no default language defined
			if( $defaultLanguage == null ){
				$defaultLanguage = Capabilities.language;
			}
			
			// parse all languages
			for( var i:int=0; i<$languagesXML.language.length(); i++ ){
				var vo:LanguageVO = new LanguageVO( $languagesXML.language[i] );
				
				// check if system language is among the languages
				if( vo.languageCode.toLowerCase() == $defaultLanguage.toLowerCase() ){
					_currentLanguage = vo;
				}
				
				_languages.push( vo );
			}
			
			// if no def language or sys language in array, use first available
			if( _currentLanguage == null ){
				_currentLanguage = _languages[ 0 ] as LanguageVO;
				_log( "Default Language and System Language entries not found in XML - Defaulting to: "+_currentLanguage.languageAlias+" ("+_currentLanguage.languageCode+")" );
			}
		}
		
		
		/**
		 * Loads the current language.
		 */		
		public function load( $url:String ):void {
			_languageLoader.load( new URLRequest( $url ) );
		}
		
		
		/**
		 * Cancels the current load operation if loading is still in progress.
		 */	
		public function cancelLoad():void {
			if( _languageLoader && _languageLoader.bytesLoaded < _languageLoader.bytesTotal ){
				_log( "Cancelling loading..." );
				_languageLoader.close();
			}
		}
		
		
		/**
		 * Returns the text of the current language for
		 * the requested locale id.
		 * @param $localId
		 * @return 
		 */		
		public function getText( $localeId:String ):String {
			if( !_localeMap ) return null;
			if( !_localeMap.hasOwnProperty($localeId) ) return "!-- not defined: \""+$localeId+"\" --!"; 
			return _localeMap[ $localeId ];
		}
		
		
		override public function toString():String {
			return "[ LanguageManager ]";
		}
		
		
		//==================================================
		// PUBLIC - ACCESSORS
		public function get currentLanguage():LanguageVO		{	return _currentLanguage;	}
		public function get languages():Array					{	return _languages;			}
		
		public function get bytesLoaded():uint			{	return _languageLoader.bytesLoaded;	}
		public function get bytesTotal():uint			{	return _languageLoader.bytesTotal;	}
		public function get loadEventDispatcher():IEventDispatcher	{	return _languageLoader;	}
		
		
		//==================================================
		// PROTECTED
		/**
		 * Controls the output of this class.
		 * @param $msg
		 */		
		protected function _log( $msg:Object ):void {
			LocalizationManager.getInstance().log( this + "\t\t" + $msg );
		}
		
		
		//==================================================
		// PRIVATE - HELPERS
		/**
		 * 
		 */
		private function _initCurrentLanguage():void {
			_localeMap = new Object();
			var xml:XML = new XML( _languageLoader.data );
			
			if(xml.name() == "xliff"){
				_parseXliff(xml);
			}else if(xml.@type =='bss-language-file'){
				_parseBssLanguageFile(xml);
			}
			
			dispatchEvent( new Event( Event.INIT ) );
		}
		
		private function _parseBssLanguageFile($xml:XML):void{
			for each( var string:XML in $xml.language.string ){
				_localeMap[ string.@id.toString() ] = string;
			}
		}
		
		private function _parseXliff($xml:XML):void{
			var transUnits:XMLList = $xml.file.body["trans-unit"];
			for each( var transUnit:XML in transUnits ){
				_localeMap[ transUnit.@resname.toString() ] = transUnit.source;
			}
		}
		
		//==================================================
		// PRIVATE - EVENT HANDLERS
		/**
		 * Project XML loaded.
		 * @param $e
		 */		
		private function _languageLoaderComplete( $e:Event ):void {
			_initCurrentLanguage();
		}
		
		/**
		 * Project XML load error.
		 * @param $e
		 */		
		private function _languageLoaderError( $e:IOErrorEvent ):void {
			//_log( $e );
		}

	}
}