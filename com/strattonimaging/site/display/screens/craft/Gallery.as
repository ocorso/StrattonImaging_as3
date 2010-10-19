package com.strattonimaging.site.display.screens.craft
{
	import com.asual.swfaddress.SWFAddress;
	import com.bigspaceship.display.StandardButton;
	import com.bigspaceship.display.StandardInOut;
	import com.bigspaceship.events.AnimationEvent;
	import com.bigspaceship.loading.BigLoader;
	import com.bigspaceship.utils.Out;
	import com.bigspaceship.utils.SimpleSequencer;
	import com.strattonimaging.site.model.SiteModel;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class Gallery extends StandardInOut
	{
		private var _m			:SiteModel;
		
		private var _xml				:XMLList;
		private var _bl					:BigLoader;
		private var _ss					:SimpleSequencer;
		
		private var _prev				:StandardButton;
		private var _next				:StandardButton;
		private var _close				:StandardButton;
		private var _mainImg			:StandardInOut;
		private var _thumbs				:Thumbs;
		private var _thumbs_mc			:MovieClip;
		private var _curThumbId			:String;
		private var _curImg				:Bitmap;
		
		private const _MAIN_IMG_WIDTH	:int = 400;
		private const _MAIN_IMG_HEIGHT	:int = 255;
		// =================================================
		// ================ Callable
		// =================================================		
		
			
		// =================================================
		// ================ Workers
		// =================================================		
		private function _init():void{
			Out.status(this, "init");
			mc.tf.txt.text = _xml.label.toString();
			_curThumbId = _xml.loadable[_m.currentThumb-1].@id.toString();
			Out.debug(this, "_curThumbId: "+ _curThumbId);
			//controls
			_prev = new StandardButton(mc.prev_mc, mc.prev_mc.btn);	
			_prev.addEventListener(MouseEvent.CLICK, _prevHandler);
			_next = new StandardButton(mc.next_mc, mc.next_mc.btn);
			_next.addEventListener(MouseEvent.CLICK, _nextHandler);
				
			_close = new StandardButton(mc.close_mc, mc.close_mc.btn);	
			_close.addEventListener(MouseEvent.CLICK, _closeHandler);
			
			//standardInOuts			
			_mainImg = new StandardInOut(mc.mainImg_mc);
			_thumbs = new Thumbs(mc.thumbs_mc);
			_thumbs.addEventListener(Event.CHANGE, _thumbChanged);
			
			
			for(var e:String in _xml.loadable){
				Out.debug(this, "index: "+ e);
				Out.debug(this, _xml.loadable[e].@id);
				_thumbs.addThumb(_bl.getLoadedAssetById(_xml.loadable[e].@id.toString()));
			}//end for in
			_thumbs.current = _m.currentThumb;
			_curThumbId = _xml.loadable[_m.currentThumb-1].@id.toString();
			_changeMainImg();
			Out.debug(this, "_curThumbId: "+_curThumbId);
		}//end function
		
		private function _changeMainImg():void{
			var bmd:BitmapData = Bitmap(_bl.getLoadedAssetById(_curThumbId)).bitmapData.clone();
			var bm:Bitmap = new Bitmap(bmd);
			var w:int = bmd.width;
			Out.status(this, "_changeMainImg:: asset width: "+ w);
			//bm.width = _MAIN_IMG_WIDTH;
			bm.height= _MAIN_IMG_HEIGHT;
			if(_mainImg.mc.img.ph.numChildren>1)_mainImg.mc.img.ph.removeChildAt(_mainImg.mc.img.ph.numChildren-1);
			if(w<_MAIN_IMG_WIDTH) bm.x = (_MAIN_IMG_WIDTH-w)/2;
			_mainImg.mc.img.ph.addChild(bm);
			
		}//end function
		private function _destroySequencer():void{
			if(_ss){
				_ss.removeEventListener(Event.COMPLETE,super._animateIn);
				_ss.removeEventListener(Event.COMPLETE,super._animateOut);
				_ss = null;
			}
		}//end function
		// =================================================
		// ================ Handlers
		// =================================================
		private function _thumbChanged($evt:Event = null):void{
			var c:int = _thumbs.current +1;
			_curThumbId = _xml.@type+"_"+c;
			Out.status(this, "_thumbChanged: new id: "+ _curThumbId);
			_changeMainImg();
			SWFAddress.setValue(_m.currentScreen+"/"+_m.currentSection+"/"+c);
			
		}//end function 
		private function _closeHandler($evt:Event=null):void{
			
			SWFAddress.setValue("craft");
	
		}//end function
		
		private function _prevHandler($me:MouseEvent):void{
			var c:int = _thumbs.current;
			Out.status(this, "prevHandler:: current = "+c);
			if (c>0){
				_thumbs.current--;
				_thumbs.changeThumb(c);				
			}
		}//end function
		private function _nextHandler($me:MouseEvent):void{
			var c:int = _thumbs.current;
			Out.status(this, "nextHandler:: current = "+c);
			if (c<_xml.loadable.length()-1){
				_thumbs.current++;
				_thumbs.changeThumb(c);
			}
		}//end function
		// =================================================
		// ================ Animation
		// =================================================
		private function _animateThumbsIn($evt:Event):void{
			Out.status(this, "WTF");
			_thumbs.animateIn();
		}
		private function _animateOutCompleteHandler($evt:Event):void{
			Out.status(this, "_animateOutCompleteHandler");
			//dispatchEvent(new Event(Event.CHANGE));		
		}
		private function _animateControlsIn($evt:Event=null):void{
			super._animateIn();
		}
		// =================================================
		// ================ Overrides
		// =================================================
		override protected function _animateIn():void{
			
			_destroySequencer();
			_ss = new SimpleSequencer("In");
			_ss.addEventListener(Event.COMPLETE, _animateThumbsIn,false,0,true);
			_ss.addStep(1, _mainImg.mc, _mainImg.animateIn, AnimationEvent.IN);
			_ss.addStep(2, mc,   _animateControlsIn, AnimationEvent.IN);
			_ss.start();
			
		}//end function
		
		override protected function _animateOut():void{
			
			_destroySequencer();
			_ss = new SimpleSequencer("Out");
			_ss.addEventListener(Event.COMPLETE, _animateOutCompleteHandler,false,0,true);
			_ss.addStep(1, _thumbs, _thumbs.animateOut, AnimationEvent.OUT);
			_ss.addStep(2, _mainImg.mc, _mainImg.animateOut, AnimationEvent.OUT);
			_ss.addStep(3, this, super._animateOut, AnimationEvent.OUT);
			_ss.start();
			
		}//end function
		
		override protected function _onAnimateOut():void{
			Out.status(this, "_onAnimateOut");
			_thumbs.current = 0;
			_thumbs.killThumbs();
			_thumbs.destroy();
		}//end function
		 
		 
		// =================================================
		// ================ Constructor
		// =================================================
		public function Gallery($mc:MovieClip, $thumbs:MovieClip, $imgList:XMLList, $bigLoader:BigLoader)
		{
			super($mc);
			_thumbs_mc 	= $thumbs;
			_xml 		= $imgList;
			_bl			= $bigLoader;
			_m 	= SiteModel.getInstance();
			Out.status(this, "new gallery, length = "+ _xml.loadable.length());
			_init();
						
		}//end constructor

	}//end class
}//end package