package com.strattonimaging.site.display.components
{
	import com.strattonimaging.site.display.screens.Screen;
	
	import flash.display.MovieClip;
	
	import net.ored.util.Resize;
	
	public class Footer extends Screen
	{
		public function Footer($mc:MovieClip, $xml:XML, $useWeakReference:Boolean=false)
		{
			super($mc, $xml, $useWeakReference);
			
			Resize.add(
				"@footer",
				_mc.footer_mc.mask_mc,
				Resize.FULLSCREEN_X,
				{}
			);
		
		}//end constructor
		override protected function _onAnimateIn():void{
			Resize.add(
				"@footer",
				_mc.footer_mc.mask_mc,
				[Resize.FULLSCREEN_X, Resize.CUSTOM],
				{
					custom: function($target, $params, $stage):void{
						$target.height	=	$stage.stageHeight - $target.y;
					}
				}
			);
			
			Resize.remove("@footer");
		}//end function
	}//end class
}//end package