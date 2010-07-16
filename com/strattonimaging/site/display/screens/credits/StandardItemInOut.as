package com.strattonimaging.site.display.screens.credits
{
	import com.bigspaceship.display.StandardInOut;
	import flash.display.MovieClip;

	public class StandardItemInOut extends StandardInOut
	{
		protected var _bIsNextAnimation	:Boolean;
		
		public function StandardItemInOut($mc:MovieClip, $useWeakReference:Boolean=false)
		{
			super($mc, $useWeakReference);
			mc.visible = false;
		}
		override protected function _animateIn():void{
			if (_bIsNextAnimation)	mc.gotoAndPlay("NEXT_IN_START");
			else					mc.gotoAndPlay("IN_START");
		}//end function
		override protected function _animateOut():void{
			if (_bIsNextAnimation)	mc.gotoAndPlay("NEXT_OUT_START");
			else					mc.gotoAndPlay("OUT_START");
		}//end function
		
		public function get isNextAnimation():Boolean{ return _bIsNextAnimation;}
        public function set isNextAnimation($isNext:Boolean):void{ _bIsNextAnimation= $isNext;}
	}
}