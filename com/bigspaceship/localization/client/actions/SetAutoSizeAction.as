package com.bigspaceship.localization.client.actions
{
	import com.bigspaceship.localization.client.TextFieldWrapper;
	import com.bigspaceship.localization.common.ASToCSS;
	
	import flash.text.StyleSheet;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	public class SetAutoSizeAction extends WrapperAction
	{
		
		private var _autoSize:Boolean;
		
		/**
		 * 
		 * @param $id
		 * @param $autoSize	If set to true, the TextField's autoSize will
		 * be determined by it's textAlign property. If set to false, the
		 * TextField's autoSize will be defaulted to false.
		 * 
		 * 'right'		is translated to TextFieldAutoSize.RIGHT;
		 * 'justify'	is translated to TextFieldAutoSize.CENTER;
		 * 'center'		is translated to TextFieldAutoSize.CENTER;
		 * 'left'		is translated to TextFieldAutoSize.LEFT;
		 * 
		 * everything else is defaulted to TextFieldAutoSize.LEFT;
		 */
		public function SetAutoSizeAction( $id:String, $autoSize:Boolean )
		{
			super($id);
			_autoSize = $autoSize;
		}
		
		public function get autoSize():Boolean	{	return _autoSize;	}
		
		/**
		 * 
		 * @param $wrapper
		 */		
		override protected function _execute( $wrapper:TextFieldWrapper ):void {
			
			var tf:TextField = $wrapper.textField;
			
			// adjust autoSize to textAlign
			if( _autoSize ){
				
				var stylesheet:StyleSheet = tf.styleSheet;
				
				// create empty stylesheet if none exists yet
				if( !stylesheet ){
					stylesheet = new StyleSheet();
				}
				
				var styleObj:Object = stylesheet.getStyle( $wrapper.styleId );
				
				// create empty style object as dummy if style wasn't found
				if( !styleObj ) {
					styleObj = new Object();
				}
				// create empty textAlign style if it doesn't exist yet
				if( !styleObj[ ASToCSS.AS_TEXT_ALIGN ] ){
					styleObj[ ASToCSS.AS_TEXT_ALIGN ] = "";
				}
				
				var textAlign:String = new String( styleObj[ ASToCSS.AS_TEXT_ALIGN ] );
				
				textAlign = textAlign.toLowerCase();
				textAlign = textAlign.replace( new RegExp(" ","g"), "" );
				
				switch( textAlign ){
					
					case "right":
						tf.autoSize = TextFieldAutoSize.RIGHT;
						break;
						
					case "justify":
					case "center":
						tf.autoSize = TextFieldAutoSize.CENTER;
						break;
						
					case "left":
					default:
						tf.autoSize = TextFieldAutoSize.LEFT;
						break;
					
				}
				
			// disable autoSize
			} else {
				tf.autoSize = TextFieldAutoSize.NONE;
			}
		}
		
		override public function toString():String {
			if(id)	return "[ SetAutoSizeAction "+id+" ]";
			else	return "[ SetAutoSizeAction ]";
		}
		
	}
}