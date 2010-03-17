package com.strattonimaging.site.model
{
	import com.asual.swfaddress.SWFAddress;
	import com.asual.swfaddress.SWFAddressEvent;
	import com.bigspaceship.utils.Out;
	
	import flash.display.DisplayObject;
	import flash.display.LoaderInfo;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	public class SiteModel extends EventDispatcher
	{
		private static var __instance:SiteModel;
		private var _siteAssets								:DisplayObject;
		
		private var _configXml								:XML;
		
		public static const CONFIG_XML_PATH					:String = "xml/site/config.xml";
		
		public static const CONFIG_SETTING					:String	= "setting";
		public static const CONFIG_COMPONENTS				:String = "components";
		public static const CONFIG_COMPONENT				:String = "component";
		public static const CONFIG_SCREEN					:String = "screens";
		public static const CONFIG_LOADABLES				:String = "loadables";
		public static const CONFIG_DEFAULTFEATURE			:String = "defaultFeature";
		
		private var _baseUrl								:String;
		private var _flashvars								:Object;
		private var _nextScreen								:String;
		private var _currentScreen							:String;
		
		public function SiteModel(target:IEventDispatcher=null)
		{
			//TODO: implement function
			super(target);
		}//end constructor
		
		public static function getInstance():SiteModel { return __instance || (__instance = new SiteModel()); };
		
		public function getFlashVar($id:String):String {
			if(_flashvars[$id] && _flashvars[$id] != "") return _flashvars[$id];
			return null;
		}//end function
		
		public function initialize($loaderInfo:LoaderInfo):void {
			Out.status(this,"initialize();");
			
			_flashvars = $loaderInfo.parameters;
			_baseUrl = getFlashVar("baseUrl") ? unescape(getFlashVar("baseUrl")) : "http://localhost/";
			logFVs();
			
		}//end function
		/**
		 *this function traces out the flashvars passed into the Main.swf 
		 * 
		 */		
		public function logFVs():void{
			Out.info(this, "Here are the flashvars:");
			Out.debug(this, "-----------------------");
			for (var element:String in _flashvars){
				Out.info(this, element+" : "+_flashvars[element]);	
			}
			Out.debug(this, "-----------------------");
				
		}//end function
		
		public function getInitialPath():void {
			SWFAddress.addEventListener(SWFAddressEvent.CHANGE,_swfAddressOnChange,false,0,true);			
		}//end function 
		
		private function _swfAddressOnChange($evt:SWFAddressEvent):void{
			
		}//end function
	}//end class
}