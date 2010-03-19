package com.strattonimaging.site
{
	public class Constants
	{
		public static const STAGE_WIDTH						:int = 980;
		public static const STAGE_HEIGHT					:int = 742;
		
		public static const LAYERS_BACKGROUND				:int = 1;
		public static const LAYERS_NAV						:int = 2;
		public static const LAYERS_HEADER					:int = 3;
		public static const LAYERS_FOOTER					:int = 4;
		public static const LAYERS_SCREEN					:int = 5;
		public static const LAYERS_FTPCLIENT				:int = 6;
		public static const LAYERS_LOADER					:int = 7;
		public static const LAYERS_LOADER_2					:int = 8;
		public static const LAYERS_BACKGROUND_SQUARE		:int = 0;
		
		public static const LAYERS_TOTAL					:int = 9;
		
		//components
		public static const COMPONENT_HEADER				:String = "header";
		public static const COMPONENT_FOOTER				:String = "footer";
		public static const COMPONENT_NAV					:String = "nav";
		public static const COMPONENT_TICKER				:String = "featureTicker";
		public static const COMPONENT_BACKGROUND			:String = "background";
		public static const COMPONENT_AUDIO					:String = "audio";
		public static const COMPONENT_ASSETS				:String = "assets";
		public static const COMPONENT_SECTION_LOADER		:String = "loader";
		
		//types
		public static const TYPE_XML						:String = "xml";
		public static const TYPE_SWF						:String = "swf";
		public static const TYPE_IMG						:String = "img";
		
		// screens
		public static const SCREEN_HOME						:String = "home";
		public static const SCREEN_LEARN					:String = "learn";
		public static const SCREEN_CRAFT					:String = "craft";
		
		//feature titles
		public static const FEATURE_CONTRADICTIONARY		:String = "contradictionary";
		
		//assets
		public static const ASSET_CYCLE_LOADER				:String = "cycle_loader";
		public static const ASSET_CYCLER_COMPLETE			:String = "cycler_complete";
		
		/***********************************************************/
		//audio
		/***********************************************************/
		//Header
		public static const AUDIO_FAN_ROLL					:String = "fan_roll";
		public static const AUDIO_LOGIN_ROLL				:String = "login_roll";
		public static const AUDIO_NAV_ROLL					:String = "main_nav_roll";
		
		//Contradictionary
		public static const AUDIO_NEXT_ROLL					:String = "next_roll";
		public static const AUDIO_PREV_ROLL					:String = "prev_roll";
		public static const AUDIO_THUMBS_UP					:String = "thumb_up";
		public static const AUDIO_THUMBS_DOWN				:String = "thumb_down";
		public static const AUDIO_CONTRA_PERS_BTN			:String = "fan_roll";
		public static const AUDIO_CONTRA_SUBMIT				:String = "thumb_up";
		public static const AUDIO_TOP10_BTN					:String = "next_roll";
		public static const AUDIO_BG_OPEN					:String = "rating_bg";
		
		//Products
		public static const AUDIO_PROD_ROLL1				:String = "prod_roll1";
		public static const AUDIO_PROD_ROLL2				:String = "prod_roll2";
		public static const AUDIO_PROD_ROLL3				:String = "prod_roll3";
		public static const AUDIO_PROD_ROLL4				:String = "prod_roll4";
		public static const AUDIO_PROD_ROLL5				:String = "prod_roll5";
		public static const AUDIO_PROD_NAV					:String = "main_nav_roll";
		public static const AUDIO_CANDY_ROLL				:String = "weee_bit";
		public static const AUDIO_NUTRITION					:String = "next_roll";
		
		public static const AUDIO_PRODNAV_ARR				:Array = new Array(AUDIO_PROD_ROLL1,
			AUDIO_PROD_ROLL2,
			AUDIO_PROD_ROLL3,
			AUDIO_PROD_ROLL4,
			AUDIO_PROD_ROLL5);
		
		//Video
		public static const AUDIO_VID_NEXT					:String = "next_roll";
		public static const AUDIO_VID_NAV					:String = "weee_bit";
		
	}
}