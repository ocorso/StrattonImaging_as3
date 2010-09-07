package com.strattonimaging.site.display.screens
{
	import __AS3__.vec.Vector;
	
	import com.bigspaceship.display.StandardButton;
	import com.bigspaceship.display.StandardInOut;
	import com.bigspaceship.events.AnimationEvent;
	import com.bigspaceship.utils.Out;
	import com.bigspaceship.utils.SimpleSequencer;
	import com.strattonimaging.site.model.Constants;
	import com.strattonimaging.site.display.screens.credits.Carousel;
	import com.strattonimaging.site.display.screens.credits.Credit;
	import com.strattonimaging.site.display.screens.credits.CreditFactory;
	import com.strattonimaging.site.display.screens.credits.ICredit;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import net.ored.util.Resize;

	public class Credits extends Screen implements IScreen
	{
		//standard in outs
		private var _bg						:StandardInOut;						
		private var _clapper				:StandardInOut;	
		private var _carousel				:StandardInOut;	
		
		//standard buttons
		private var _prev					:StandardButton;
		private var _next					:StandardButton;		
				
		//credit stuff		
		private var _creditsList			:Vector.<Credit>;
		private var _cc						:int = 0;//current credit, defaults to 0
		private var _cs						:SimpleSequencer; //credits sequencer

		//linked-list position indicators
		private var _direction				:int;
		private const __NEXT_END			:int = 0;
		private const __NEXT				:int = 1;
		private const __BEGINNING			:int = 2;
		private const __PREV				:int = 3;
        
// =================================================
// ================ Callable
// =================================================
        
// =================================================
// ================ Workers
// =================================================
		private function _init():void{
			Out.status(this, "init");
			
			_bg 		= new StandardInOut(mc.bg_mc);
			_clapper 	= new StandardInOut(mc.clapper_mc);
			_carousel	= new Carousel(mc.carousel_mc);
			_creditsList= new Vector.<Credit>();
			
			setupButtons();
			setupResize();
		}//end function
		
				
		private function _populateCarousel():void{
			Out.status(this, "_populateCarousel():");
			
			var vc:ICredit = CreditFactory.createCredit(Constants.TYPE_VID, "The Other Guys Trailer", mc);
			_creditsList.push(vc);
			//todo: look at swfaddress to determine current credit.
			_carousel.mc.addChild(_creditsList[_cc].mc);
			
			for(var i:int=0;i<_xml.loadables.loadable.length();i++) {
				var id:String = _xml.loadables.loadable[i].@id.toString();
				Out.debug(this, "credit id= "+id);
				var c:ICredit = CreditFactory.createCredit(Constants.TYPE_IMG, _xml.loadables.loadable[i].toString(), mc);
				
				c.configure(_loader.getLoadedAssetById(id));
				_creditsList.push(c);
				_carousel.mc.addChild(c.mc);
								
			}//end for			
		}//end fucntion
		private function _destroyCreditSequencer():void{
			if(_cs){
				_cs.removeEventListener(Event.COMPLETE, _csCompleteHandler);
				_cs = null;
			}//end if
				
		}//end function
// =================================================
// ================ Handlers
// =================================================
		private function _nextHandler($me:MouseEvent):void{
			Out.status(this, "nextHandler:: current= "+_cc); 
			_creditsList[_cc].isNextAnimation = true;
			_cs = new SimpleSequencer("creditSeqIn");
			_cs.addEventListener(Event.COMPLETE, _csCompleteHandler);
			_cs.addStep(1, _creditsList[_cc], _creditsList[_cc].animateOut, AnimationEvent.OUT);
			
			if(_cc<_creditsList.length-1){
				_direction = __NEXT;
				_creditsList[_cc+1].isNextAnimation = true;
				_cs.addStep(2, _creditsList[_cc+1], _creditsList[_cc+1].animateIn, AnimationEvent.IN);
			}else{
				_direction = __NEXT_END;
				_creditsList[0].isNextAnimation = true;
				_cs.addStep(2, _creditsList[0], _creditsList[0].animateIn, AnimationEvent.IN);
			}
			_cs.start();
			
		}//end function
		private function _prevHandler($me:MouseEvent):void{
			Out.status(this, "prevHandler:: current = "+_cc); 
			_cs = new SimpleSequencer("creditSeqIn");
			_cs.addEventListener(Event.COMPLETE, _csCompleteHandler);
			_cs.addStep(1, _creditsList[_cc], _creditsList[_cc].animateOut, AnimationEvent.OUT);
			if(_cc > 0){
				_direction = __PREV;
				_cs.addStep(2, _creditsList[_cc-1], _creditsList[_cc-1].animateIn, AnimationEvent.IN);
			}else{
				_direction = __BEGINNING;
				_cs.addStep(2, _creditsList[_creditsList.length-1], _creditsList[_creditsList.length-1].animateIn, AnimationEvent.IN);
			}
			_cs.start();
			
		}//end function
		private function _csCompleteHandler($e:Event):void{
			_creditsList[_cc].resetDirection();
			switch (_direction){
				case  	__NEXT 			:	_cc++; break; 
				case	__NEXT_END		:	_cc = 0; break;  
				case	__BEGINNING		:	_cc = _creditsList.length-1; break;  
				case	__PREV			:	_cc--; break;  
			}//end switch
			_creditsList[_cc].resetDirection();
			_destroyCreditSequencer();
		}//end function
// =================================================
// ================ Animation
// =================================================
		//override protected function _onAnimateInStart():void{}
		override protected function _animateIn():void{
			Out.status(this, "animateIn():: here is loadlist: "+_loadList);
			
			mc.visible = true;
			_destroySequencer();
			_ss = new SimpleSequencer("in");
			_ss.addEventListener(Event.COMPLETE,_animateInSequencer_COMPLETE_handler,false,0,true);
			_ss.addStep(1,_bg,_bg.animateIn,AnimationEvent.IN);
			_ss.addStep(2,_clapper,_clapper.animateIn,AnimationEvent.IN);
			if (_creditsList[_cc].type == Constants.TYPE_VID)
				_ss.addStep(4,_creditsList[_cc],_creditsList[_cc].configure, Constants.VIDEO_READY);
			_ss.addStep(5, _creditsList[_cc], _creditsList[_cc].animateIn, AnimationEvent.IN);
			_ss.addStep(6,_carousel,_carousel.animateIn,AnimationEvent.IN);
			
			_ss.start();
			
		}//end function _animateIn
		
		override protected function _animateOut():void{
			Out.status(this, "_animateOut");
			_destroySequencer();
			_ss = new SimpleSequencer("out");
			_ss.addEventListener(Event.COMPLETE, _animateOutSequencer_COMPLETE_handler, false, 0, true);
			_ss.addStep(1, _carousel, _carousel.animateOut, AnimationEvent.OUT);			
			_ss.addStep(2, _creditsList[_cc], _creditsList[_cc].animateOut, AnimationEvent.OUT);
			_ss.addStep(3, _clapper, _clapper.animateOut, AnimationEvent.OUT);
			_ss.addStep(4, _bg, _bg.animateOut, AnimationEvent.OUT);
			_ss.start();
			
		}//end function _animateOut
		//override protected function _onAnimateIn():void{}
		override protected function _onAnimateOut():void{}
        
        
// =================================================
// ================ Getters / Setters
// =================================================
        
// =================================================
// ================ Interfaced
// =================================================
		public function setupResize():void
		{
			Resize.add(
				"@CreditsGrad",
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
				"@CreditsCarousel",
				_carousel.mc,
				[Resize.CENTER_X, Resize.CUSTOM],
				{
					custom:	function($target, $params, $stage):void{
								if ($stage.stageHeight > Constants.STAGE_HEIGHT){
									_carousel.mc.y = ($stage.stageHeight-Constants.STAGE_HEIGHT)/2;
					 			}else _carousel.mc.y = 0;
					}//end custom function
				}//end 4 param
			);//end resize add @CreditsCarousel
			
		}//end function setupResize
        		
		
		public function setupButtons():void{
			Out.status(this, "setupButtons");
			_prev = new StandardButton(_carousel.mc.prev_mc, _carousel.mc.prev_mc.btn);
			_prev.addEventListener(MouseEvent.CLICK, _prevHandler);
			_next = new StandardButton(_carousel.mc.next_mc, _carousel.mc.next_mc.btn);
			_next.addEventListener(MouseEvent.CLICK, _nextHandler);
			
		}//end function
		
// =================================================
// ================ Core Handler
// =================================================

// =================================================
// ================ Overrides
// =================================================
		override protected function _loadComplete($evt:Event):void{ 
			
			_populateCarousel();
			super._loadComplete($evt);
		}//end function
// =================================================
// ================ Constructor
// =================================================
		
		public function Credits($mc:MovieClip, $xml:XML, $useWeakReference:Boolean=false)
		{
			super($mc, $xml, $useWeakReference);
			_init();
		}//end constructor

	}//end class
}//end package