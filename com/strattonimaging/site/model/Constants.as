package com.strattonimaging.site.model
{
	public class Constants
	{
		
		//xml config
		public static const CONFIG_SETTING					:String	= "setting";
		public static const CONFIG_COMPONENTS				:String = "components";
		public static const CONFIG_COMPONENT				:String = "component";
		public static const CONFIG_SCREEN					:String = "screens";
		public static const CONFIG_LOADABLES				:String = "loadables";
		public static const CONFIG_DEFAULTFEATURE			:String = "defaultFeature";
		
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
		
		//header 
		public static const LEARN							:String = "learn";
		public static const CRAFT							:String = "craft";
		public static const CREDITS							:String = "credits";
		public static const CONNECT							:String = "connect";
		//rollover colors
		public static const TINT_GREEN						:uint = 0x009900;
		public static const TINT_YELLOW						:uint = 0xFFFF00;
		public static const TINT_RED						:uint = 0xFF0000;
		public static const TINT_BLUE						:uint = 0x556dff;
		
		
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
		public static const TYPE_VID						:String = "vid";
		
		// screens
		public static const SCREEN_HOME						:String = "home";
		public static const SCREEN_LEARN					:String = "learn";
		public static const SCREEN_CRAFT					:String = "craft";
		public static const SCREEN_CREDITS					:String = "credits";
		public static const SCREEN_CONNECT					:String = "connect";

		//video
		public static const VID_WIDTH						:uint = 576;
		public static const VID_HEIGHT						:uint = 275;
		public static const VID_NAME						:String = "credits.f4v";
		public static const VIDEO_READY						:String = "videoReady";
		
		//ftp POST variable names 
		public static const LOGIN_ANSWER						:String	= "yep";
		public static const LOGIN_FAILURE						:String	= "nope";
		public static const POST_VAR_SUCCESS					:String	= "s";
		public static const POST_VAR_NAME						:String = "n";
		public static const POST_VAR_PATH						:String = "p";
		public static const POST_VAR_EMAIL						:String = "e";
		public static const O_RED_DATA							:String = "ored_data";
		
		//routes
		public static const CONFIG_XML_PATH					:String = "xml/site/config.xml";
		public static const LOGIN_ROUTE						:String = "ftp/login.json";
		public static const REFRESH_ROUTE					:String = "ftp/refresh.json"; 
		public static const UPLOAD_ROUTE					:String = "ftp/upload/"; 

		//ftp screen names
		public static const GET								:String = "get";
		public static const PUT								:String = "put";
		public static const LOGIN							:String = "login";
		public static const DASH							:String = "dashboard";
		public static const TRANSFER						:String = "transfer";
		
		//ftp misc
		public static const PROGRESS_WIDTH					:int = 300;
		public static const FTP_TYPE_FOLDER					:String = "folder";
		public static const FTP_TYPE_FILE					:String = "file";
		public static const FTP_FOLDER_ICON					:String = "img/site/ftp/folder.png";
		public static const FTP_DOC_ICON					:String = "img/site/ftp/document.png";

	}//end class
}//end package