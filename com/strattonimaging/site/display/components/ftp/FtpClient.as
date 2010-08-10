package com.strattonimaging.site.display.components.ftp
{
	import com.bigspaceship.display.AnimationState;
	import com.bigspaceship.display.StandardButton;
	import com.bigspaceship.display.StandardButtonInOut;
	import com.bigspaceship.display.StandardInOut;
	import com.bigspaceship.events.AnimationEvent;
	import com.bigspaceship.utils.Out;
	import com.bigspaceship.utils.SimpleSequencer;
	import com.strattonimaging.site.Constants;
	import com.strattonimaging.site.display.screens.IScreen;
	import com.strattonimaging.site.display.screens.Screen;
	import com.strattonimaging.site.events.FtpEvent;
	import com.strattonimaging.site.model.SiteModel;
	import com.strattonimaging.site.model.vo.FTPUser;
	
	import fl.data.DataProvider;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	
	import net.ored.util.Resize;

	public class FtpClient extends Screen implements IScreen
	{
		private var _model				:SiteModel;
		
		//standard in outs
		protected var _bg				:BackgroundPanel;
		protected var _tabs				:StandardInOut;
		protected var _login			:Login
		protected var _dlm				:DownloadManager;
		protected var _db				:Dashboard;
		
		//standard buttons
		protected var ftpBtn			:StandardButtonInOut;
		protected var loginBtn			:StandardButton;
		protected var logoutBtn			:StandardButton;
	
		//utility vars
		private var _bIsInitialIn		:Boolean 		= true;
		private var _ftpUtil			:FtpUtil;
        
// =================================================
// ================ Callable
// =================================================
        
// =================================================
// ================ Workers
// =================================================
        private function _init():void{
			
			Out.status(this, "init()");
			        	
			_model 	= SiteModel.getInstance();
			
			//initialize our handy little ftp module			
			_ftpUtil = new FtpUtil();
			_ftpUtil.addEventListener(FtpEvent.REFRESH, _handleRefresh);
			
				
			//config 
			_setupFtpScreens();
			setupButtons();
			setupResize();
			
			_model.currentFtpScreen = _login;
			_model.nextFtpScreen	= _dlm;
			
        }//end function
		
		private function _setupFtpScreens():void{
			Out.status(this, "_setupFtpScreens");
			//initialize standard in outs
			_bg 	= new BackgroundPanel(mc.bg_mc);
			_tabs	= new StandardInOut(mc.tabs_mc);
			
			_login	= new Login(mc.login_mc);
			_login.addEventListener(FtpEvent.LOGIN, _loginHandler);
			_db		= new Dashboard(mc.dashboard_mc);
			_dlm	= new DownloadManager(mc.get_mc);

			_tabs.mc.visible	= false;
			_login.mc.visible 	= false;
			_db.mc.visible		= false;
			_dlm.mc.visible		= false;
		}//end function 
		
// =================================================
// ================ Handlers
// =================================================
		private function _toggleFtp($evt:MouseEvent):void{
			Out.status(this, "_toggleFtp: ");
		
			if (_bg.state == AnimationState.IN) _animateOut();
			else								_animateIn();
			
		}//end function 
		
		private function _handleRefresh($evt:FtpEvent):void{
			Out.status (this, "handle REfresh");
			_dlm.refresh($evt.info as DataProvider);
		}//end function

		private function _loginHandler($evt:FtpEvent):void{
			Out.status(this, "_loginHandler");
        	_ftpUtil.getDirectory(_model.currentDirectory);
			_tabs.addEventListener(AnimationEvent.IN, _showNextFtpScreen);
			_tabs.animateIn();			
		}//end function
		
		private function _logoutHandler($me:MouseEvent):void{
			Out.status(this, "_logoutHandler()::");
			_model.ftpUser = new FTPUser({});
			_model.currentFtpScreen = _login;
			animateOut();			
		}//end function
// =================================================
// ================ Animation
// =================================================
        override protected function _animateIn():void{
        	
        		if (_bIsInitialIn)	{
    				_bIsInitialIn = false;    			
	        		_bg.mc.toggle_mc.play();
	        		dispatchEvent(new AnimationEvent(AnimationEvent.IN));
        		}
        		else{
				Out.status(this, "_animateIn()::");
	        		if (_ss) _destroySequencer();
					_ss = new SimpleSequencer("ftpIn");	
					_ss.addEventListener(Event.COMPLETE,_animateInSequencer_COMPLETE_handler,false,0,true);
					_ss.addStep(1, _bg, _bg.animateIn, AnimationEvent.IN);
					if (_model.ftpUser || _model.ftpAuth)	_ss.addStep(2, _tabs, _tabs.animateIn, AnimationEvent.IN);
					_ss.addStep(3, _model.currentFtpScreen as EventDispatcher, _model.currentFtpScreen.animateIn, AnimationEvent.IN);
					_ss.start();
        		}
        	
        }//end function
        override protected function _animateOut():void{
				Out.status(this, "_animateOut()::");
        		if (_ss) _destroySequencer();
				_ss = new SimpleSequencer("ftpOut");	
				_ss.addEventListener(Event.COMPLETE,_animateOutSequencer_COMPLETE_handler,false,0,true);
				_ss.addStep(1, _model.currentFtpScreen as EventDispatcher, _model.currentFtpScreen.animateOut, AnimationEvent.OUT);
				_ss.addStep(2, _tabs, _tabs.animateOut, AnimationEvent.OUT);
				_ss.addStep(3, _bg, _bg.animateOut, AnimationEvent.OUT);
				_ss.start();
        	
        }//end function
        
        private function _showNextFtpScreen($evt:AnimationEvent):void{
        	Out.status(this, "_showNextFtpScreen");
        	_model.currentFtpScreen
        	if (_tabs.hasEventListener(AnimationEvent.IN)) _tabs.removeEventListener(AnimationEvent.IN, _showNextFtpScreen);
        	_model.currentFtpScreen.addEventListener(AnimationEvent.OUT, _model.nextFtpScreen.animateIn);
        	_model.currentFtpScreen.animateOut();
        	//animate dashboard in
        	//animate tabs in
        	//request initial directory	
        	
        }//end function 
// =================================================
// ================ Getters / Setters
// =================================================
        
// =================================================
// ================ Interfaced
// =================================================
		public function setupResize():void{
			Resize.add(
				"@ftp",
				mc,
				[Resize.CENTER_X, Resize.CUSTOM],
				{
					 custom:				function($target, $params, $stage):void{
						if ($stage.stageHeight > Constants.STAGE_HEIGHT){
							mc.y = $stage.stageHeight-Constants.STAGE_HEIGHT;
						}else mc.y = 0;
					}
				}
			);//end btns center
		
		}//end function
        public function setupButtons():void{
        	
			ftpBtn 	= new StandardButtonInOut(_bg.mc.toggle_mc, _bg.mc.toggle_mc.btn);
			ftpBtn.addEventListener(MouseEvent.CLICK, _toggleFtp); 	
        	
			loginBtn= new StandardButton(_login.mc.loginBtn_mc);
			loginBtn.addEventListener(MouseEvent.CLICK, _login.submitLoginHandler);
			
			logoutBtn = new StandardButton(_tabs.mc.display_mc.logout_mc);
			logoutBtn.addEventListener(MouseEvent.CLICK, _logoutHandler);
			
			
        }//end function
// =================================================
// ================ Core Handler
// =================================================
        
// =================================================
// ================ Overrides
// =================================================
		override protected function _onAnimateInStart():void{
			Out.status(this, "starting to animate in"); 
		//	_login 	= new StandardInOut(_mc.ftpClient.views_mc.login_mc);
		}//end function onAnimateInStart
		
		override protected function _onAnimateOutStart():void{
			Out.status(this, "starting to animate out"); 
		}//end function onAnimateInStart
		override protected function _onAnimateIn():void{
		//	loginBtn.addEventListener(MouseEvent.CLICK, _submitLoginHandler);
		}//end function onAnimateIn
		override protected function _onAnimateOut():void{}   
		override protected function _animateOutSequencer_COMPLETE_handler($evt:Event = null):void{
			Out.status(this,"_realAnimateOut_handler()");
			_destroySequencer();
			_onAnimateOut_handler();
		}     
		override protected function _onAnimateOut_handler($evt:AnimationEvent = null):void{ 
			mc.stop();
			_curState = AnimationState.OUT;
			_onAnimateOut();
			if (_model.currentFtpScreen.hasEventListener(AnimationEvent.IN)) _model.currentFtpScreen.removeEventListener(AnimationEvent.IN, _showNextFtpScreen);
			dispatchEvent(new AnimationEvent(AnimationEvent.OUT));
		}
// =================================================
// ================ Constructor
// =================================================
		
		public function FtpClient($mc:MovieClip, $xml:XML, $useWeakReference:Boolean=false)
		{
			//TODO: implement function
			super($mc, $xml, $useWeakReference);
			_init();
			
			
		}//end constructor
		
	}//end class
}//end package