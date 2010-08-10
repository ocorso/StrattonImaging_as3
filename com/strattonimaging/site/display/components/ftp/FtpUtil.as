package com.strattonimaging.site.display.components.ftp
{
	import com.adobe.serialization.json.JSONDecoder;
	import com.adobe.serialization.json.JSONEncoder;
	import com.bigspaceship.utils.Out;
	import com.dynamicflash.util.Base64;
	import com.strattonimaging.site.Constants;
	import com.strattonimaging.site.events.FtpEvent;
	import com.strattonimaging.site.model.SiteModel;
	
	import fl.data.DataProvider;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;

	public class FtpUtil extends EventDispatcher
	{
		private var _m:SiteModel;
		
		public function FtpUtil(target:IEventDispatcher=null)
		{
			super(target);
			_m = SiteModel.getInstance();
			
		}//end constructor
		public function getDirectory($o:String):void{
			if (_m.ftpUser.auth){
	 			var l:URLLoader		= new URLLoader();
				var req:URLRequest 	= new URLRequest(_m.getBaseURL()+ SiteModel.REFRESH_ROUTE);
				req.method = URLRequestMethod.POST;
				var urlVar:URLVariables = new URLVariables();
				var o:Object = new Object();
				o[Constants.POST_VAR_PATH] = _m.currentDirectory;
			
				Out.debug(this, "we about to getDirectory: "+req.url);
				//here is where we name the url variable, "time_from_flash"
				var toJSON:JSONEncoder = new JSONEncoder(o);
				var json:String = toJSON.getString();
				urlVar.d = Base64.encode(json);
				req.data = urlVar;
				//Out.info(this, "JSON: "+ urlRequest.
				l.addEventListener(Event.COMPLETE, _getDirectoryHandler);
				l.load(req);
			}//end if
			
		}//end get directory
		private function _getDirectoryHandler($evt:Event):void{
			Out.status(this, "got directory!");
			Out.debug(this, "info: "+$evt.target.data);
			var json:JSONDecoder = new JSONDecoder($evt.target.data, true);
			var dp:DataProvider = new DataProvider(json.getValue());
			dispatchEvent(new FtpEvent(FtpEvent.REFRESH, dp));
		}
	}//end class
}//end package