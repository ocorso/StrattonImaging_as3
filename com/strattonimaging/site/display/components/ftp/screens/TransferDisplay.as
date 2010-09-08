package com.strattonimaging.site.display.components.ftp.screens
{
	import com.bigspaceship.display.StandardButton;
	import com.bigspaceship.display.StandardInOut;
	import com.bigspaceship.utils.Out;
	import com.strattonimaging.site.events.FtpEvent;
	import com.strattonimaging.site.model.SiteModel;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	public class TransferDisplay extends StandardInOut implements IFtpScreen
	{
		private var _m				:SiteModel;
		public var bar				:MovieClip;
		
		private var _cancelBtn		:StandardButton;
		
		// =================================================
		// ================ Callable
		// =================================================
		public function updateProgress($width:int):void{
			
			mc.progress_mc.bar.width = $width;
			
		}//end function
		
		public function setComplete():void{
			
		}
		// =================================================
		// ================ Workers
		// =================================================
		private function _init():void{
			Out.status(this, "init");
			_m = SiteModel.getInstance();
			mc.visible = false;
			bar = mc.progress_mc.bar;
			_cancelBtn = new StandardButton(mc.cancelBtn);
			_cancelBtn.addEventListener(MouseEvent.CLICK, _handleTransferCancelClick);
			
		}//end function _init
		// =================================================
		// ================ Handlers
		// =================================================
		private function _handleTransferCancelClick($me:MouseEvent):void{
			dispatchEvent(new FtpEvent(FtpEvent.TRANSFER_CANCEL));
			
		}
		// =================================================
		// ================ Animation
		// =================================================
		
		// =================================================
		// ================ Getters / Setters
		// =================================================
		
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
		 override protected function _onAnimateOut():void{	bar.width = 1; }    
		// =================================================
		// ================ Constructor
		// =================================================

		public function TransferDisplay($mc:MovieClip, $useWeakReference:Boolean=false)
		{
			super($mc, $useWeakReference);
			_init();
		}
	}
}