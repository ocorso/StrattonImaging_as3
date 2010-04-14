package com.strattonimaging.site
{
	public class Constants
	{
		//stage
		public static const STAGE_WIDTH						:int = 980;
		public static const STAGE_HEIGHT					:int = 643;
		
		//load states
		public static const LOAD_STATE_INIT						:String 		= "init";
		public static const LOAD_STATE_INITIAL_ASSETS_BEGIN		:String			= "initialLoadAssetsInit";
		public static const LOAD_STATE_INITIAL_ASSETS_COMPLETE	:String			= "initialLoadAssetsLoaded";
		public static const LOAD_STATE_INITIAL_SCREEN_BEGIN		:String			= "initialLoadScreenBegin";
		public static const LOAD_STATE_SCREEN_BEGIN				:String			= "screenLoadBegin";
		public static const LOAD_STATE_SCREEN_COMPLETE			:String			= "screenLoadComplete";
		public static const LOAD_STATE_SCREEN_COMPONENT_BEGIN	:String			= "screenComponentLoadBegin";
		
		//positioning
		public static const BOTTOM_OFFSET					:int = 389;
		
		public static const LAYERS_BACKGROUND				:int = 0;
		public static const LAYERS_SCREEN					:int = 1;
		public static const LAYERS_FOOTER					:int = 2;
		public static const LAYERS_HEADER					:int = 3;
		public static const LAYERS_LOADER					:int = 4;
		public static const LAYERS_LOADER_2					:int = 5;
		public static const LAYERS_FTPCLIENT				:int = 6;
		
		public static const LAYERS_TOTAL					:int = 7;
		
		//components
		public static const COMPONENT_HEADER				:String = "header";
		public static const COMPONENT_FOOTER				:String = "footer";
		public static const COMPONENT_FTP					:String = "ftpclient";
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
		public static const SCREEN_CREDITS					:String = "credits";
		public static const SCREEN_CONNECT					:String = "connect";

		
	}
}