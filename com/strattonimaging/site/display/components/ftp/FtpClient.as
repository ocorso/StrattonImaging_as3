package com.strattonimaging.site.display.components.ftp
{
	import com.bigspaceship.display.AnimationState;
	import com.bigspaceship.display.StandardButton;
	import com.bigspaceship.display.StandardInOut;
	import com.bigspaceship.events.AnimationEvent;
	import com.bigspaceship.utils.Out;
	import com.bigspaceship.utils.SimpleSequencer;
	import com.strattonimaging.site.display.screens.Screen;
	import com.strattonimaging.site.model.SiteModel;
	
	import fl.controls.DataGrid;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	
	import net.ored.util.Resize;

	public class FtpClient extends Screen
	{
		private var _model			:SiteModel;
		
		protected var ftpBtn		:StandardButton;
		protected var ftp			:StandardInOut;
		protected var login			:StandardInOut;
		protected var loginBtn		:StandardButton;
		private const LOGIN_ROUTE	:String 		= "/ftp/login.xml";
		private var _submitLoader	:URLLoader;
		private var _ss				:SimpleSequencer;

		
		//private var dataGrid	:Comx
		public function FtpClient($mc:MovieClip, $xml:XML, $useWeakReference:Boolean=false)
		{
			//TODO: implement function
			super($mc, $xml, $useWeakReference);
			
			_model 	= SiteModel.getInstance();
			
			ftpBtn 	= new StandardButton(_mc.ftpClient.ftp_btn_mc);
			ftp 	= new StandardInOut(_mc.ftpClient);
			
			login 	= new StandardInOut(_mc.ftpClient.login_mc);
			loginBtn= new StandardButton(_mc.ftpClient.login_mc.submit_mc);
			login.mc.visible = false;
			
			ftp.addEventListener(AnimationEvent.IN, _showLogin);
			ftpBtn.addEventListener(MouseEvent.CLICK, _toggleFtp); 	
			_setupResize();
			
			
		}//end constructor
		
		private function _setupResize():void{
			Resize.add(
				"@ftp",
				_mc,
				[Resize.BOTTOM, Resize.CENTER_X, Resize.CUSTOM],
				{
					 custom:				function($target, $params, $stage):void{
						if ($stage.stageHeight > 643){
							_mc.y = $stage.stageHeight-643;
						}else _mc.y = 0;
						 
					}
				}
			);//end btns center
		
		}//end function
		private function _toggleFtp($evt:MouseEvent):void{
			Out.status(this, "_toggleFtp: "+login.state);
			if (ftp.state == AnimationState.IN) {
				_ss = new SimpleSequencer("ftpOut");	
				_ss.addEventListener(Event.COMPLETE,ftp.animateOut,false,0,true);
				_ss.addStep(1, login, login.animateOut, AnimationEvent.OUT);
				_ss.start();
			}
			else	ftp.animateIn();
			
		}//end function 
		
		private function _showLogin($evt:AnimationEvent):void{
			login.animateIn();
		}
		override protected function _onAnimateInStart():void{
			Out.status(this, "starting to animate in"); 
			login.mc.visible = true;
		}//end function onAnimateInStart
		
		override protected function _onAnimateOutStart():void{
			Out.status(this, "starting to animate out"); 
			login.mc.visible = false;
		}//end function onAnimateInStart
		override protected function _onAnimateIn():void{
			loginBtn.addEventListener(MouseEvent.CLICK, _submitLoginHandler);
		
		}//end function onAnimateIn
		private function _submitLoginHandler($evt:MouseEvent):void{
			Out.status(this, "Submit handler::");
			_submitLoader = new URLLoader();
			
			var loginURL:String = _model.getBaseURL() + LOGIN_ROUTE;
			var urlRequest:URLRequest = new URLRequest(loginURL);
			urlRequest.method = URLRequestMethod.POST;
			var urlVar:URLVariables = new URLVariables();
			var usn:String = login.mc.usn.text;
			var pwd:String = login.mc.pwd.text;
			Out.debug(this, "we about to request the login, here is usn: "+usn);
			//here is where we name the url variable, "time_from_flash"
			urlVar.username = usn;
			urlVar.password = pwd;
			urlRequest.data = urlVar;
			_submitLoader.addEventListener(Event.COMPLETE, _loginHandler);
			_submitLoader.load(urlRequest);
		}//end function submitHandler
		private function _loginHandler($evt:Event):void{
			Out.status(this, "loginHandler, here is the response: "+$evt.target.data);
			if ($evt.target.data == "no") login.mc.gotoAndStop("FAILURE");
			else{
				login.mc.gotoAndStop("SUCCESS");
				var dg:DataGrid = new DataGrid();
			} 
		}//end function
	}//end class
}//end package