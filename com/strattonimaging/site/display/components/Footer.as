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

		
		override protected function _onAnimateIn():void{
			Out.info(this, "HEEEEEEYYYYY_onAnimateIn()");
			Resize.add(
				"@footer",
				_mc.mask_mc,
				[Resize.FULLSCREEN_X, Resize.CUSTOM],
				{
					bottom_offset:		Constants.BOTTOM_OFFSET,
					custom:				function($target, $params, $stage):void{
						$target.height	=	$stage.stageHeight - $params.bottom_offset;
					}
				}
			);
			Out.info(this, "why is the footer so low? metal y: "+ _mc.mask_mc.y);

		}//end function
	}//end class
}//end package