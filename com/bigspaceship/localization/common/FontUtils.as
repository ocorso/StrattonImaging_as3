package com.bigspaceship.localization.common
{
	import flash.text.Font;
	import flash.text.FontType;
	
	public class FontUtils
	{
		public function FontUtils()
		{
		}
		
		public static function isEmbedded( $font:Font ):Boolean {
			/**
			 * Check against devide type because since flash 10
			 * there are two embedded types (EMBEDDED and
			 * EMBEDDED_CFF).
			 */
			return $font.fontType != FontType.DEVICE;
		}

	}
}