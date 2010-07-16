package com.strattonimaging.site.display.screens.credits
{
	import com.bigspaceship.display.AnimationState;
	import com.bigspaceship.display.StandardInOut;
	import com.bigspaceship.events.AnimationEvent;
	import com.bigspaceship.utils.Out;
	
	import flash.display.MovieClip;

	public class Carousel extends StandardInOut
	{
		public function Carousel($mc:MovieClip, $useWeakReference:Boolean=false)
		{
			super($mc, $useWeakReference);
			_init();
		}//end function
		
		private function _init():void{
			
			//make a bunch of credits 
			
		}//end function
		override protected function _onAnimateOut_handler($evt:AnimationEvent = null):void{ 
			
			Out.status(this, "_onAnimateOUt handler");
			mc.stop();
			//_mc.visible = false;
			_curState = AnimationState.OUT;
			//_onAnimateOut();
			dispatchEvent(new AnimationEvent(AnimationEvent.OUT));
		}
	}//end class 
}//end package