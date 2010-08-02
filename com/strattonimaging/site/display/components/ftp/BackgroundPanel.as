package com.strattonimaging.site.display.components.ftp
{
	import com.bigspaceship.display.AnimationState;
	import com.bigspaceship.display.StandardInOut;
	import com.bigspaceship.events.AnimationEvent;
	
	import flash.display.MovieClip;

	public class BackgroundPanel extends StandardInOut
	{
		private var _tf				:MovieClip;
        
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
		override protected function _onAnimateInStart():void{
			mc.toggle_mc.mc.text_mc.tf.text = "close";
		}
		override protected function _onAnimateOut():void{
			mc.toggle_mc.mc.text_mc.tf.text = "client login";
		}
		override protected function _onAnimateOut_handler($evt:AnimationEvent = null):void{ 
			mc.stop();
			mc.visible = true;
			_curState = AnimationState.OUT;
			_onAnimateOut();
			dispatchEvent(new AnimationEvent(AnimationEvent.OUT));
		}
        
// =================================================
// ================ Constructor
// =================================================

		public function BackgroundPanel($mc:MovieClip, $useWeakReference:Boolean=false)
		{
			super($mc, $useWeakReference);
		}//end constructor
	}//end class
}//end package