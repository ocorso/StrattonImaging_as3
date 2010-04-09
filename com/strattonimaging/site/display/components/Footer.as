package com.strattonimaging.site.display.components
{
	import com.bigspaceship.events.AnimationEvent;
	import com.bigspaceship.utils.Lib;
	import com.bigspaceship.utils.Out;
	import com.strattonimaging.site.Constants;
	import com.strattonimaging.site.display.screens.Screen;
	
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	import net.ored.util.Resize;
	
	public class Footer extends Screen
	{

		public function Footer($mc:MovieClip, $xml:XML, $useWeakReference:Boolean=false)
		{
			super($mc, $xml, $useWeakReference);
			_init();
			
		}//end constructor
		private function _init():void{
			
			
		}
		override protected function _onAnimateInStart():void{
			Out.info(this, "HEY YO_onAnimateInStart()");
			
			Resize.add(
				"@footerCenter",
				_mc,
				[Resize.CENTER_X, Resize.CUSTOM],
				{
							
					custom:				function($target, $params, $stage):void{
						if ($stage.stageHeight > 643){
							_mc.y = $stage.stageHeight-643;
						}else _mc.y = 0;
					}//end custom resize function
				}//end 4th param
			);//end @footerCenter
		}
		override protected function _onAnimateIn():void{
			
		}//end function
	}//end class
}//end package