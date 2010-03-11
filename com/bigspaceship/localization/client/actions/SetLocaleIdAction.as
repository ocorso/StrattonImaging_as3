package com.bigspaceship.localization.client.actions
{
	import com.bigspaceship.localization.client.TextFieldWrapper;
	
	/**
	 * STATUS: ALPHA - NOT TESTED YET!
	 * @author Benjamin Bojko
	 */	
	public class SetLocaleIdAction extends WrapperAction
	{
		
		private var _localeId:String;
		
		public function SetLocaleIdAction( $id:String, $localeId:String )
		{
			super($id);
			_localeId = $localeId;
		}
		
		override protected function _execute( $textfieldWrapper:TextFieldWrapper ):void {
			$textfieldWrapper.localeId = _localeId;
		}
		
		override public function toString():String {
			if(id)	return "[ SetLocaleIdAction "+id+" ]";
			else	return "[ SetLocaleIdAction ]";
		}
	}
}