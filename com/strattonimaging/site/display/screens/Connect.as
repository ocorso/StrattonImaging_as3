package com.strattonimaging.site.display.screens
{
	import com.bigspaceship.utils.Out;
	import com.strattonimaging.site.model.Constants;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	
	import net.ored.util.Resize;

	public class Connect extends Screen implements IScreen
	{
		public function Connect($mc:MovieClip, $xml:XML, $useWeakReference:Boolean=false)
		{
			super($mc, $xml, $useWeakReference);
		}//end constructor
		
		override protected function _loadComplete($evt:Event):void
		{
			dispatchEvent($evt);
		}
		
		public override function onURLChange():void{
			super.onURLChange();
			Out.status(this, "we'd do something within the same screen here");
		}//end function
		
		override protected function _onAnimateInStart():void{
			Out.status(this, "onAnimateInStart");
			
			setupButtons();
			setupResize();
			
		}//end function
		
		override protected function _onAnimateIn():void{
			Out.status(this, "onAnimateIn(): but i can't see it");
		}//end function
		public function setupButtons():void{
			
		}//end function
		
		public function setupResize():void{
			
			Resize.add(
				"@ConnectGrad",
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
			Resize.add(
				"@ConnectTitle",
				_mc.title_mc.txt,
				[Resize.CENTER_X, Resize.CUSTOM],
				{
					custom:				function($target, $params, $stage):void{
						if ($stage.stageHeight > 643){
							_mc.title_mc.txt.y = ($stage.stageHeight-643)/2;
					 	}else _mc.title_mc.txt.y = 0;
						
					}
				}
			);//end connect title
			Resize.add(
				"@ConnectAddress",
				_mc.address_mc.txt,
				[Resize.CENTER_X, Resize.CUSTOM],
				{
					custom:				function($target, $params, $stage):void{
						if ($stage.stageHeight > 643){
							_mc.address_mc.txt.y = ($stage.stageHeight-643)/2;
					 	}else _mc.address_mc.txt.y = 0;
						
					}
				}
			);//end connect title
			Resize.add(
				"@ConnectPhone",
				_mc.phone_mc.txt,
				[Resize.CENTER_X, Resize.CUSTOM],
				{
					custom:				function($target, $params, $stage):void{
						if ($stage.stageHeight > 643){
							_mc.phone_mc.txt.y = ($stage.stageHeight-643)/2;
					 	}else _mc.phone_mc.txt.y = 0;
						
					}
				}
			);//end connect title
		}//end function
		
	}//end class
}//end package