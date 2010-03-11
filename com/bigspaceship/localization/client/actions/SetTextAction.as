package com.bigspaceship.localization.client.actions
{
	import com.bigspaceship.localization.client.TextFieldWrapper;
	
	/**
	 * STATUS: ALPHA - NOT TESTED YET!
	 * @author Benjamin Bojko
	 */	
	public class SetTextAction extends WrapperAction
	{
		
		private var _text:String;
		private var _removeLocaleId:Boolean;
		
		public function SetTextAction( $id:String, $text:String, $removeLocaleId:Boolean=false )
		{
			super($id);
			_text = $text;
			_removeLocaleId = $removeLocaleId;
		}
		
		override protected function _execute( $textfieldWrapper:TextFieldWrapper ):void {
			if( _removeLocaleId ) $textfieldWrapper.localeId = null;
			$textfieldWrapper.text = _text;
			$textfieldWrapper.init();
		}
		
		override public function toString():String {
			if(id)	return "[ SetTextAction "+id+" ]";
			else	return "[ SetTextAction ]";
		}
	}
}