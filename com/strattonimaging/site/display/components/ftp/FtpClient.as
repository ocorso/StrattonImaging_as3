package com.strattonimaging.site.display.components.ftp
{
	import com.bigspaceship.display.AnimationState;
	import com.bigspaceship.display.StandardButton;
	import com.bigspaceship.display.StandardButtonInOut;
	import com.bigspaceship.events.AnimationEvent;
	import com.bigspaceship.utils.Out;
	import com.bigspaceship.utils.SimpleSequencer;
	import com.strattonimaging.site.Constants;
	import com.strattonimaging.site.display.screens.IScreen;
	import com.strattonimaging.site.display.screens.Screen;
	import com.strattonimaging.site.events.FtpEvent;
	import com.strattonimaging.site.model.SiteModel;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import net.ored.util.Resize;

	public class FtpClient extends Screen implements IScreen
	{
		private var _model				:SiteModel;
		
		//standard in outs
		protected var _bg				:BackgroundPanel;
		protected var _login			:Login
		
		//standard buttons
		protected var ftpBtn			:StandardButtonInOut;
		protected var loginBtn			:StandardButton;
		

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
			_ftpUtil= new FtpUtil();
			_ftpUtil.addEventListener(FtpEvent.REFRESH, _handleRefresh);
			//initialize standard in outs
			_bg 	= new BackgroundPanel(mc.bg_mc);
			_login	= new Login(mc.login_mc);
			_login.addEventListener(FtpEvent.LOGIN, _showDashboard);
			_login.mc.visible = false;
						
			//config 
			setupButtons();
			setupResize();
			
			
        }//end function
		
		private function _handleRefresh($evt:FtpEvent):void{
			Out.status (this, "handle REfresh");
		}
// =================================================
// ================ Handlers
// =================================================
		private function _toggleFtp($evt:MouseEvent):void{
			Out.status(this, "_toggleFtp: ");
		
			if (_bg.state == AnimationState.IN) _animateOut();
			else								_animateIn();
			
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
	        		if (_ss) _destroySequencer();
					_ss = new SimpleSequencer("ftpIn");	
					_ss.addEventListener(Event.COMPLETE,_animateInSequencer_COMPLETE_handler,false,0,true);
					_ss.addStep(1, _bg, _bg.animateIn, AnimationEvent.IN);
					_ss.addStep(2, _login, _login.animateIn, AnimationEvent.IN);
					_ss.start();
        		}
        	
        }//end function
        override protected function _animateOut():void{
        		if (_ss) _destroySequencer();
				_ss = new SimpleSequencer("ftpOut");	
				_ss.addEventListener(Event.COMPLETE,_animateOutSequencer_COMPLETE_handler,false,0,true);
				_ss.addStep(1, _login, _login.animateOut, AnimationEvent.OUT);
				_ss.addStep(2, _bg, _bg.animateOut, AnimationEvent.OUT);
				_ss.start();
        	
        }//end function
        private function _showDashboard($evt:FtpEvent):void{
        	Out.status(this, "showDashboard");
        	
        	//todo: animate login out, 
        	//animate dashboard in
        	//animate tabs in
        	//request initial directory	
        	_ftpUtil.getDirectory(_model.currentDirectory);
        	
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
			//_mc.visible = false;
			_curState = AnimationState.OUT;
			_onAnimateOut();
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