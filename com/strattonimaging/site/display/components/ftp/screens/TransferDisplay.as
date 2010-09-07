package com.strattonimaging.site.display.components.ftp.screens
{
	import com.bigspaceship.display.StandardInOut;
	import com.bigspaceship.utils.Out;
	import com.strattonimaging.site.model.SiteModel;
	
	import flash.display.MovieClip;
	
	public class TransferDisplay extends StandardInOut implements IFtpScreen
	{
		private var _m				:SiteModel;
		
		// =================================================
		// ================ Callable
		// =================================================
		
		// =================================================
		// ================ Workers
		// =================================================
		private function _init():void{
			Out.status(this, "init");
			_m = SiteModel.getInstance();
			mc.visible = false;
			
			
		}//end function _init
		// =================================================
		// ================ Handlers
		// =================================================
		
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