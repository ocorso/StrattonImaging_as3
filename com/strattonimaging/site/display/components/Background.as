package com.strattonimaging.site.display.components
{
	import com.bigspaceship.display.StandardInOut;
	import com.bigspaceship.utils.Out;
	
	import flash.display.MovieClip;
	
	import net.ored.util.Resize;
	
	public class Background extends StandardInOut
	{
		public function Background($mc:MovieClip, $useWeakReference:Boolean=false)
		{
			super($mc, $useWeakReference);
			Out.info(this, "we just created a background");
			 
		}//end constructor
		
		override protected function _onAnimateInStart():void{
			Resize.add(
				"@background",
				_mc.grad_mc.shape_mc,
				[Resize.CORNER_TL, Resize.FULLSCREEN],
				{
				}
			);
		}//end function
	}//end class
}//end package