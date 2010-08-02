package com.strattonimaging.site.display.components.ftp
{
	import com.bigspaceship.display.StandardInOut;
	import com.bigspaceship.utils.Out;
	import com.strattonimaging.site.events.FtpEvent;
	import com.strattonimaging.site.model.SiteModel;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;

	public class Login extends StandardInOut
	{
		private var _model				:SiteModel;
		//ftp specific 
		private const LOGIN_ROUTE		:String 		= "/ftp/login.xml";
		private var _submitLoader		:URLLoader;
        
// =================================================
// ================ Callable
// =================================================
		public function submitLoginHandler($evt:MouseEvent):void{
			Out.status(this, "Submit handler::");
			_submitLoader = new URLLoader();
			
			var loginURL:String = _model.getBaseURL() + LOGIN_ROUTE;
			var urlRequest:URLRequest = new URLRequest(loginURL);
			urlRequest.method = URLRequestMethod.POST;
			var urlVar:URLVariables = new URLVariables();
			var usn:String = mc.inputs_mc.utf.text;
			var pwd:String = mc.inputs_mc.ptf.text;
			Out.debug(this, "we about to request the login, here is usn: "+usn);
			//here is where we name the url variable, "time_from_flash"
			urlVar.username = usn;
			urlVar.password = pwd;
			urlRequest.data = urlVar;
			_submitLoader.addEventListener(Event.COMPLETE, _loginHandler);
			_submitLoader.load(urlRequest);
		}//end function submitHandler
// =================================================
// ================ Workers
// =================================================
        
// =================================================
// ================ Handlers
// =================================================
        private function _loginHandler($evt:Event):void{
			Out.status(this, "loginHandler, here is the response: "+$evt.target.data);
			if ($evt.target.data != "yes") {
				mc.inputs_mc.utf.text = "";
				mc.inputs_mc.ptf.text = "";
				mc.loginError_mc.visible = true;
			}
			else{
				mc.loginError_mc.visible = false;
				//hide loading spinny thing
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