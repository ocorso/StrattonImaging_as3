package com.bigspaceship.localization.client.vo
{
	
	/**
	 * 
	 * @author Benjamin Bojko
	 */	
	public class LanguageVO {
		
		public var languageCode:String;
		public var languageAlias:String;
		public var textXMLURL:String;
		public var fontSWFURL:String;
		public var styleSheetURL:String;
		
		/**
		 * 
		 * @param $languageXML
		 */		
		public function LanguageVO( $languageXML:XML ) {
			languageCode = $languageXML.@languageCode;
			languageAlias = $languageXML.@alias;
			textXMLURL = $languageXML.text_xml;
			fontSWFURL = $languageXML.font_swf;
			styleSheetURL = $languageXML.stylesheet;
		}

	}
}