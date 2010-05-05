package com.strattonimaging.site.display.screens
{
	import com.bigspaceship.utils.Out;
	import com.strattonimaging.site.Constants;
	
	import flash.display.MovieClip;
	
	import net.ored.util.Resize;
	
	public class Craft extends Screen implements IScreen{
		

		public function Craft($mc:MovieClip, $xml:XML, $useWeakReference:Boolean=false){
			super($mc, $xml, $useWeakReference);
		}
		override protected function _onAnimateInStart():void{
			Out.status(this, "in start");
			Resize.add(
				"@Grad",
				_mc.grad_mc.g,
				[Resize.FULLSCREEN_X, Resize.CUSTOM],
				{
				
					custom:				function($target, $params, $stage):void{
						
						Out.debug(this, "grad w: "+_mc.grad_mc.width+" grad h: "+_mc.grad_mc.height+ " grad alpha: "+_mc.grad_mc.alpha);
							if ($stage.stageHeight > 643) _mc.grad_mc.g.height = $stage.stageHeight - (Constants.BOTTOM_OFFSET - 135);
							else _mc.grad_mc.g.height = 389;
					}//end custom function
				}//end 4th resize add parameter
			);//end @Grad
			
		}//end function onAnimateInStart
		
		override public function get xml():XML{
			return _xml;
		}
		
		override public function beginCustomLoad():void{
			super.beginCustomLoad();
		}//end function 
		
	}//end class
}//end package