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
		private var _tabs				:StandardInOut;
		
		//ftp screens
		private var _bg					:BackgroundPanel;
		private var _login				:Login
		private var _dlm				:DownloadManager;
		private var _dash					:Dashboard;
		private var _ulm				:UploadManager;
		
		//standard buttons
		private var ftpBtn				:StandardButtonInOut;
		private var _tabDashBtn			:StandardButton;
		private var _tabPutBtn			:StandardButton;
		private var _tabGetBtn			:StandardButton;
		private var loginBtn			:StandardButton;
		private var logoutBtn			:StandardButton;
        private var _getBtn				:StandardButton;
        private var _putBtn				:StandardButton;
		private var _browseBtn			:StandardButton;
		private var _uploadBtn			:StandardButton;
		private var _refreshBtn			:StandardButton;
		
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
			
			//screen nav config			
			_model.currentFtpScreen = _login;
			_model.nextFtpScreen	= _dash;
			
        }//end function
		
		private function _setupFtpScreens():void{
			Out.status(this, "_setupFtpScreens");
			//initialize standard in outs
			_tabs	= new StandardInOut(mc.tabs_mc);
			_tabs.mc.visible	= false;

			//initialize ftp screens
			_bg 	= new BackgroundPanel(mc.bg_mc);
			_login	= new Login(mc.login_mc);
			_login.addEventListener(FtpEvent.LOGIN, _loginHandler);
			_dash		= new Dashboard(mc.dashboard_mc);
			_dlm	= new DownloadManager(mc.get_mc);
			_ulm	= new UploadManager(mc.put_mc);
			
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
			animateOut();			
			cs = _login;
			ns = _dash;
		}//end function
		
		private function _getClickHandler($me:MouseEvent):void{
			Out.status(this, "_getClickHandler()::");
			ns = _dlm;
			_showNextFtpScreen();
		}
		private function _putClickHandler($me:MouseEvent):void{
			Out.status(this, "_putClickHandler()::");
			ns = _ulm;
			_showNextFtpScreen();
		}
		private function _dashClickHandler($me:MouseEvent):void{
			Out.status(this, "_dashClickHandler()::");
			ns = _dash;
			_showNextFtpScreen();
		}//end function
		private function _removeOutListeners($ae:AnimationEvent):void{
			Out.status(this, "uh what is the target?"+ $ae.target);
			IFtpScreen($ae.target).removeEventListener(AnimationEvent.OUT_START, ns.animateIn);
			IFtpScreen($ae.target).removeEventListener(AnimationEvent.OUT, _removeOutListeners);
		}
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
					_ss.addStep(3, EventDispatcher(cs), cs.animateIn, AnimationEvent.IN);
					_ss.start();
        		}
        	
        }//end function
        override protected function _animateOut():void{
				Out.status(this, "_animateOut()::");
        		if (_ss) _destroySequencer();
				_ss = new SimpleSequencer("ftpOut");	
				_ss.addEventListener(Event.COMPLETE,_animateOutSequencer_COMPLETE_handler,false,0,true);
				_ss.addStep(1, EventDispatcher(cs), cs.animateOut, AnimationEvent.OUT);
				_ss.addStep(2, _tabs, _tabs.animateOut, AnimationEvent.OUT);
				_ss.addStep(3, _bg, _bg.animateOut, AnimationEvent.OUT);
				_ss.start();
        	
        }//end function
        
        private function _showNextFtpScreen($evt:AnimationEvent = null):void{
        	Out.status(this, "_showNextFtpScreen");
        	
        	if (_tabs.hasEventListener(AnimationEvent.IN)) _tabs.removeEventListener(AnimationEvent.IN, _showNextFtpScreen);
        	cs.addEventListener(AnimationEvent.OUT_START, ns.animateIn);
        	cs.addEventListener(AnimationEvent.OUT, _removeOutListeners);
        	cs.animateOut();
        	cs = ns;
        	
        }//end function 
// =================================================
// ================ Getters / Setters
// =================================================
        /**
         * These getters and setters merely wrap the model's IFTPScreen's values for: 
         * the Current FTP Screen
         * and
         * the Next FTP Screen 
         * my apologies if you can't tell what it means.
         * 
         */
        private function set cs($currentScreen:IFtpScreen):void{ _model.currentFtpScreen = $currentScreen;}
        private function get cs():IFtpScreen{ return _model.currentFtpScreen;}
        private function set ns($nextScreen:IFtpScreen):void{ _model.nextFtpScreen = $nextScreen;}
        private function get ns():IFtpScreen{ return _model.nextFtpScreen;}
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
        	
        	//main toggle btn
			ftpBtn 	= new StandardButtonInOut(_bg.mc.toggle_mc, _bg.mc.toggle_mc.btn);
			ftpBtn.addEventListener(MouseEvent.CLICK, _toggleFtp); 	
        	
        	//tabs 
        	_tabDashBtn = new StandardButton(_tabs.mc.dash);
        	_tabDashBtn.addEventListener(MouseEvent.CLICK, _dashClickHandler);
        	_tabGetBtn = new StandardButton(_tabs.mc.get);
        	_tabGetBtn.addEventListener(MouseEvent.CLICK, _getClickHandler);
        	_tabPutBtn = new StandardButton(_tabs.mc.put);
        	_tabPutBtn.addEventListener(MouseEvent.CLICK, _putClickHandler);
        	
        	//login
			loginBtn= new StandardButton(_login.mc.loginBtn_mc);
			loginBtn.addEventListener(MouseEvent.CLICK, _login.submitLoginHandler);
			logoutBtn = new StandardButton(_tabs.mc.display_mc.logout_mc);
			logoutBtn.addEventListener(MouseEvent.CLICK, _logoutHandler);
			
			//dash			
         	_getBtn = new StandardButton(_dash.mc.getBtn);
         	_getBtn.addEventListener(MouseEvent.CLICK, _getClickHandler);
        	_putBtn = new StandardButton(_dash.mc.putBtn);
         	_putBtn.addEventListener(MouseEvent.CLICK, _putClickHandler);
         	
         	//upload manager
         	_browseBtn = new StandardButton(_ulm.mc.browseBtn);
			_browseBtn.addEventListener(MouseEvent.CLICK, _ulm.browse);
			
			         	
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