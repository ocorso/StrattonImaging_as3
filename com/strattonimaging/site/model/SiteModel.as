package com.strattonimaging.site.model
{
	import com.asual.swfaddress.SWFAddress;
	import com.asual.swfaddress.SWFAddressEvent;
	import com.bigspaceship.events.NavigationEvent;
	import com.bigspaceship.utils.Environment;
	import com.bigspaceship.utils.Out;
	import com.strattonimaging.site.display.components.ftp.screens.IFtpScreen;
	import com.strattonimaging.site.model.vo.FTPUser;
	
	import flash.display.DisplayObject;
	import flash.display.LoaderInfo;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.system.Capabilities;
	
	import net.ored.util.ORedUtils;
	
	public class SiteModel extends EventDispatcher
	{
		private static var __instance:SiteModel;
		private var _siteAssets								:DisplayObject;
		
		private var _configXml								:XML;
		
		private var _baseUrl								:String;
		private var _flashvars								:Object;
		private var _nextScreen								:String;
		private var _currentScreen							:String; // learn, craft, credits, connect
		//craft stuff
		private var _currentSection							:String; // could be service, credit, which about ect
		private var _currentThumb							:Number;
		
		//ftp stuff
		private var _ftpUser								:FTPUser;
		private var _ftpAuth								:Boolean = false;
		private var _currentDirectory						:String;
		private var _currentFilename						:String;
		private var _currentFtpScreen						:IFtpScreen;
		private var _nextFtpScreen							:IFtpScreen;
		
		
		// =================================================
		// ================ Callable
		// =================================================
		public function getInitialPath():void {
			SWFAddress.addEventListener(SWFAddressEvent.CHANGE,_swfAddressOnChange,false,0,true);			
		}//end function 

		// =================================================
		// ================ Workers
		// =================================================
		public function initialize($loaderInfo:LoaderInfo):void {
			Out.status(this,"initialize();");
			Out.info(this, 'Domain : '+ Environment.DOMAIN);
			if(Capabilities.playerType == "PlugIn" || Capabilities.playerType == "ActiveX"){
			//if(Environment.DOMAIN == "strattonimaging.com"){
				_flashvars = $loaderInfo.parameters;
				_baseUrl =  unescape(getFlashVar("baseUrl")); 
				ORedUtils.printFlashVars(_flashvars);
			}
			else {
				_baseUrl = "http://localhost/";
				currentThumb = 1;
			}			
			Out.info(this, "Here is the base URL: "+ _baseUrl);
			
		}//end function
		
		// =================================================
		// ================ Handlers
		// =================================================
		
		// =================================================
		// ================ Animation
		// =================================================
		
		// =================================================
		// ================ Getters / Setters
		// =================================================
		public static function getInstance():SiteModel { return __instance || (__instance = new SiteModel()); };
		
		public function getFlashVar($id:String):String {
			if(_flashvars[$id] && _flashvars[$id] != "") return _flashvars[$id];
			return null;
		}//end function
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
		
		//ftp 
		public function get ftpAuth():Boolean{return _ftpAuth;}
		public function get ftpUser():FTPUser{return _ftpUser;}
		public function set ftpUser($u:FTPUser):void{ 
			if (_ftpUser){
				_ftpUser.destroy();
				_ftpUser = null;
			}
			
			_ftpUser = $u;
			_ftpAuth = $u.auth;
			_currentDirectory = $u.iPath;
		}
		public function getEmail():String{ return _ftpUser.email;}
		public function get currentDirectory():String{ return _currentDirectory;}
		public function set currentDirectory($p:String):void{ _currentDirectory = $p; Out.info(this, "cd: "+_currentDirectory);}
		public function set currentFilename($filename:String):void{ _currentFilename = $filename;}
		public function get currentFilename():String{ return _currentFilename;}
		public function get fileToDownload():String{ return baseUrl + currentDirectory + _currentFilename;}
		public function get nextFtpScreen():IFtpScreen { return _nextFtpScreen; }
		public function set nextFtpScreen($screenId:IFtpScreen):void { _nextFtpScreen = $screenId; }
		public function get currentFtpScreen():IFtpScreen { return _currentFtpScreen; }
		public function set currentFtpScreen($screenId:IFtpScreen):void { _currentFtpScreen = $screenId; }
			
		// screens
		public function get nextScreen():String { return _nextScreen; }
		public function get currentScreen():String { return _currentScreen; }
		public function set currentScreen($screenId:String):void { _currentScreen = $screenId; }
		public function get currentSection():String { return _currentSection; }
		public function set currentSection($screenId:String):void { _currentSection = $screenId; }
		public function get currentThumb():Number { return _currentThumb; }
		public function set currentThumb($thumbId:Number):void { _currentThumb = $thumbId; }
		
		//vars
		public function get baseUrl():String{ return _baseUrl;}
		
		// =================================================
		// ================ Interfaced
		// =================================================
		
		// =================================================
		// ================ Core Handler
		// =================================================
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
		
		// =================================================
		// ================ Overrides
		// =================================================
		
		// =================================================
		// ================ Constructor
		// =================================================
		
		public function SiteModel(target:IEventDispatcher=null)
		{
			super(target);
		}//end constructor

	}//end class
}