package com.bigspaceship.localization.client.actions
{
	import com.bigspaceship.localization.client.TextFieldWrapper;
	
	import flash.events.Event;
	import flash.text.TextField;
	
	/**
	 * STATUS: ALPHA - NOT TESTED YET!
	 * @author Benjamin Bojko
	 */	
	public class ReplaceTextAction extends WrapperAction
	{
		
		private var _keys:Array;
		private var _values:Array;
		private var _autoUpdate:Boolean;
		
		/**
		 * 
		 * @param $id
		 * @param $keys
		 * @param $values
		 * @param $autoUpdate	Adds an Event.INIT event listener to the text field wrapper to keep track of text changes.
		 */			
		public function ReplaceTextAction( $id:String, $keys:Array, $values:Array, $autoUpdate:Boolean=true )
		{
			super($id);
			_keys = $keys;
			_values = $values;
			_autoUpdate = $autoUpdate;
		}
		
		
		/**
		 * 
		 * @param $textfieldWrapper
		 * 
		 */		
		override protected function _execute( $textfieldWrapper:TextFieldWrapper ):void {
			
			if( _autoUpdate ){
				$textfieldWrapper.addEventListener( Event.INIT, _wrapperInit, false, 0, true );
			}
			
			// replace text
			if( _keys && _values ){
				
				// compare number of keys and values
				if( _keys.length == _values.length ){
					
					var textField:TextField = $textfieldWrapper.textField;
					//var htmlText:String = textField.htmlText;
					//var text:String = textField.text;
					var text:String = textField.htmlText;
					
					// replace all occuracens of key by value
					for( var i:int=0; i<_keys.length; i++ ){
						text = text.replace( _keys[i], _values[i] );
					}
					
					// set changed text
					textField.htmlText = text;
					
				// number of keys and values does not match
				} else {
					_log( "Number of variables to replace does not match number of values. Not replacing anything." );
				}
				
			} else {
				_log( "Could not replace text because either no keys or no values were defined." );
			}
		}
		
		
		override public function toString():String {
			if(id)	return "[ ReplaceTextAction "+id+" ]";
			else	return "[ ReplaceTextAction ]";
		}
		
		/**
		 * 
		 * @param $e
		 */		
		protected function _wrapperInit( $e:Event ):void {
			if($e.target==wrapper) applyTo( wrapper );
			else $e.target.removeEventListener( $e.type, _wrapperInit );
		}
	}
}