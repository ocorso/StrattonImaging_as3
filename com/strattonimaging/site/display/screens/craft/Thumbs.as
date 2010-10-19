package com.strattonimaging.site.display.screens.craft
{
	import com.bigspaceship.display.StandardButton;
	import com.bigspaceship.display.StandardInOut;
	import com.bigspaceship.events.AnimationEvent;
	import com.bigspaceship.utils.Lib;
	import com.bigspaceship.utils.Out;
	import com.bigspaceship.utils.SimpleSequencer;
	import com.strattonimaging.site.model.SiteModel;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	
	import net.ored.util.ORedUtils;

	public class Thumbs extends StandardInOut
	{
		private const _THUMB_HEIGHT		:int = 34;
		private const _THUMB_MAX_WIDTH	:int = 53;
		private const _THUMB_PADDING	:int = 6;
		private const _MASK_WIDTH		:Number = 418; 
		private const _MASK_HEIGHT		:Number = 52;
		private const _MASK_X			:Number = 0;
		private const _MASK_Y			:Number = 0;
		
		private var _m					:SiteModel;
		private var _thumbsDict			:Dictionary;
		private var _thumbsVect			:Vector.<StandardInOut>;
		
		private var _ss					:SimpleSequencer;
		private var _current			:int;

// =================================================
// ================ Callable
// =================================================
		public function addThumb($asset:*):void{
			Out.status(this, "addThumb; _current: "+_current);
			$asset.height 	= _THUMB_HEIGHT;
			$asset.width 	= _THUMB_MAX_WIDTH;
			var id:String 	= "t"+_current;
			//new dynamic thumbs, gimmeRect IS a function!
			var thumbMask:Sprite = _gimmeRect(_MASK_WIDTH,_MASK_HEIGHT);
			var thumbClip:MovieClip = Lib.createAsset("com.strattonimaging.site.display.screens.craft.ThumbClip",_m.siteAssets) as MovieClip;
			thumbClip.x = _current*(_THUMB_MAX_WIDTH + _THUMB_PADDING);
			thumbClip.name = id;
			thumbClip.mc.img.addChild($asset);
			thumbClip.mask = thumbMask;
			mc.addChild(thumbMask);
			mc.addChild(thumbClip);
			
			_thumbsDict[id] = new StandardButton(thumbClip.mc, thumbClip.mc.btn);
			_thumbsVect.push(new StandardInOut(thumbClip));	
			_thumbsDict[id].addEventListener(MouseEvent.CLICK, _thumbClickHandler);
			_current++;
		}//end function
		
		public function changeThumb($deselectThis:int):void{
			_thumbsDict["t"+$deselectThis].deselect();
			_thumbsDict["t"+current].select();
			dispatchEvent(new Event(Event.CHANGE));
		}//end function
		
		public function killThumbs():void{
			Out.status(this, "killThumbs");
			for each(var s:StandardButton in _thumbsDict){
				s.mc.visible = false;
				//s.destroy();
			}
			
		}//end function
// =================================================
// ================ Workers
// =================================================
	private function _init():void{
		_m 			= SiteModel.getInstance();
		_thumbsDict = new Dictionary();
		_thumbsVect = new Vector.<StandardInOut>();
	}//end function
	
	/**
	 * This is a function that returns a sprite that is a rectangle 
	 * filled with either red or cyan (#00FFFF)
	 *  
	 * @param $w - width of the rectangle
	 * @param $h - height of the rectange
	 * 
	 * @return - the newly created sprite
	 * 
	 */		
	private function _gimmeRect($w:Number, $h:Number):Sprite{
		var r:Sprite = new Sprite();
		r.graphics.beginFill(0x00FFFF,1);
		r.graphics.drawRect(0,0,$w,$h);
		r.graphics.endFill();
		return r;
	}//end function 
	
	private function _destroySequencer():void{
		if(_ss){
				_ss.removeEventListener(Event.COMPLETE,_animateInSequencer_COMPLETE_handler);
				_ss.removeEventListener(Event.COMPLETE,_animateOutSequencer_COMPLETE_handler);
				_ss = null;
			}
	}//end function
// =================================================
// ================ Handlers
// =================================================
		private function _thumbClickHandler($me:MouseEvent):void{
			
			var s:String = StandardButton($me.target).mc.parent.name;
			Out.status(this, "_thumbClickHandler: "+ s);
			for(var e:String in _thumbsDict) _thumbsDict[e].deselect();
			//_thumbsDict["t0"].deselect();
			_thumbsDict[s].select();
			//_thumbsDict["t"+current].deselect();
			current = s.charAt(1);
			Out.debug(this, "current = "+current);
			dispatchEvent(new Event(Event.CHANGE));
		}//end function

// =================================================
// ================ Getters / Setters
// =================================================
		public function get current():int{ return _current;}
		public function set current($i:*):void{  _current= $i;}
		
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
			Out.status(this, "animateIn()");
			
			mc.visible = true;
			_destroySequencer();
			_ss = new SimpleSequencer("in");
			_ss.addEventListener(Event.COMPLETE,_animateInSequencer_COMPLETE_handler,false,0,true);
			var n:uint=0
			for each(var s:StandardInOut in _thumbsVect){
				n++;
				_ss.addStep(n, s.mc, s.animateIn, "NEXT_IN");
			}//end for each
			_ss.start();
			
		}//end function _animateIn
		override protected function _animateOut():void{
			Out.status(this, "animateOut()");
			Out.debug(this, "thumbsVect length: "+ _thumbsVect.length);
			_destroySequencer();
			_ss = new SimpleSequencer("out");
			_ss.addEventListener(Event.COMPLETE,_animateOutSequencer_COMPLETE_handler,false,0,true);
			var n:int = 0;
			for(var i:int = _thumbsVect.length-1; i>=0; i--){
				_ss.addStep(n, _thumbsVect[i].mc, _thumbsVect[i].animateOut, "NEXT_OUT");
				n++;
			}//end for
			_ss.start();
			
		}//end function _animateIn

		override protected function _onAnimateIn():void{
			//deselect all thumbs prior to showing the thumbs.
			for each(var s:StandardButton in _thumbsDict){s.deselect();}
			_thumbsDict["t"+ (_current-1)].select();
		}
		override protected function _onAnimateOut():void{
			for each(var s:StandardButton in _thumbsDict){s.deselect();}
			mc.visible = false;
			dispatchEvent(new AnimationEvent(AnimationEvent.OUT));
			_m.currentThumb = 1;
		}
// =================================================
// ================ Constructor
// =================================================

		public function Thumbs($mc:MovieClip, $useWeakReference:Boolean=true)
		{
			super($mc);
			_init();

		}//end constructor
		
	}//end class
}//end package