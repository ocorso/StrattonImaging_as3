package com.strattonimaging.site.display.components
{
	import com.bigspaceship.display.StandardButton;
	import com.bigspaceship.display.StandardInOut;
	import com.bigspaceship.events.AnimationEvent;
	import com.bigspaceship.utils.Out;
	import com.bigspaceship.utils.SimpleSequencer;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;

	public class Thumbs extends StandardInOut
	{
		private const _THUMB_HEIGHT		:int = 34;
		private const _THUMB_MAX_WIDTH	:int = 53;
		
		private var _thumbsDict				:Dictionary;
		
		private var _ss					:SimpleSequencer;
		private var _current			:int;

// =================================================
// ================ Callable
// =================================================
		public function addThumb($asset:*):void{
			
			$asset.height = _THUMB_HEIGHT;
			$asset.width = _THUMB_MAX_WIDTH;
			
			var id:String = "t"+_current;
			mc[id].img.addChild($asset);
			_thumbsDict[id] = new StandardButton(mc[id], mc[id].btn);
			_thumbsDict[id].addEventListener(MouseEvent.CLICK, _thumbClickHandler);
			
			_current++;
		}//end fucntion
// =================================================
// ================ Workers
// =================================================
	private function _destroySequencer():void{
		if(_ss){
				_ss.removeEventListener(Event.COMPLETE,_animateInSequencer_COMPLETE_handler);
				_ss.removeEventListener(Event.COMPLETE,_animateOutSequencer_COMPLETE_handler);
				_ss = null;
			}
	}
// =================================================
// ================ Handlers
// =================================================
		private function _thumbClickHandler($me:MouseEvent):void{
			Out.status(this, "_thumbClickHandler: "+ $me.target.parent.name);
			
		}//end function

// =================================================
// ================ Getters / Setters
// =================================================
		public function get current():int{ return _current;}
		public function set current($i):void{  _current= $i;}
		
// =================================================
// ================ Core Handler
// =================================================		
		private function _animateInSequencer_COMPLETE_handler($evt:Event = null):void{
			Out.status(this,"_realAnimateIn_handler()");
			_destroySequencer();
			//do other onAnimateIn stuff 
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
		override protected function _animateIn():void{
			Out.status(this, "animateIn");
			_ss = new SimpleSequencer("ThumbsIn");
			_ss.addEventListener(Event.COMPLETE, _animateInSequencer_COMPLETE_handler);
			_ss.addStep(1, _thumbsDict["t0"].mc, _thumbsDict["t0"].select, AnimationEvent.ROLL_OVER);
			_ss.start();
		}//end function 
		override protected function _animateOut():void{
			Out.status(this, "animateOut");
			_ss = new SimpleSequencer("ThumbsOut");
			_ss.addEventListener(Event.COMPLETE, _animateOutSequencer_COMPLETE_handler);

			for each(var s:StandardButton in _thumbsDict){_ss.addStep(1, s.mc, s.deselect, AnimationEvent.ROLL_OUT);}//end for each
			_ss.start();
		}//end function 
// =================================================
// ================ Constructor
// =================================================

		public function Thumbs($mc:MovieClip, $useWeakReference:Boolean=true)
		{
			super($mc, $useWeakReference);
			_thumbsDict = new Dictionary();
		}//end constructor
		
	}//end class
}//end package