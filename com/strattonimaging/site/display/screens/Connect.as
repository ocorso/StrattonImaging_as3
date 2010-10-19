package com.strattonimaging.site.display.screens
{
	import com.bigspaceship.display.StandardInOut;
	import com.bigspaceship.events.AnimationEvent;
	import com.bigspaceship.utils.Out;
	import com.bigspaceship.utils.SimpleSequencer;
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
		//standard in outs
		private var _bg				:StandardInOut;
		private var _content		:StandardInOut;
		
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
			_bg 		= new StandardInOut(mc.bg_mc);
			_content 	= new StandardInOut(mc.content_mc);			
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
		override protected function _animateIn():void{
			Out.status(this, "animateIn():: here is loadlist: "+_loadList);
			
			mc.visible = true;
			_destroySequencer();
			_ss = new SimpleSequencer("in");
			_ss.addEventListener(Event.COMPLETE,_animateInSequencer_COMPLETE_handler,false,0,true);
			_ss.addStep(1,_bg,_bg.animateIn,AnimationEvent.IN);
			_ss.addStep(2,_content,_content.animateIn,AnimationEvent.IN);
			_ss.start();
			
		}//end function _animateIn
		
		override protected function _animateOut():void{
			Out.status(this, "_animateOut");
			_destroySequencer();
			_ss = new SimpleSequencer("out");
			_ss.addEventListener(Event.COMPLETE, _animateOutSequencer_COMPLETE_handler, false, 0, true);
			_ss.addStep(3, _content.mc, _content.animateOut, AnimationEvent.OUT);
			_ss.addStep(4, _bg.mc, _bg.animateOut, AnimationEvent.OUT);
			_ss.start();
			
		}//end function _animateOut		
		// =================================================
		// ================ Getters / Setters
		// =================================================
		
		// =================================================
		// ================ Interfaced
		// =================================================
		public function setupButtons():void{
			_content.mc.tout2_mc.inner.emailBtn.addEventListener(MouseEvent.CLICK, _handleEmailClick);
		}//end function
		
		public function setupResize():void{
			
			Resize.add(
				"@ConnectGrad",
				_bg.mc.grad_mc.g,
				[Resize.FULLSCREEN_X, Resize.CUSTOM],
				{
					custom:	function($target:*, $params:*, $stage:Stage):void{
						//Out.debug(this, "grad w: "+mc.grad_mc.width+" grad h: "+mc.grad_mc.height+ " grad alpha: "+mc.grad_mc.alpha);
						if ($stage.stageHeight > 643) _bg.mc.grad_mc.g.height = $stage.stageHeight - (Constants.BOTTOM_OFFSET - 135);
						else _bg.mc.grad_mc.g.height = 389;
					}//end custom function
				}//end 4th resize add parameter
			);//end @Grad
			Resize.add(
				"@ConnectTitle",
				_content.mc.title_mc.inner,
				[Resize.CENTER_X, Resize.CUSTOM],
				{
					custom:	function($target:*, $params:*, $stage:Stage):void{
						_content.mc.title_mc.inner.x += 100;
						if ($stage.stageHeight > 643){
							_content.mc.title_mc.inner.y = ($stage.stageHeight-643)/2;
						}else _content.mc.title_mc.inner.y = 0;
						
					}
				}
			);//end connect title
			Resize.add(
				"@ConnectTout1",
				_content.mc.tout1_mc.inner,
				[Resize.CENTER_X, Resize.CUSTOM],
				{
					custom:	function($target:*, $params:*, $stage:Stage):void{
						_content.mc.tout1_mc.inner.x -= __TOUT_OFFSET_X;
						if ($stage.stageHeight > 643){
							_content.mc.tout1_mc.inner.y = ($stage.stageHeight-643)/2;
						}else _content.mc.tout1_mc.inner.y = 0;
						
					}
				}
			);//end connect tout1
			Resize.add(
				"@ConnectTout2",
				_content.mc.tout2_mc.inner,
				[Resize.CENTER_X, Resize.CUSTOM],
				{
					custom:	function($target:*, $params:*, $stage:Stage):void{
						_content.mc.tout2_mc.inner.x -= __TOUT_OFFSET_X;
						if ($stage.stageHeight > 643){
							_content.mc.tout2_mc.inner.y = ($stage.stageHeight-643)/2;
						}else _content.mc.tout2_mc.inner.y = 0;
						
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
		override protected function _onAnimateOut():void{
			//_mc.gotoAndStop("INIT");
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