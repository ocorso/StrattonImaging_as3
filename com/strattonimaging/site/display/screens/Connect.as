package com.strattonimaging.site.display.screens
{
	import com.bigspaceship.utils.Out;
	import com.strattonimaging.site.model.Constants;
	
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	import net.ored.util.Resize;

	public class Connect extends Screen implements IScreen
	{
		private const __TOUT_OFFSET_X:Number = 360;
		
		// =================================================
		// ================ Callable
		// =================================================
		public override function onURLChange():void{
			super.onURLChange();
			Out.status(this, "we'd do something within the same screen here");
		}//end function		
		// =================================================
		// ================ Workers
		// =================================================
		private function _init():void{
			setupButtons();
			setupResize();
		}//end function
		// =================================================
		// ================ Handlers
		// =================================================
		private function _handleEmailClick($me:MouseEvent):void{
			Out.status(this, "_handleEmailClick");
			navigateToURL(new URLRequest("mailto:info@strattonimaging.com"));
		}
		// =================================================
		// ================ Animation
		// =================================================
		
		// =================================================
		// ================ Getters / Setters
		// =================================================
		
		// =================================================
		// ================ Interfaced
		// =================================================
		public function setupButtons():void{
			mc.tout2_mc.inner.emailBtn.addEventListener(MouseEvent.CLICK, _handleEmailClick);
		}//end function
		
		public function setupResize():void{
			
			Resize.add(
				"@ConnectGrad",
				mc.grad_mc.g,
				[Resize.FULLSCREEN_X, Resize.CUSTOM],
				{
					custom:	function($target:*, $params:*, $stage:Stage):void{
						Out.debug(this, "grad w: "+mc.grad_mc.width+" grad h: "+mc.grad_mc.height+ " grad alpha: "+mc.grad_mc.alpha);
						if ($stage.stageHeight > 643) mc.grad_mc.g.height = $stage.stageHeight - (Constants.BOTTOM_OFFSET - 135);
						else mc.grad_mc.g.height = 389;
					}//end custom function
				}//end 4th resize add parameter
			);//end @Grad
			Resize.add(
				"@ConnectTitle",
				mc.title_mc.inner,
				[Resize.CENTER_X, Resize.CUSTOM],
				{
					custom:	function($target:*, $params:*, $stage:Stage):void{
						mc.title_mc.inner.x += 100;
						if ($stage.stageHeight > 643){
							mc.title_mc.inner.y = ($stage.stageHeight-643)/2;
						}else mc.title_mc.inner.y = 0;
						
					}
				}
			);//end connect title
			Resize.add(
				"@ConnectTout1",
				mc.tout1_mc.inner,
				[Resize.CENTER_X, Resize.CUSTOM],
				{
					custom:	function($target:*, $params:*, $stage:Stage):void{
						mc.tout1_mc.inner.x -= __TOUT_OFFSET_X;
						if ($stage.stageHeight > 643){
							mc.tout1_mc.inner.y = ($stage.stageHeight-643)/2;
						}else mc.tout1_mc.inner.y = 0;
						
					}
				}
			);//end connect tout1
			Resize.add(
				"@ConnectTout2",
				mc.tout2_mc.inner,
				[Resize.CENTER_X, Resize.CUSTOM],
				{
					custom:	function($target:*, $params:*, $stage:Stage):void{
						mc.tout2_mc.inner.x -= __TOUT_OFFSET_X;
						if ($stage.stageHeight > 643){
							mc.tout2_mc.inner.y = ($stage.stageHeight-643)/2;
						}else mc.tout2_mc.inner.y = 0;
						
					}
				}
			);//end connect title
		}//end function
		// =================================================
		// ================ Core Handler
		// =================================================
		
		// =================================================
		// ================ Overrides
		// =================================================
		override protected function _onAnimateInStart():void{
			Out.status(this, "onAnimateInStart");
			
		}//end function
		
		override protected function _onAnimateIn():void{
			Out.status(this, "onAnimateIn(): but i can't see it");
		}//end function
		// =================================================
		// ================ Constructor
		// =================================================

		public function Connect($mc:MovieClip, $xml:XML, $useWeakReference:Boolean=false)
		{
			super($mc, $xml, $useWeakReference);
			_init();
		}//end constructor
		
	}//end class
}//end package