package com.bigspaceship.localization.common
{
	import flash.text.TextFormat;
	
	
	
	/**
	 * Transforms CSS style notations to AS notations.
	 * 
	 * Natively supported styles are:
	 * 
	 *	color  	 color  	Only hexadecimal color values are supported. Named colors (such as blue) are not supported. Colors are written in the following format: #FF0000.
	 *	display 	display 	Supported values are inline, block, and none.
	 *	font-family 	fontFamily 	A comma-separated list of fonts to use, in descending order of desirability. Any font family name can be used. If you specify a generic font name, it is converted to an appropriate device font. The following font conversions are available: mono is converted to _typewriter, sans-serif is converted to _sans, and serif is converted to _serif.
	 *	font-size 	fontSize 	Only the numeric part of the value is used. Units (px, pt) are not parsed; pixels and points are equivalent.
	 *	font-style 	fontStyle 	Recognized values are normal and italic.
	 *	font-weight 	fontWeight 	Recognized values are normal and bold.
	 *	kerning 	kerning 	Recognized values are true and false. Kerning is supported for embedded fonts only. Certain fonts, such as Courier New, do not support kerning. The kerning property is only supported in SWF files created in Windows, not in SWF files created on the Macintosh. However, these SWF files can be played in non-Windows versions of Flash Player and the kerning still applies.
	 *	leading 	leading 	The amount of space that is uniformly distributed between lines. The value specifies the number of pixels that are added after each line. A negative value condenses the space between lines. Only the numeric part of the value is used. Units (px, pt) are not parsed; pixels and points are equivalent.
	 *	letter-spacing 	letterSpacing 	The amount of space that is uniformly distributed between characters. The value specifies the number of pixels that are added after each character. A negative value condenses the space between characters. Only the numeric part of the value is used. Units (px, pt) are not parsed; pixels and points are equivalent.
	 *	margin-left 	marginLeft 	Only the numeric part of the value is used. Units (px, pt) are not parsed; pixels and points are equivalent.
	 *	margin-right 	marginRight 	Only the numeric part of the value is used. Units (px, pt) are not parsed; pixels and points are equivalent.
	 *	text-align 	textAlign 	Recognized values are left, center, right, and justify.
	 *	text-decoration 	textDecoration 	Recognized values are none and underline.
	 *	text-indent 	textIndent 	Only the numeric part of the value is used. Units (px, pt) are not parsed; pixels and points are equivalent.
	 * 
	 * @author Benjamin Bojko
	 */	
	public class ASToCSS
	{
		
		// ACTION SCRIPT NAMES
		public static const AS_COLOR:String					= "color";
		public static const AS_DISPLAY:String				= "display";
		public static const AS_FONT_FAMILY:String			= "fontFamily";
		public static const AS_FONT_SIZE:String				= "fontSize";
		public static const AS_FONT_STYLE:String			= "fontStyle";
		public static const AS_FONT_WEIGHT:String			= "fontWeight";
		public static const AS_KERNING:String				= "kerning";
		public static const AS_LEADING:String				= "leading";
		public static const AS_LETTER_SPACING:String		= "letterSpacing";
		public static const AS_MARGIN_LEFT:String			= "marginLeft";
		public static const AS_MARGIN_RIGHT:String			= "marginRight";
		public static const AS_TEXT_ALIGN:String			= "textAlign";
		public static const AS_TEXT_DECORATION:String		= "textDecoration";
		public static const AS_TEXT_INDENT:String			= "textIndent";
		
		public static const AS_SYSTEM_FONT_FAMILY:String	= "systemFontFamily";
		public static const AS_OFFSET_X:String				= "offsetX";
		public static const AS_OFFSET_Y:String				= "offsetY";
		
		
		// CSS NAMES
		public static const CSS_COLOR:String				= "color";
		public static const CSS_DISPLAY:String				= "display";
		public static const CSS_FONT_FAMILY:String			= "font-family";
		public static const CSS_FONT_SIZE:String			= "font-size";
		public static const CSS_FONT_STYLE:String			= "font-style";
		public static const CSS_FONT_WEIGHT:String			= "font-weight";
		public static const CSS_KERNING:String				= "kerning";
		public static const CSS_LEADING:String				= "leading";
		public static const CSS_LETTER_SPACING:String		= "letter-spacing";
		public static const CSS_MARGIN_LEFT:String			= "margin-left";
		public static const CSS_MARGIN_RIGHT:String			= "margin-right";
		public static const CSS_TEXT_ALIGN:String			= "text-align";
		public static const CSS_TEXT_DECORATION:String		= "text-decoration";
		public static const CSS_TEXT_INDENT:String			= "text-indent";
		
		public static const CSS_SYSTEM_FONT_FAMILY:String	= "system-font-family";
		public static const CSS_OFFSET_X:String				= "offset-x";
		public static const CSS_OFFSET_Y:String				= "offset-y";
		
		
		// AS TO CSS TRANSLATIONS
		public static const PROPERTIES:Array = [
			[AS_COLOR,				CSS_COLOR],
			[AS_DISPLAY,			CSS_DISPLAY],
			[AS_FONT_FAMILY,		CSS_FONT_FAMILY],
			[AS_FONT_SIZE,			CSS_FONT_SIZE],
			[AS_FONT_STYLE,			CSS_FONT_STYLE],
			[AS_FONT_WEIGHT,		CSS_FONT_WEIGHT],
			[AS_KERNING,			CSS_KERNING],
			[AS_LEADING,			CSS_LEADING],
			[AS_LETTER_SPACING,		CSS_LETTER_SPACING],
			[AS_MARGIN_LEFT,		CSS_MARGIN_LEFT],
			[AS_MARGIN_RIGHT,		CSS_MARGIN_RIGHT],
			[AS_TEXT_ALIGN,			CSS_TEXT_ALIGN],
			[AS_TEXT_DECORATION,	CSS_TEXT_DECORATION],
			[AS_TEXT_INDENT,		CSS_TEXT_INDENT],
			[AS_SYSTEM_FONT_FAMILY,	CSS_SYSTEM_FONT_FAMILY],
			[AS_OFFSET_X,			CSS_OFFSET_X],
			[AS_OFFSET_Y,			CSS_OFFSET_Y]
		];
		
		
		// DEFAULTS
		public static const DEFAULT_CSS_COLOR:String				= "#000000";
		public static const DEFAULT_CSS_DISPLAY:String				= "inline";
		public static const DEFAULT_CSS_FONT_FAMILY:String			= "Times New Roman";
		public static const DEFAULT_CSS_FONT_SIZE:String			= "12";
		public static const DEFAULT_CSS_FONT_STYLE:String			= "normal";
		public static const DEFAULT_CSS_FONT_WEIGHT:String			= "normal";
		public static const DEFAULT_CSS_KERNING:String				= "false";
		public static const DEFAULT_CSS_LEADING:String				= "0";
		public static const DEFAULT_CSS_LETTER_SPACING:String		= "0";
		public static const DEFAULT_CSS_MARGIN_LEFT:String			= "0";
		public static const DEFAULT_CSS_MARGIN_RIGHT:String			= "0";
		public static const DEFAULT_CSS_TEXT_ALIGN:String			= "left";
		public static const DEFAULT_CSS_TEXT_DECORATION:String		= "none";
		public static const DEFAULT_CSS_TEXT_INDENT:String			= "0";
		
		public static const DEFAULT_CSS_SYSTEM_FONT_FAMILY:String	= "Times New Roman";
		public static const DEFAULT_CSS_OFFSET_X:String				= "0";
		public static const DEFAULT_CSS_OFFSET_Y:String				= "0";
		
		public static const DEF_CSS_VALUES:Array = [
			[CSS_COLOR,					DEFAULT_CSS_COLOR],
			[CSS_DISPLAY,				DEFAULT_CSS_DISPLAY],
			[CSS_FONT_FAMILY,			DEFAULT_CSS_FONT_FAMILY],
			[CSS_FONT_SIZE,				DEFAULT_CSS_FONT_SIZE],
			[CSS_FONT_STYLE,			DEFAULT_CSS_FONT_STYLE],
			[CSS_FONT_WEIGHT,			DEFAULT_CSS_FONT_WEIGHT],
			[CSS_KERNING,				DEFAULT_CSS_KERNING],
			[CSS_LEADING,				DEFAULT_CSS_LEADING],
			[CSS_LETTER_SPACING,		DEFAULT_CSS_LETTER_SPACING],
			[CSS_MARGIN_LEFT,			DEFAULT_CSS_MARGIN_LEFT],
			[CSS_MARGIN_RIGHT,			DEFAULT_CSS_MARGIN_RIGHT],
			[CSS_TEXT_ALIGN,			DEFAULT_CSS_TEXT_ALIGN],
			[CSS_TEXT_DECORATION,		DEFAULT_CSS_TEXT_DECORATION],
			[CSS_TEXT_INDENT,			DEFAULT_CSS_TEXT_INDENT],
			[CSS_SYSTEM_FONT_FAMILY,	DEFAULT_CSS_SYSTEM_FONT_FAMILY],
			[CSS_OFFSET_X,				DEFAULT_CSS_OFFSET_X],
			[CSS_OFFSET_Y,				DEFAULT_CSS_OFFSET_Y]
		];
		
		
		// METHODS
		/**
		 * Converts AS style property name to CSS property name 
		 * @param asPropertyName	The name of the AS style property
		 * @return	The name of the CSS style property if it could be
		 * transformed, the asPropertyName parameter if it couldn't.
		 */		
		public static function asToCss( $asPropertyName:String ):String {
			for( var i:int=0; i<PROPERTIES.length; i++ ){
				if( PROPERTIES[i][0] == $asPropertyName ){
					return PROPERTIES[i][1];
				}
			}
			//name not found
			return $asPropertyName;
		}
		
		/**
		 * Converts CSS style property name to AS property name 
		 * @param cssPropertyName	The name of the CSS style property
		 * @return	The name of the AS style style property if it could be
		 * transformed, the cssPropertyName parameter if it couldn't.
		 */	
		public static function cssToAs( $cssPropertyName:String ):String {
			for( var i:int=0; i<PROPERTIES.length; i++ ){
				if( PROPERTIES[i][1] == $cssPropertyName ){
					return PROPERTIES[i][0];
				}
			}
			//name not found
			return $cssPropertyName;
		}
		
		/**
		 * Checks if $propertyValue is the default value of $propertyName
		 * @param $propertyName
		 * @param $propertyValue
		 * 
		 */		
		public static function isDefaultValue( $asPropertyName:String, $propertyValue:* ):Boolean {
			for( var i:int=0; i<DEF_CSS_VALUES.length; i++ ){
				if( DEF_CSS_VALUES[i][0] == $asPropertyName ){
					return $propertyValue == DEF_CSS_VALUES[i][1];
				}
			}
			//name not found
			return false;
		}

	}
}







