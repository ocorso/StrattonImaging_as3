package com.strattonimaging.site.display.components.ftp
{	
	/**
	 * @author Owen Corso
	 * 
	 * This is the custom Flash FTP Client
	 * it has both upload and download functionality
	 *  
	 */	
	import __AS3__.vec.Vector;
	
	import com.bigspaceship.display.AnimationState;
	import com.bigspaceship.display.StandardButton;
	import com.bigspaceship.display.StandardButtonInOut;
	import com.bigspaceship.display.StandardInOut;
	import com.bigspaceship.events.AnimationEvent;
	import com.bigspaceship.utils.Out;
	import com.bigspaceship.utils.SimpleSequencer;
	import com.strattonimaging.site.display.components.ftp.screens.Dashboard;
	import com.strattonimaging.site.display.components.ftp.screens.DownloadManager;
	import com.strattonimaging.site.display.components.ftp.screens.IFtpScreen;
	import com.strattonimaging.site.display.components.ftp.screens.Login;
	import com.strattonimaging.site.display.components.ftp.screens.TransferDisplay;
	import com.strattonimaging.site.display.components.ftp.screens.UploadManager;
	import com.strattonimaging.site.display.screens.IScreen;
	import com.strattonimaging.site.display.screens.Screen;
	import com.strattonimaging.site.events.FtpEvent;
	import com.strattonimaging.site.model.Constants;
	import com.strattonimaging.site.model.SiteModel;
	
	import fl.data.DataProvider;
	
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	
	import net.ored.util.Resize;

	public class FtpClient extends Screen implements IScreen
	{
		//standard in outs
		private var _tabs				:StandardInOut;
		
		//ftp screens
		private var _bg					:BackgroundPanel;
		private var _login				:Login
		private var _dash				:Dashboard;
		private var _dlm				:DownloadManager;
		private var _ulm				:UploadManager;
		private var _trans				:TransferDisplay;
		
		//standard buttons
		private var _ftpBtn				:StandardButtonInOut;
		private var _tabDashBtn			:StandardButton;
		private var _tabPutBtn			:StandardButton;
		private var _tabGetBtn			:StandardButton;
		
		private var _logoutBtn			:StandardButton;
        
		//utility vars
		private var _bIsInitialIn		:Boolean 		= true;
		private var _ftpUtil			:FtpUtil; 
		private var _screenVector		:Vector.<IFtpScreen>;
        
// =================================================
// ================ Callable
// =================================================
        
// =================================================
// ================ Workers
// =================================================
        private function _init():void{
			Out.status(this, "init()");
			
			//initialize our handy little ftp module			
			_ftpUtil = new FtpUtil();
			_ftpUtil.addEventListener(FtpEvent.REFRESH, _handleRefresh);
			_ftpUtil.addEventListener(FtpEvent.TRANSFER_COMPLETE, _handleFtpScreenChange);
			
			//config 
			_setupFtpScreens();
			setupButtons();
			setupResize();
			
			//listen for changeFtpScreen event
			addEventListener(FtpEvent.CHANGE_FTP_SCREEN, _handleFtpScreenChange);
			
			//screen nav config			
			_m.currentFtpScreen = _login;
			_m.nextFtpScreen	= _dash;
			
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
			_dash	= new Dashboard(mc.dashboard_mc);
			_dash.addEventListener(FtpEvent.CHANGE_FTP_SCREEN, _handleFtpScreenChange);
			_dlm	= new DownloadManager(mc.get_mc);
			_dlm.addEventListener(FtpEvent.DO_REFRESH, _ftpUtil.getDirectory);
			_dlm.addEventListener(FtpEvent.CHANGE_FTP_SCREEN, _handleFtpScreenChange);
			_dlm.addEventListener(FtpEvent.TRANSFER_START, _handleTransferStart);
			_ulm	= new UploadManager(mc.put_mc);
			_ulm.addEventListener(FtpEvent.CHANGE_FTP_SCREEN, _handleFtpScreenChange);
			_ulm.addEventListener(FtpEvent.TRANSFER_START, _handleTransferStart);
			_trans	= new TransferDisplay(mc.transfer_mc);
			
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
        	_ftpUtil.getDirectory();
			_tabs.addEventListener(AnimationEvent.IN, _showNextFtpScreen);
			_tabs.mc.display_mc.name_mc.tf.text = _m.ftpUser.name;
			_tabs.animateIn();			
		}//end function
		
		private function _logoutHandler($me:MouseEvent):void{
			Out.status(this, "_logoutHandler()::");
			_ftpUtil.clearFtpUser();
			Out.debug(this, "ftpAuth = :"+_m.ftpAuth);
			animateOut();			
			cs = _login;
			ns = _dash;
		}//end function
		
		private function _handleFtpScreenChange($e:FtpEvent):void{
			Out.status(this, "_handleFtpScreenChange():: ");
			Out.info(this, "new ns: " + $e.data.ns);
			Out.error(this, "old ns: " + ns.name);
			Out.info(this, "cs: " + cs.name);
			if ($e.data.ns == cs.name) Out.warning(this, "do nothing");
			else {
				switch ($e.data.ns){
					case Constants.GET  	: ns = _dlm; break;
					case Constants.PUT  	: ns = _ulm; break;
					case Constants.DASH 	: ns = _dash; break;
					case Constants.TRANSFER : ns = _trans; 
						_ftpUtil.manageProgress(cs, _trans);
						break;
					default : Out.error(this, "huh? no idea what you clicked"); return;
				}//end switch
				_showNextFtpScreen();
			}//end else 
			
		}//end function 
		
		private function _handleTransferStart($e:FtpEvent): void{
			Out.status(this, "_handleTransferStart");
			
		}
		private function _dashClickHandler($me:MouseEvent):void{
			Out.status(this, "_dashClickHandler()::");
			dispatchEvent(new FtpEvent(FtpEvent.CHANGE_FTP_SCREEN, {ns:Constants.DASH}));
		}//end function
		private function _removeOutListeners($ae:AnimationEvent):void{
			Out.status(this, "removing OutListeners on: "+ $ae.target);
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
					if (_m.ftpAuth)	_ss.addStep(2, _tabs, _tabs.animateIn, AnimationEvent.IN);
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
				if(_tabs.state == AnimationState.IN)	_ss.addStep(2, _tabs, _tabs.animateOut, AnimationEvent.OUT);
				_ss.addStep(3, _bg, _bg.animateOut, AnimationEvent.OUT);
				_ss.start();
        	
        }//end function
        
        private function _showNextFtpScreen($evt:AnimationEvent = null):void{
        	Out.status(this, "_showNextFtpScreen");
        	Out.debug(this, "ns: "+ns+" cs: "+cs);
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
        private function set cs($currentScreen:IFtpScreen):void{ _m.currentFtpScreen = $currentScreen;}
        private function get cs():IFtpScreen{ return _m.currentFtpScreen;}
        private function set ns($nextScreen:IFtpScreen):void{ _m.nextFtpScreen = $nextScreen;}
        private function get ns():IFtpScreen{ return _m.nextFtpScreen;}
// =================================================
// ================ Interfaced
// =================================================
		public function setupResize():void{
			Resize.add(
				"@ftp",
				mc,
				[Resize.CENTER_X, Resize.CUSTOM],
				{
					custom:	function($target:*, $params:*, $stage:Stage):void{
						if ($stage.stageHeight > Constants.STAGE_HEIGHT){
							mc.y = $stage.stageHeight-Constants.STAGE_HEIGHT;
						}else mc.y = 0;
					}
				}
			);//end btns center
		
		}//end function
		/**
		 * setupButtons takes care of all buttons that perform the navigation 
		 * within the FTPClient.  if 
		 */		
        public function setupButtons():void{
        	
        	//main toggle btn
			_ftpBtn 	= new StandardButtonInOut(_bg.mc.toggle_mc, _bg.mc.toggle_mc.btn);
			_ftpBtn.addEventListener(MouseEvent.CLICK, _toggleFtp); 	
        	
        	//tabs 
        	_tabDashBtn = new StandardButton(_tabs.mc.dash);
        	_tabDashBtn.addEventListener(MouseEvent.CLICK, _dashClickHandler);
        	_tabGetBtn = new StandardButton(_tabs.mc.get);
        	_tabGetBtn.addEventListener(MouseEvent.CLICK, _dash.getClickHandler);
        	_tabPutBtn = new StandardButton(_tabs.mc.put);
        	_tabPutBtn.addEventListener(MouseEvent.CLICK, _dash.putClickHandler);
        	
        	//logout
			_logoutBtn = new StandardButton(_tabs.mc.display_mc.logout_mc);
			_logoutBtn.addEventListener(MouseEvent.CLICK, _logoutHandler);
         	
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
			if (_m.currentFtpScreen.hasEventListener(AnimationEvent.IN)) _m.currentFtpScreen.removeEventListener(AnimationEvent.IN, _showNextFtpScreen);
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