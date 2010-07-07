package com.strattonimaging.site.display.screens
{
	import com.bigspaceship.display.StandardInOut;
	import com.bigspaceship.events.AnimationEvent;
	import com.bigspaceship.utils.Out;
	import com.bigspaceship.utils.SimpleSequencer;
	import com.strattonimaging.site.Constants;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	
	import net.ored.util.Resize;
	
	public class Learn extends Screen implements IScreen
	{
		
		private var _ss				:SimpleSequencer;
		private var _bg				:StandardInOut;
		private var _sections		:StandardInOut;
		private var _si				:StandardInOut;
		
		
        
// =================================================
// ================ Callable
// =================================================
        
// =================================================
// ================ Workers
// =================================================
		private function _init():void{
			_bg 		= new StandardInOut(mc.bg_mc);
			_sections 	= new StandardInOut(mc.sections_mc);
			
			setupButtons();
			setupResize();
			
		}//end function
		
		private function _destroySequencer():void{
			if(_ss){
				_ss.removeEventListener(Event.COMPLETE,_animateInSequencer_COMPLETE_handler);
				_ss.removeEventListener(Event.COMPLETE,_animateOutSequencer_COMPLETE_handler);
				_ss = null;
			}
		}//end function _destroySequencer
// =================================================
// ================ Handlers
// =================================================
        
// =================================================
// ================ Animation
// =================================================
        
// =================================================
// ================ Getters / Setters
// =================================================
        
// =================================================
// ================ Interfaced
// =================================================
		public override function onURLChange():void{
			super.onURLChange();
			Out.status(this, "we'd do something within the same screen here");
		}//end function
		
		public function setupResize():void{
			
			Resize.add(
				"@LearnGrad",
				_bg.mc.grad_mc.g,
				[Resize.FULLSCREEN_X, Resize.CUSTOM],
				{
				
					custom:				function($target, $params, $stage):void{
							if ($stage.stageHeight > Constants.STAGE_HEIGHT) _bg.mc.grad_mc.g.height = $stage.stageHeight - (Constants.BOTTOM_OFFSET - 135);
							else _bg.mc.grad_mc.g.height = Constants.BOTTOM_OFFSET;
					}//end custom function
				}//end 4th resize add parameter
			);//end @Grad
			Resize.add(
				"@LearnSections",
				_sections.mc,
				[Resize.CENTER_X, Resize.CUSTOM],
				{
					custom:	function($target, $params, $stage):void{
								if ($stage.stageHeight > Constants.STAGE_HEIGHT){
									_sections.mc.y = ($stage.stageHeight-Constants.STAGE_HEIGHT)/2;
					 			}else _sections.mc.y = 0;
					}//end custom function
				}//end 4 param
			);//end resize add @CraftServices
			
		}//end function
        
		public function setupButtons():void{
			_
		}//end function
        
// =================================================
// ================ Core Handler
// =================================================
        private function _animateInSequencer_COMPLETE_handler($evt:Event = null):void{
			Out.status(this,"_realAnimateIn_handler()");
			_destroySequencer();
			super._onAnimateIn_handler();
		}
		private function _animateOutSequencer_COMPLETE_handler($evt:Event = null):void{
			Out.status(this,"_realAnimateOut_handler()");
			_destroySequencer();
			super._onAnimateOut_handler();
		}
// =================================================
// ================ Overrides
// =================================================
		
		override protected function _onAnimateInStart():void{
			Out.status(this, "onAnimateInStart");
			
		}//end function
		
		override protected function _animateIn():void{
			Out.status(this, "animateIn():: here is loadlist: "+_loadList);
			
			mc.visible = true;
			_destroySequencer();
			_ss = new SimpleSequencer("in");
			_ss.addEventListener(Event.COMPLETE,_animateInSequencer_COMPLETE_handler,false,0,true);
			_ss.addStep(1,_bg,_bg.animateIn,AnimationEvent.IN);
			_ss.addStep(2,_sections,_sections.animateIn,AnimationEvent.IN);
			
			_ss.start();
			
		}//end function _animateIn
		
		override protected function _animateOut():void{
			Out.status(this, "_animateOut");
			_destroySequencer();
			_ss = new SimpleSequencer("out");
			_ss.addEventListener(Event.COMPLETE, _animateOutSequencer_COMPLETE_handler, false, 0, true);
			_ss.addStep(1, _sections.mc, _sections.animateOut, AnimationEvent.OUT);
			_ss.addStep(2, _bg.mc, _bg.animateOut, AnimationEvent.OUT);
			_ss.start();
			
		}//end function _animateOut
		override protected function _onAnimateOut():void{
			//_mc.gotoAndStop("INIT");
		}//end function
// =================================================
// ================ Constructor
// =================================================

		public function Learn($mc:MovieClip, $xml:XML, $useWeakReference:Boolean=false)
		{
			super($mc, $xml, $useWeakReference);
			_init();
		}//end constructor
		
		
	}//end class
}//end package