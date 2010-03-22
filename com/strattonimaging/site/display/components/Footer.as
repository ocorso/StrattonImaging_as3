package com.strattonimaging.site.display.components
{
	import com.bigspaceship.events.AnimationEvent;
	import com.bigspaceship.utils.Out;
	import com.strattonimaging.site.Constants;
	import com.strattonimaging.site.display.screens.Screen;
	
	import flash.display.MovieClip;
	
	import net.ored.util.Resize;
	
	public class Footer extends Screen
	{
		public function Footer($mc:MovieClip, $xml:XML, $useWeakReference:Boolean=false)
		{
			super($mc, $xml, $useWeakReference);
		}//end constructor

		override protected function _onAnimateInStart():void{
			Resize.add(
				"@FooterInStart",
				_mc.mask_mc.shape_mc,
				[Resize.BOTTOM, Resize.FULLSCREEN_X],
				{
				}
			);
		}//end function
		
		override protected function _onAnimateIn():void{
			Out.info(this, "HEEEEEEYYYYY_onAnimateIn()");
			/*Resize.add(
				"@footer",
				_mc.mask_mc,
				[Resize.BOTTOM, Resize.FULLSCREEN_X, Resize.CUSTOM],
				{
					bottom_offset:		Constants.BOTTOM_OFFSET,
					custom:				function($target, $params, $stage):void{
						$target.y	-=	$params.bottom_offset;
					}
				}
			);*/
		}//end function
	}//end class
}//end package