package com.strattonimaging.site.display.screens.credits
{
	import com.bigspaceship.display.StandardInOut;
	import com.bigspaceship.events.AnimationEvent;
	import com.bigspaceship.utils.Out;
	import com.bigspaceship.utils.SimpleSequencer;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;

	public class Credit extends StandardInOut implements ICredit
	{
		protected var _i				:StandardItemInOut; //credit picture
		protected var _t				:StandardInOut; //credit text
		private var _ss					:SimpleSequencer;
		protected var _type				:String;
		protected var _i_mc				:MovieClip;

        private const _BG_WIDTH			:int = 576;
		private const _BG_HEIGHT		:int = 275;
// =================================================
// ================ Callable
// =================================================

// =================================================
// ================ Workers
// =================================================
        protected function _init():void{
        	
        	_i_mc = mc.item_mc.i;
        	_i = new StandardItemInOut(mc.item_mc);
        	_t = new StandardInOut(mc.text_mc);
        	
        }//end function
        
		protected function _destroySequencer():void{
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
		override protected function _animateIn():void{
			Out.status(this, "_animateIn");
			dispatchEvent(new AnimationEvent(AnimationEvent.IN_START)); 			
			_ss = new SimpleSequencer("In");
			_ss.addEventListener(Event.COMPLETE, _animateInSequencer_COMPLETE_handler);
			_ss.addStep(1, _i.mc, _i.animateIn, AnimationEvent.IN);
			_ss.addStep(2, _t.mc, _t.animateIn, AnimationEvent.IN);
			_ss.start();
		} //end fucntion
		override protected function _animateOut():void{
			Out.status(this, "_animateOut");
			_ss = new SimpleSequencer("Out");
			_ss.addEventListener(Event.COMPLETE, _animateOutSequencer_COMPLETE_handler);
			_ss.addStep(1, _t.mc, _t.animateOut, AnimationEvent.OUT);
			_ss.addStep(2, _i.mc, _i.animateOut, AnimationEvent.OUT);
			dispatchEvent(new AnimationEvent(AnimationEvent.OUT_START)); 
			_ss.start();
		} //end fucntion
        
// =================================================
// ================ Getters / Setters
// =================================================
        public function get type():String{ return _type;}
        public function set type($type:String):void{ _type= $type;}
        public function set isNextAnimation($isNext:Boolean):void{ _i.isNextAnimation = $isNext;}
// =================================================
// ================ Interfaced
// =================================================
        public function configure($asset:DisplayObject = null):void{
        	if ($asset){
        		var w:int = $asset.width;
        		if (w<_BG_WIDTH)	$asset.x = (_BG_WIDTH - w)/2;
        		_i_mc.removeChild(_i_mc.logo);
        		_i_mc.bg.width = w;
        		_i_mc.bg.x = $asset.x;
        		_i_mc.addChild($asset);
        		//remove white box
        		//add asset to where white box is
        	}//end if
        }//end function
        public function resetDirection():void{
        	_i.isNextAnimation = false;
        }
// =================================================
// ================ Core Handler
// =================================================
    	protected function _animateInSequencer_COMPLETE_handler($evt:Event = null):void{
			Out.status(this,"_realAnimateIn_handler()");
			_destroySequencer();
			super._onAnimateIn_handler();
		}
		protected function _animateOutSequencer_COMPLETE_handler($evt:Event = null):void{
			Out.status(this,"_realAnimateOut_handler()");
			_destroySequencer();
			super._onAnimateOut_handler();
		}     
// =================================================
// ================ Overrides
// =================================================
        
// =================================================
// ================ Constructor
// =================================================
		
		public function Credit($mc:MovieClip, $useWeakReference:Boolean=false)
		{
			super($mc, $useWeakReference);
			_dispatchCompleteOnUnchangedState = false;
			_init();
			
		}//end constructor
	}//end class
}//end package