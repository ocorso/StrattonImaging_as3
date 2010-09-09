package com.strattonimaging.site.display.screens
{
	import com.asual.swfaddress.SWFAddress;
	import com.bigspaceship.display.StandardButton;
	import com.bigspaceship.display.StandardInOut;
	import com.bigspaceship.events.AnimationEvent;
	import com.bigspaceship.utils.Out;
	import com.bigspaceship.utils.SimpleSequencer;
	import com.strattonimaging.site.model.Constants;
	
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import net.ored.util.Resize;
	
	public class Learn extends Screen implements IScreen
	{
		//standard in outs
		private var _bg				:StandardInOut;
		private var _sections		:StandardInOut;
		private var _mainText		:StandardInOut;
		private var _seArrow		:StandardInOut;
		private var _siArrow		:StandardInOut;
		
		//standard buttons
		private var _se				:StandardButton;
		private var _si				:StandardButton;
		
        //boolean to keep track of where we are
        private var _bIsSE			:Boolean = true;
        
// =================================================
// ================ Callable
// =================================================
        
// =================================================
// ================ Workers
// =================================================
		private function _init():void{
			
			_bg 		= new StandardInOut(mc.bg_mc);
			_sections 	= new StandardInOut(mc.sections_mc);
			_mainText	= new StandardInOut(_sections.mc.mainText_mc);
			_seArrow	= new StandardInOut(_sections.mc.se_arrow);
			_siArrow	= new StandardInOut(_sections.mc.si_arrow);
			
			setupButtons();
			setupResize();
			
		}//end function
		
		private function _setMainText($evt:AnimationEvent = null):void{
			if ($evt) _mainText.removeEventListener(AnimationEvent.OUT, _setMainText);
			
			if (_bIsSE)	_mainText.mc.text_mc.tf.text = _xml.sections.section.(@id == "se").content.toString();
			else		_mainText.mc.text_mc.tf.text = _xml.sections.section.(@id == "si").content.toString();
			
			_mainText.animateIn();
		}//end function
// =================================================
// ================ Handlers
// =================================================
        private function _clickHandler($me:MouseEvent):void{
        	Out.status(this, "clickHandler():: clicked: "+ $me.target.mc.name);
        	if ($me.target.mc.name == "se_mc"){
        		_se.select();
        		_si.deselect();
        		_siArrow.animateOut();
        		_seArrow.animateIn();
        		_mainText.addEventListener(AnimationEvent.OUT, _setMainText);
        		_bIsSE = true;
        		_mainText.animateOut();
        	}//end if 
        	if ($me.target.mc.name == "si_mc"){
        		_si.select();
        		_se.deselect();
        		_seArrow.animateOut();
        		_siArrow.animateIn();
        		_mainText.addEventListener(AnimationEvent.OUT, _setMainText);
        		_bIsSE = false;
        		_mainText.animateOut();
        	}//end if 
				        	
        }//end function

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
			_ss.addStep(2,_sections,_sections.animateIn,AnimationEvent.IN);
			_ss.addStep(3,_seArrow,_seArrow.animateIn,AnimationEvent.IN);
			_ss.addStep(4, _mainText, _setMainText, AnimationEvent.IN);
			_ss.start();
			
		}//end function _animateIn
		
		override protected function _animateOut():void{
			Out.status(this, "_animateOut");
			_destroySequencer();
			_ss = new SimpleSequencer("out");
			_ss.addEventListener(Event.COMPLETE, _animateOutSequencer_COMPLETE_handler, false, 0, true);
			_ss.addStep(1, _mainText, _mainText.animateOut, AnimationEvent.OUT);
			if(_bIsSE)	_ss.addStep(2,_seArrow,_seArrow.animateOut,AnimationEvent.OUT);
			else 		_ss.addStep(2,_siArrow,_siArrow.animateOut,AnimationEvent.OUT);
			_ss.addStep(3, _sections.mc, _sections.animateOut, AnimationEvent.OUT);
			_ss.addStep(4, _bg.mc, _bg.animateOut, AnimationEvent.OUT);
			_ss.start();
			
		}//end function _animateOut
        
// =================================================
// ================ Getters / Setters
// =================================================
        
// =================================================
// ================ Interfaced
// =================================================
		public override function onURLChange():void{
			super.onURLChange();
			Out.status(this, "onURL Change");
			//SWF ADDRESS STUFF
			var swfArr:Array = SWFAddress.getPathNames(); // path should look something like this: craft/grand_format/2
			if(swfArr.length == 1) Out.debug(this, "swf length is 1");
			
		}//end function
		
		public function setupResize():void{
			
			Resize.add(
				"@LearnGrad",
				_bg.mc.grad_mc.g,
				[Resize.FULLSCREEN_X, Resize.CUSTOM],
				{
				
				custom:	function($target:*, $params:*, $stage:Stage):void{
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
				custom:	function($target:*, $params:*, $stage:Stage):void{
								if ($stage.stageHeight > Constants.STAGE_HEIGHT){
									_sections.mc.y = ($stage.stageHeight-Constants.STAGE_HEIGHT)/2;
					 			}else _sections.mc.y = 0;
					}//end custom function
				}//end 4 param
			);//end resize add @CraftServices
			
		}//end function
        
		public function setupButtons():void{
			
			_se = new StandardButton(_sections.mc.se_mc, _sections.mc.se_mc.btn);
			_se.mc.text_mc.tf.text = _xml.sections.section.(@id=="se").label.toString();
			_se.addEventListener(MouseEvent.CLICK, _clickHandler);
			_se.select();
			
			_si = new StandardButton(_sections.mc.si_mc, _sections.mc.si_mc.btn);
			_si.mc.text_mc.tf.text = _xml.sections.section.(@id=="si").label.toString();
			_si.addEventListener(MouseEvent.CLICK, _clickHandler);
		
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
		
		
		override protected function _onAnimateOut():void{}//end function
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