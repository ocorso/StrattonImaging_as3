package com.bigspaceship.localization.client
{
	import com.bigspaceship.localization.common.FontUtils;
	
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	import flash.text.Font;
	import flash.utils.Dictionary;
	
	/**
	 * 
	 * @author Benjamin Bojko
	 */	
	internal class FontManager extends EventDispatcher implements IAssetLoader {
		
		
		private var _fontLoader:Loader;
		private var _fontsMap:Dictionary;	// map of all embedded fonts after font swf is loaded
		
		
		//==================================================
		/**
		 * 
		 */		
		public function FontManager(){
			_fontLoader = new Loader();
			_fontLoader.contentLoaderInfo.addEventListener( Event.COMPLETE, _fontLoaderComplete );
			_fontLoader.contentLoaderInfo.addEventListener( IOErrorEvent.IO_ERROR, _fontLoaderError );
		}
		
		
		//==================================================
		// PUBLIC
		/**
		 * Loads the font swf at $url.
		 */		
		public function load( $url:String ):void {
			if( !$url || $url.length==0 ){
				_log( "No font URL defined - Skipping font loading!" );
				dispatchEvent( new Event( Event.INIT ) );
			} else {
				_fontLoader.load( new URLRequest( $url ) );
			}
		}
		
		
		/**
		 * Cancels the current load operation if loading is still in progress.
		 */
		public function cancelLoad():void {
			if( _fontLoader && _fontLoader.contentLoaderInfo.bytesLoaded < _fontLoader.contentLoaderInfo.bytesTotal ){
				_log( "Cancelling loading..." );
				_fontLoader.close();
			}
		}
		
		
		/**
		 * Checks if the font with $fontName is an embedded font.
		 * @param $fontName
		 * @return True if an embedded, false if a device font.
		 * 
		 */		
		public function isEmbedded( $fontName:String ):Boolean {
			if( _fontsMap && _fontsMap.hasOwnProperty( $fontName ) ){
				/**
				 * compare to device font type because there are
				 * two embedded font types since flash player 10
				 */
				return FontUtils.isEmbedded( _fontsMap[ $fontName ] );
			}
			
			return false;
		}
		
		
		override public function toString():String {
			return "[ FontManager ]";
		}
		
		
		//==================================================
		// PUBLIC - ACCESSORS
		public function get bytesLoaded():uint			{	return _fontLoader.contentLoaderInfo.bytesLoaded;	}
		public function get bytesTotal():uint			{	return _fontLoader.contentLoaderInfo.bytesTotal;	}
		public function get loadEventDispatcher():IEventDispatcher	{	return _fontLoader.contentLoaderInfo;	}
		
		
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
		// PRIVATE - EVENT HANDLERS
		private function _fontLoaderComplete( $e:Event ):void {
			
			_fontsMap = new Dictionary();
			
			// save fonts to dictionary
			var fonts:Array = Font.enumerateFonts(false);
			for( var i:int=0; i<fonts.length; i++ ){
				var font:Font = fonts[i] as Font;
				_fontsMap[ font.fontName ] = font;
			}
			
			dispatchEvent( new Event( Event.INIT ) );
		}
		
		private function _fontLoaderError( $e:IOErrorEvent ):void {
			//_log( $e );
		}
		

	}
}