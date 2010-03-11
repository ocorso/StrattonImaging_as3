package com.bigspaceship.localization.client
{
	import com.bigspaceship.localization.common.ASToCSS;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.text.StyleSheet;
	import flash.text.TextField;
	
	/**
	 * 
	 * @author Benjamin Bojko
	 */	
	internal class StyleManager extends EventDispatcher implements IAssetLoader {
		
		
		private var _cssLoader:URLLoader;
		private var _styleSheet:StyleSheet;
		private var _checkFontType:Boolean = true;
		private var _checkNestedSpans:Boolean = true;
		
		
		//==================================================
		/**
		 * 
		 */		
		public function StyleManager(){
			_cssLoader = new URLLoader();
			_cssLoader.addEventListener( Event.COMPLETE, _cssLoaderComplete );
			_cssLoader.addEventListener( IOErrorEvent.IO_ERROR, _cssLoaderError );
		}
		
		
		//==================================================
		// PUBLIC
		/**
		 * Starts loading the stylesheet.
		 * @param $url The URL of the stylesheet.
		 */
		public function load( $url:String ):void {
			_cssLoader.load( new URLRequest( $url ) );
		}
		
		
		/**
		 * Cancels the current load operation if loading is still in progress.
		 */	
		public function cancelLoad():void {
			if( _cssLoader && _cssLoader.bytesLoaded < _cssLoader.bytesTotal ){
				_log( "Cancelling loading..." );
				_cssLoader.close();
			}
		}
		
		
		/**
		 * Applies a style from the current style sheet to
		 * a text field wrapper.
		 * 
		 * @param $wrapper
		 * @param $styleClass
		 * @param $text	Optional. If left out, the wrapper's text field's
		 * text will be used instead.
		 */		
		public function applyStyle( $wrapper:TextFieldWrapper, $styleClass:String, $text:String=null ):void {
			
			if( !_styleSheet ) return;
			
			var tf:TextField = $wrapper.textField;
			var styleObj:Object = _styleSheet.getStyle( $styleClass );
			
			if( $text==null )		$text = $wrapper.text;
			
			// set embedFonts
			if( _checkFontType ){
				// get font name and check if the font is embedded
				
				if( styleObj && styleObj.fontFamily ){
					var fontName:String = styleObj.fontFamily;
					tf.embedFonts = LocalizationManager.getInstance().fontManager.isEmbedded( fontName );
					
				} else {
					tf.embedFonts = false;
				}
				
			} else {
				tf.embedFonts = true;
			}
			
			// apply custom styles
			_applyCustomStyleProperties( $wrapper, styleObj );
			
			// remove "." from style class name
			if( $styleClass.charAt(0)=="." ){
				$styleClass = $styleClass.substr( 1 );
			}
			
			tf.styleSheet = _styleSheet;
			tf.htmlText = "<span class=\""+$styleClass+"\">" + $text + "</span>";
		}
		
		
		/**
		 * Checks if this style is contained in the style sheet.
		 * @param $styleClass
		 * @return 
		 */		
		public function hasStyle( $styleName:String ):Boolean {
			return (_styleSheet) ? _styleSheet.getStyle( $styleName ) != null : false;
		}
		
		override public function toString():String {
			return "[ StyleManager ]";
		}	
		
		
		//==================================================
		// PUBLIC - ACCESSORS
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
		public function get checkFontType():Boolean				{	return _checkFontType;		}
		public function set checkFontType($b:Boolean):void		{	_checkFontType=$b;			}
		
		public function get bytesLoaded():uint				{	return _cssLoader.bytesLoaded;	}
		public function get bytesTotal():uint				{	return _cssLoader.bytesTotal;	}
		public function get loadEventDispatcher():IEventDispatcher		{	return _cssLoader;	}
		
		
		//==================================================
		// PROTECTED
		/**
		 * Controls the output of this class.
		 * @param $msg
		 */		
		protected function _log( $msg:Object ):void {
			LocalizationManager.getInstance().log( this + "\t\t" + $msg );
		}
		
		/**
		 * Contains the logic that evaluates custom styles like
		 * offset x and y.
		 * 
		 * @param $textField
		 * @param $styleObj
		 */		
		protected function _applyCustomStyleProperties( $wrapper:TextFieldWrapper, $styleObj:Object ):void {
			if( !$styleObj ) return;
			
			if( $styleObj.hasOwnProperty( ASToCSS.AS_OFFSET_X ) ){
				$wrapper.offsetX = parseFloat( $styleObj[ ASToCSS.AS_OFFSET_X ] );
			}
			
			if( $styleObj.hasOwnProperty( ASToCSS.AS_OFFSET_Y ) ){
				$wrapper.offsetY = parseFloat( $styleObj[ ASToCSS.AS_OFFSET_Y ] );
			}
		}
		
		
		//==================================================
		// PRIVATE - EVENT HANDLERS
		/**
		 * 
		 * @param $e
		 */		
		private function _cssLoaderComplete( $e:Event ):void {
			_styleSheet = new StyleSheet();
			_styleSheet.parseCSS( _cssLoader.data );
			dispatchEvent( new Event( Event.INIT ) );
		}
		
		/**
		 * 
		 * @param $e
		 */		
		private function _cssLoaderError( $e:IOErrorEvent ):void {
			//_log( $e );
		}
		
		

	}
	
	
	
}









