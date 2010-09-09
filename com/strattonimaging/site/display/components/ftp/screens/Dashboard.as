package com.strattonimaging.site.display.components.ftp.screens
{
	import com.bigspaceship.display.StandardButton;
	import com.bigspaceship.display.StandardInOut;
	import com.bigspaceship.utils.Out;
	import com.strattonimaging.site.events.FtpEvent;
	import com.strattonimaging.site.model.Constants;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;

	public class Dashboard extends StandardInOut implements IFtpScreen
	{
        private var _n					:String = Constants.DASH;
		private var _getBtn				:StandardButton;
		private var _putBtn				:StandardButton;
        
// =================================================
// ================ Callable
// =================================================

// =================================================
// ================ Workers
// =================================================
        private function _init():void{
			mc.visible = false;
			_getBtn = new StandardButton(mc.getBtn);
			_getBtn.addEventListener(MouseEvent.CLICK, getClickHandler);
			_putBtn = new StandardButton(mc.putBtn);
			_putBtn.addEventListener(MouseEvent.CLICK, putClickHandler);
		}//end function
// =================================================
// ================ Handlers
// =================================================
		public function getClickHandler($me:MouseEvent):void{
			Out.status(this, "_getClickHandler()::");
			dispatchEvent(new FtpEvent(FtpEvent.CHANGE_FTP_SCREEN, {ns:Constants.GET}));
		}
		public function putClickHandler($me:MouseEvent):void{
			Out.status(this, "_putClickHandler()::");
			dispatchEvent(new FtpEvent(FtpEvent.CHANGE_FTP_SCREEN, {ns:Constants.PUT}));
		}        
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
        override protected function _onAnimateIn():void{
        	
        	//_enableButtons();
        	
        }//end function
// =================================================
// ================ Constructor
// =================================================

		public function Dashboard($mc:MovieClip, $useWeakReference:Boolean=false)
		{
		
			super($mc, $useWeakReference);
			_init();

		}//end constructor
		
	}//end class
}//end package 