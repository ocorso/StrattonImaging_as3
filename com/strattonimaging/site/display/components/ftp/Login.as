package com.strattonimaging.site.display.components.ftp
{
	import com.adobe.serialization.json.JSONDecoder;
	import com.adobe.serialization.json.JSONEncoder;
	import com.bigspaceship.display.StandardInOut;
	import com.bigspaceship.utils.Out;
	import com.dynamicflash.util.Base64;
	import com.strattonimaging.site.Constants;
	import com.strattonimaging.site.events.FtpEvent;
	import com.strattonimaging.site.model.SiteModel;
	import com.strattonimaging.site.model.vo.FTPUser;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.ui.Keyboard;
	
	import net.ored.util.ObjectToString;
	
	
	public class Login extends StandardInOut
	{
		private var _model				:SiteModel;

		private var _submitLoader		:URLLoader;
        
// =================================================
// ================ Callable
// =================================================
		public function submitLoginHandler($evt:MouseEvent = null):void{
			Out.status(this, "Submit handler::");
			_submitLoader = new URLLoader();
			
			var loginURL:String = _model.getBaseURL() + SiteModel.LOGIN_ROUTE;
			var urlRequest:URLRequest = new URLRequest(loginURL);
			urlRequest.method = URLRequestMethod.POST;
			var urlVar:URLVariables = new URLVariables();
			var usn:String = mc.inputs_mc.utf.text;
			var pwd:String = mc.inputs_mc.ptf.text;
			var regularObject:Object = {};
			regularObject.u = usn;
			regularObject.p = pwd;
			
			Out.debug(this, "we about to request the login, here is usn: "+usn);
			//here is where we name the url variable, "time_from_flash"
			var toJSON:JSONEncoder = new JSONEncoder(regularObject);
			var json:String = toJSON.getString();
			urlVar.d = Base64.encode(json);
			urlRequest.data = urlVar;
			//Out.info(this, "JSON: "+ urlRequest.
			_submitLoader.addEventListener(Event.COMPLETE, _loginHandler);
			_submitLoader.load(urlRequest);
		}//end function submitHandler
// =================================================
// ================ Workers
// =================================================
        
// =================================================
// ================ Handlers
// =================================================
		private function _keyEventHandler($ke:KeyboardEvent):void{	
			if ($ke.charCode == Keyboard.ENTER){
				Out.status(this, "Enter");
				submitLoginHandler();			
			}//end if
				
		}//end function
		
        private function _loginHandler($evt:Event):void{
			Out.status(this, "loginHandler, here is the response: "+$evt.target.data);
			var json:JSONDecoder = new JSONDecoder(Base64.decode($evt.target.data), false);
			ObjectToString.o(json.getValue());
			
			_model.ftpUser = new FTPUser(json.getValue());
			if (!_model.ftpUser.auth) {
				mc.inputs_mc.utf.text = "";
				mc.inputs_mc.ptf.text = "";
				mc.loginError_mc.visible = true;
				
			}
			else{
				mc.inputs_mc.utf.text = "";
				mc.inputs_mc.ptf.text = "";
				
				mc.loginError_mc.visible = false;
				dispatchEvent(new FtpEvent(FtpEvent.LOGIN));
			} 
		}//end function
// =================================================
// ================ Animation
// =================================================
        
// =================================================
// ================ Getters / Setters
// =================================================
        
// =================================================
// ================ Interfaced
// =================================================
        
// =================================================
// ================ Core Handler
// =================================================
        
// =================================================
// ================ Overrides
// =================================================
    	override protected function _onAnimateOut():void{
				mc.loginError_mc.visible = false;
				mc.stage.removeEventListener(KeyboardEvent.KEY_UP, _keyEventHandler);
    		
    	}    
    	override protected function _onAnimateIn():void{
    		mc.stage.addEventListener(KeyboardEvent.KEY_UP, _keyEventHandler);
    	}
// =================================================
// ================ Constructor
// =================================================

		public function Login($mc:MovieClip, $useWeakReference:Boolean=false)
		{
			super($mc, $useWeakReference);
			_model = SiteModel.getInstance();
		}
		
	}
}