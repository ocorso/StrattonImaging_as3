package com.strattonimaging.site.display.components
{
	import com.asual.swfaddress.SWFAddress;
	import com.bigspaceship.display.StandardButton;
	import com.bigspaceship.display.StandardInOut;
	import com.bigspaceship.events.AnimationEvent;
	import com.bigspaceship.events.NavigationEvent;
	import com.bigspaceship.loading.BigLoader;
	import com.bigspaceship.utils.Out;
	import com.bigspaceship.utils.SimpleSequencer;
	
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class Gallery extends StandardInOut
	{
		private var _xml				:XMLList;
		private var _bl					:BigLoader;
		private var _ss					:SimpleSequencer;
		
		private var _prev				:StandardButton;
		private var _next				:StandardButton;
		private var _close				:StandardButton;
		private var _mainImg			:StandardInOut;
		private var _thumbs				:Thumbs;
		
		private var _curThumb			:String;
		private var _curImg				:Bitmap;
		
		private const _MAIN_IMG_WIDTH	:int = 400;
		private const _MAIN_IMG_HEIGHT	:int = 255;
		// =================================================
		// ================ Callable
		// =================================================		
		
		// =================================================
		// ================ Handlers
		// =================================================		
		private function _thumbChanged($ne:NavigationEvent):void{
			Out.status(this, "_thumbChanged: new id: "+$ne.info as String);
			
		}//end function 
		private function _closeHandler($mc:MouseEvent):void{
			_destroySequencer();
			_ss = new SimpleSequencer("galleryOut");
			
			SWFAddress.setValue("craft");
			//close img
			//close thumbs
			//hide arrows
			//hide close
			//animateOut();
		}//end function
		
		// =================================================
		// ================ Workers
		// =================================================		
		private function _init():void{
			Out.status(this, "init:: mainImage ID = "+_xml.loadable[0].@id.toString());
			mc.tf.txt.text = _xml.label.toString();
			
			//controls
			_prev = new StandardButton(mc.prev_mc, mc.prev_mc.btn);	
			_next = new StandardButton(mc.next_mc, mc.next_mc.btn);	
			_close = new StandardButton(mc.close_mc, mc.close_mc.btn);	
			_close.addEventListener(MouseEvent.CLICK, _closeHandler);
			
			//standardInOuts			
			_mainImg = new StandardInOut(mc.mainImg_mc);
			_changeMainImg(_xml.loadable[0].@id.toString());
			
			_thumbs = new Thumbs(mc.thumbs_mc);
			_thumbs.addEventListener(NavigationEvent.NAVIGATE, _thumbChanged);
			
			for(var e:String in _xml.loadable){
				Out.debug(this, _xml.loadable[e].@id);
				_thumbs.addThumb(_bl.getLoadedAssetById(_xml.loadable[e].@id.toString()));
			}//end for in
			_thumbs.current = 0;
			_curThumb = _xml.loadable[0].@id.toString();
			//mc.image.addChild(_bl.getLoadedAssetById(_xml.loadable[0].@id.toString()));
		}//end function
		private function _changeMainImg($id:String):void{
			var asset:Bitmap = Bitmap(_bl.getLoadedAssetById($id));
			var w:int = asset.bitmapData.width;
			Out.status(this, "_changeMainImg:: asset width: "+ w);
			asset.width = _MAIN_IMG_WIDTH;
			asset.height= _MAIN_IMG_HEIGHT;
			if(_mainImg.mc.img.ph.numChildren>1)_mainImg.mc.img.ph.removeChildAt(_mainImg.mc.img.ph.numChildren-1);
			var bm:Bitmap = new Bitmap(asset.bitmapData);
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
		// ================ Animation
		// =================================================
		private function _animateThumbsIn($evt:Event):void{
			Out.status(this, "WTF");
			_thumbs.animateIn();
		}
		private function _animateThumbsOut($evt:Event):void{
			Out.status(this, "WTF");
			_thumbs.animateOut();
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
			_ss.addEventListener(Event.COMPLETE, _animateThumbsOut,false,0,true);
			_ss.addStep(1, _mainImg.mc, _mainImg.animateOut, AnimationEvent.OUT);
			_ss.addStep(2, _thumbs.mc, super._animateOut, AnimationEvent.OUT);
			_ss.start();
			
		}//end function
		
		override protected function _onAnimateOut():void{
			Out.status(this, "_onAnimateOut");
		}//end function
		 
		 
		// =================================================
		// ================ Constructor
		// =================================================
		public function Gallery($mc:MovieClip, $imgList:XMLList, $bigLoader:BigLoader)
		{
			super($mc);
			_xml 	= $imgList;
			_bl		= $bigLoader;
			Out.status(this, "new gallery, length = "+ _xml.length());
			_init();
						
		}//end constructor

	}//end class
}//end package