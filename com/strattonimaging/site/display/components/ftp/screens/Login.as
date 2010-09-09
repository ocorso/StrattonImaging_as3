package com.strattonimaging.site.display.components.ftp.screens
{
	import com.adobe.serialization.json.JSONDecoder;
	import com.adobe.serialization.json.JSONEncoder;
	import com.bigspaceship.display.StandardButton;
	import com.bigspaceship.display.StandardInOut;
	import com.bigspaceship.utils.Out;
	import com.dynamicflash.util.Base64;
	import com.strattonimaging.site.model.Constants;
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
	
	
	public class Login extends StandardInOut implements IFtpScreen
	{
		private var _n					:String = Constants.LOGIN;
		private var _m					:SiteModel;
		private var loginBtn			:StandardButton;
		private var _submitLoader		:URLLoader;
        
// =================================================
// ================ Callable
// =================================================
// =================================================
// ================ Workers
// =================================================
        private function _init():void{
			_m = SiteModel.getInstance();
			mc.visible = false;
			
			loginBtn= new StandardButton(mc.loginBtn_mc);
			loginBtn.addEventListener(MouseEvent.CLICK, _submitLoginHandler);
		}//end function
// =================================================
// ================ Handlers
// =================================================
		private function _keyEventHandler($ke:KeyboardEvent):void{	
			if ($ke.charCode == Keyboard.ENTER){
				Out.status(this, "Enter");
				_submitLoginHandler();			
			}//end if
				
		}//end function
		private function _submitLoginHandler($evt:MouseEvent = null):void{
			Out.status(this, "Submit handler::");
			_submitLoader = new URLLoader();
			
			var loginURL:String = _m.baseUrl + Constants.LOGIN_ROUTE;
			var urlRequest:URLRequest = new URLRequest(loginURL);
			urlRequest.method = URLRequestMethod.POST;
			var urlVar:URLVariables = new URLVariables();
			var usn:String = mc.inputs_mc.utf.text;
			var pwd:String = mc.inputs_mc.ptf.text;
			var regularObject:Object = {};
			regularObject.u = usn;
			regularObject.p = pwd;
			
			Out.debug(this, "usn: "+regularObject.u);
			Out.debug(this, "pwd: "+regularObject.p);
			//here is where we name the url variable, "time_from_flash"
			var toJSON:JSONEncoder = new JSONEncoder(regularObject);
			var json:String = toJSON.getString();
			urlVar.d = Base64.encode(json);
			urlRequest.data = urlVar;
			//Out.info(this, "JSON: "+ urlRequest.
			_submitLoader.addEventListener(Event.COMPLETE, _loginHandler);
			_submitLoader.load(urlRequest);
		}//end function submitHandler
		
        private function _loginHandler($evt:Event):void{
			Out.status(this, "loginHandler, here is the response: "+$evt.target.data);
			var json:JSONDecoder = new JSONDecoder(Base64.decode($evt.target.data), false);
			ObjectToString.o(json.getValue());
			
			_m.ftpUser = new FTPUser(json.getValue());
			if (!_m.ftpUser.auth) {
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
     	public function get name ():String{ return _n;}  
// =================================================
// ================ Interfaced
// =================================================
 		public function startTransfer():void{}//no need for this here       
        public function cancelTransfer():void{}//no need for this here
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
			_init();
		}//end constructor
	}//end class
}//end package