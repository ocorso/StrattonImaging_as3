package com.bigspaceship.localization.client.actions
{
	import com.bigspaceship.localization.client.TextFieldWrapper;
	
	/**
	 * STATUS: ALPHA - NOT TESTED YET!
	 * @author Benjamin Bojko
	 */	
	public class SetStyleIdAction extends WrapperAction
	{
		
		private var _styleId:String;
		
		public function SetStyleIdAction( $id:String, $styleId:String )
		{
			super($id);
			_styleId = $styleId;
		}
		
		override protected function _execute( $textfieldWrapper:TextFieldWrapper ):void {
			$textfieldWrapper.styleId = _styleId;
		}
		
		
		override public function toString():String {
			if(id)	return "[ SetStyleIdAction "+id+" ]";
			else	return "[ SetStyleIdAction ]";
		}
		
	}
}