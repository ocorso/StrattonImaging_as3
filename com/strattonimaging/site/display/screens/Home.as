package com.strattonimaging.site.display.screens
{
	import com.bigspaceship.display.StandardButton;
	import com.bigspaceship.utils.Out;
	import com.strattonimaging.site.Constants;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	
	import net.ored.util.Resize;
	
	
	public class Home extends Screen implements IScreen
	{
		private var george_left:StandardButton;
		private var george_right:StandardButton;
		
		public function Home($mc:MovieClip, $xml:XML, $useWeakReference:Boolean=false)
		{
			super($mc, $xml, $useWeakReference);
			setupResize();
			setupButtons();
		}
		public function setupResize():void{
			
			Resize.add(
				"@homeScreen",
				_mc,
				[Resize.CENTER_X, Resize.CUSTOM],
				{
					custom:	function($target, $params, $stage):void{
								if ($stage.stageHeight > Constants.STAGE_HEIGHT){
									_mc.y = ($stage.stageHeight-Constants.STAGE_HEIGHT)/2;
					 			}else _mc.y = 0;
					}//end custom function
				}//end 4 param
			);//end resize add @homeScreen
		}//end function	
		public function setupButtons():void{
			Out.status(this, "onAnimateIn(): "+_mc.georgeLeft);
			george_left = new StandardButton(_mc.georgeLeft);
			george_right = new StandardButton(_mc.georgeRight);
		}//end function
		override protected function _loadComplete($evt:Event):void
		{
			dispatchEvent($evt);
		}

		public override function onURLChange():void{
			super.onURLChange();
			Out.status(this, "we'd do something within the same screen here");
		}//end function
		override protected function _onAnimateInStart():void{
			
		}
	}//end class
}//end package