package com.strattonimaging.site.model
{
	import com.asual.swfaddress.SWFAddress;
	import com.asual.swfaddress.SWFAddressEvent;
	import com.bigspaceship.events.NavigationEvent;
	import com.bigspaceship.utils.Out;
	
	import flash.display.DisplayObject;
	import flash.display.LoaderInfo;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.system.Capabilities;
	
	public class SiteModel extends EventDispatcher
	{
		private static var __instance:SiteModel;
		private var _siteAssets								:DisplayObject;
		
		private var _configXml								:XML;
		
		public static const CONFIG_XML_PATH					:String = "/xml/site/config.xml";
		
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
			
			if(Capabilities.playerType == "PlugIn" || Capabilities.playerType == "ActiveX"){
				_flashvars = $loaderInfo.parameters;
				_baseUrl =  unescape(getFlashVar("baseUrl")); 
				logFVs();
			}
			else _baseUrl = "http://localhost/";
			
			Out.info(this, "Here is the base URL: "+ _baseUrl);
			
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
		
		private function _swfAddressOnChange($evt:SWFAddressEvent):void{
			//  determine deeplink
			Out.status(this,"_swfAddressOnChange();");
			
			var paths:Array = SWFAddress.getPathNames();
			Out.info(this,paths.join("/"));
			
			var screenId:String = "";
			if(paths.length == 0 || paths[0] == "") screenId = _configXml.settings.setting.(@id == "defaultScreen").@value.toString();
			else{
				var prettyURL:String = paths[0];
				var screenNode:XMLList = _configXml.loadables.(@type == "screens").component.(@pretty_url == prettyURL);
				if(screenNode.length() == 0) screenId = _configXml.settings.setting.(@id == "defaultScreen").@value.toString();
				else screenId = screenNode[0].@id;
			}
			
			_nextScreen = screenId;
			Out.info(this,"Current Screen: " + _currentScreen);
			Out.info(this,"Next Screen: " + _nextScreen);
			
			if(_nextScreen != _currentScreen) dispatchEvent(new NavigationEvent(NavigationEvent.NAVIGATE));
			else dispatchEvent($evt);
		}//end function
		
		
		/*******************************************/
		//getter setters
		/*******************************************/
		public function getInitialPath():void {
			SWFAddress.addEventListener(SWFAddressEvent.CHANGE,_swfAddressOnChange,false,0,true);			
		}//end function 
		
		
		//assets
		/**
		 * This function manually constructs a URL for an asset based on the parameters 
		 * @param $path 
		 * @param $type
		 * @param $useAbsolute
		 * @return 
		 * 
		 */		
		public function getFilePath($path:String, $type:String, $useAbsolute:Boolean = false):String{
			var path:String = "";
			if ($useAbsolute) path += _baseUrl;
			path += _configXml.settings.setting.(@id == "path_"+ $type).@value.toString();
			path += $path;
			return path;
		}//end function
		public function getDirPath($type:String):String{ return _configXml.settings.setting.(@id == "path_"+$type).@value; }
		public function get siteAssets():DisplayObject{ return _siteAssets as DisplayObject; }
		public function set siteAssets($mc:DisplayObject):void{ _siteAssets = $mc; }
		
		//xml
		public function get configXml():XML{ return _configXml; };
		public function set configXml($xml:XML):void{ _configXml = $xml; };
		public function getNodeByType($node:String, $att:String):XMLList{ 
			return _configXml.child($node).(@type == $att);
		};
		
		// screens
		public function get nextScreen():String { return _nextScreen; }
		public function get currentScreen():String { return _currentScreen; }
		public function set currentScreen($screenId:String):void { _currentScreen = $screenId; }
		
		//vars
		public function getBaseURL():String{ return _baseUrl;}
		
	}//end class
}