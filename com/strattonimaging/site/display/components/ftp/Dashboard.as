package com.strattonimaging.site.display.components.ftp
{
	import com.bigspaceship.display.StandardInOut;
	import com.bigspaceship.utils.Out;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;

	public class Dashboard extends StandardInOut implements IFtpScreen
	{

        
// =================================================
// ================ Callable
// =================================================

// =================================================
// ================ Workers
// =================================================
        
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
        override protected function _onAnimateIn():void{
        	
        	//_enableButtons();
        	
        }//end function
// =================================================
// ================ Constructor
// =================================================

		public function Dashboard($mc:MovieClip, $useWeakReference:Boolean=false)
		{
			Out.status(this, "Dashboard constructor");
			super($mc, $useWeakReference);
			mc.visible = false;
		}//end constructor
		
	}//end class
}//end package 