package com.strattonimaging.site.display.screens
{
	import com.asual.swfaddress.SWFAddress;
	import com.bigspaceship.display.StandardButtonInOut;
	import com.bigspaceship.display.StandardInOut;
	import com.bigspaceship.events.AnimationEvent;
	import com.bigspaceship.utils.Out;
	import com.bigspaceship.utils.SimpleSequencer;
	import com.strattonimaging.site.Constants;
	import com.strattonimaging.site.display.components.Gallery;
	import com.strattonimaging.site.model.SiteModel;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	import net.ored.util.Resize;
	
	public class Craft extends Screen implements IScreen{
		
		private var _serviceIdsToItems			:Dictionary;
		private var _serviceItemsToIds			:Dictionary;
		private var _serviceIds					:Array;
		
		private var _ss							:SimpleSequencer;

		private const _IMAGE_HEIGHT				:Number = 255;
		private const _IMAGE_MAX_WIDTH			:Number = 400;
		private const _sX						:Number = 150;
		private const _sY						:Number = 140;
		
		private const _XBLUR_COMPLETE			:String = "cross_blur_complete";
		
		
		private var _bGalleryIn					:Boolean = false;
		
		private var _bg							:StandardInOut;
		private var _title						:StandardInOut;
		private var _services					:StandardInOut;
		private var _currentService				:String;
		private var _gallery					:Gallery;
		private var _p							:Point // holds original x y position... do we need this? or just show new 

		// =================================================
		// ================ Callable
		// =================================================
		public function setupButtons():void{
			_serviceIdsToItems = new Dictionary(true);
			_serviceItemsToIds = new Dictionary(true);
			
			//setup services
			for(var i:int=0;i<_xml.loadables.length();i++) {
				var id:String = _xml.loadables[i].@type.toString();
				//setup service btns
				_serviceIdsToItems[id] = new StandardButtonInOut(_services.mc["s"+i], _services.mc["s"+i].btn);					
				Out.info(this, "the id of this service is: "+ id);
				_serviceIdsToItems[id].mc.tf.txt.text = _xml.loadables[i].label.toString();
				_serviceIdsToItems[id].addEventListener(MouseEvent.CLICK,_serviceOnClick,false,0,true);
				_serviceIdsToItems[id].addEventListener(AnimationEvent.IN,_serviceOnAnimateIn,false,0,true);
				_serviceItemsToIds[_serviceIdsToItems[id]] = id;
			}//end for			
		}//end function
		public function setupResize():void{
			
			Resize.add(
				"@CraftGrad",
				_bg.mc.grad_mc.g,
				[Resize.FULLSCREEN_X, Resize.CUSTOM],
				{
					custom:	function($target, $params, $stage):void{
						
							if ($stage.stageHeight > Constants.STAGE_HEIGHT) _bg.mc.grad_mc.g.height = $stage.stageHeight - (Constants.BOTTOM_OFFSET - 135);
							else _bg.mc.grad_mc.g.height = Constants.BOTTOM_OFFSET;
					
					}//end custom function
				}//end 4th resize add parameter
			);//end @Grad
			
			Resize.add(
				"@CraftTitle",
				_title.mc,

				[Resize.CENTER_X, Resize.CUSTOM],
				{
					custom:	function($target, $params, $stage):void{
								if ($stage.stageHeight > Constants.STAGE_HEIGHT)	_title.mc.y = ($stage.stageHeight-Constants.STAGE_HEIGHT)/2;
					 			else _title.mc.y = 0;
					}//end custom function
				}//end 4 param
			);//end resize add @CraftTitle
			
			Resize.add(
				"@CraftServices",
				_services.mc,
				[Resize.CENTER_X, Resize.CUSTOM],
				{
					custom:	function($target, $params, $stage):void{
								if ($stage.stageHeight > Constants.STAGE_HEIGHT){
									_services.mc.y = ($stage.stageHeight-Constants.STAGE_HEIGHT)/2;
					 			}else _services.mc.y = 0;
					}//end custom function
				}//end 4 param
			);//end resize add @CraftServices
		}//end function
		
		
		
		public override function onURLChange():void{
			super.onURLChange();
			
			//if(!_bGalleryIn && _vidId!=null) _thumbDict[_vidId+"_btn"].deselect();
			
			//SWF ADDRESS STUFF
			var swfArr:Array = SWFAddress.getPathNames(); // path should look something like this: contradictionary/top10/3453
			if(swfArr.length > 1 && _xml.loadables.(@type==swfArr[2])){
				_currentService = swfArr[2];
			}
				
			//this is what we do as a defualt
			else{
				if(_currentService == null) _currentService = _xml.loadables[0].@type;
			}
			
			//if(!_bGalleryIn) _gallery.swap();
			//_thumbDict[_vidId+"_btn"].select();
		}
		
		override public function get xml():XML{
			return _xml;
		}
		// =================================================
		// ================ Workers
		// =================================================
		
		private function _serviceOnAnimateIn($evt:Event):void{
			Out.status(this, "_serviceOnAnimateIn()::");
		}
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
			//_destroyGallery();
			super._onAnimateOut_handler();
		}
		
		
		
		private function _serviceOnClick($me:MouseEvent):void{
			Out.status(this, "_serviceOnClick(): target: "+ $me.target);
			
			var tempS:StandardButtonInOut = $me.target as StandardButtonInOut;
			_currentService = _serviceItemsToIds[tempS];
			Out.debug(this, _currentService);
			//hide all 
			_hideServices();
			
		}//end function 
		private function _showServices($evt:Event):void{
			Out.status(this, "_showServices(): show next gallery");
			_destroySequencer();
			_ss = new SimpleSequencer("showServices");
			_ss.addEventListener(Event.COMPLETE,_onShowServices,false,0,true);
			// oc: services
		 	var n:uint=0
			for each(var s:StandardButtonInOut in _serviceIdsToItems){
				_ss.addStep((n+1), s.mc, s.animateIn, "NEXT_IN");
				n++;
			}
			_ss.start();
			
		}//end function showServices
		private function _onShowServices($evt:Event):void{
			Out.status(this, "_onShowServices()");
			_bGalleryIn = false;
			_destroyGallery();
		}
		private function _hideServices():void{
			_destroySequencer();
			_ss = new SimpleSequencer("hideServices");
			_ss.addEventListener(Event.COMPLETE,_onHideServices,false,0,true);
			// oc: services
		 	var n:uint=0
			for each(var s:StandardButtonInOut in _serviceIdsToItems){
				_ss.addStep((n+1), s.mc, s.animateOut, "NEXT_OUT");
				n++;
			}
			_ss.start();
		}//end function _hideServices
		private function _onHideServices($evt:Event){
			Out.status(this, "_onHideServices");
			if(_gallery) _gallery.destroy();
			_bGalleryIn = true;
			_gallery	= new Gallery(_services.mc.gallery_mc, getNodeByType(SiteModel.CONFIG_LOADABLES, _currentService), _loader);
			_gallery.addEventListener(AnimationEvent.OUT, _showServices);
			_gallery.animateIn();
			SWFAddress.setValue("craft/"+_currentService);
//			_serviceIdsToItems(_currentService).animateIn();
		}
		private function _destroyGallery():void{
			_gallery.removeEventListener(AnimationEvent.OUT, _showServices);
			_gallery = null;
			
		}//end function destroy gallery
		private function _destroySequencer():void{
			if(_ss){
				_ss.removeEventListener(Event.COMPLETE,_animateInSequencer_COMPLETE_handler);
				_ss.removeEventListener(Event.COMPLETE,_animateOutSequencer_COMPLETE_handler);
				_ss.removeEventListener(Event.COMPLETE,_onHideServices);
				_ss.removeEventListener(Event.COMPLETE,_onShowServices);
				_ss = null;
			}
		}//end function _destroySequencer
		
		// =================================================
		// ================ Overrides
		// =================================================
		override protected function _animateIn():void{
			//Out.status(this, "animateIn():: here is loadlist: "+_loadList);
			
			mc.visible = true;
			_destroySequencer();
			_ss = new SimpleSequencer("in");
			_ss.addEventListener(Event.COMPLETE,_animateInSequencer_COMPLETE_handler,false,0,true);
			_ss.addStep(1,_bg,_bg.animateIn,AnimationEvent.IN);
			_ss.addStep(2,_title,_title.animateIn,AnimationEvent.IN);
			
			// oc: services
			var n:uint=0
			for each(var s:StandardButtonInOut in _serviceIdsToItems){
				Out.debug(this, "animating "+s.mc +" in");
				_ss.addStep(2 + (n+1), s.mc, s.animateIn, "NEXT_IN");
				n++;
			}
			//_ss.addStep(21,this,_crossBlur,_XBLUR_COMPLETE;
			_ss.start();
			
		}//end function _animateIn
		override protected function _onAnimateOut():void{
		}//end function
		//override protected function _onAnimateIn():void { _siteModel.track(); }
		
		override protected function _animateOut():void{
			Out.status(this, "_animateOut, here is _bGalleryIn: "+ _bGalleryIn);
			_destroySequencer();
			_ss = new SimpleSequencer("out");
			_ss.addEventListener(Event.COMPLETE, _animateOutSequencer_COMPLETE_handler, false, 0, true);
			// oc: services
			if (_bGalleryIn)	_ss.addStep(1, _gallery, _gallery.animateOut, AnimationEvent.OUT);
			else for each(var s:StandardButtonInOut in _serviceIdsToItems){_ss.addStep(1, s.mc, s.animateOut, "NEXT_OUT");}//end for each
			_ss.addStep(2, _title.mc, _title.animateOut, AnimationEvent.OUT);
			_ss.addStep(3, _bg.mc, _bg.animateOut, AnimationEvent.OUT);
			
			_ss.start();
			_bGalleryIn = false;
			
		}//end function _animateOut
		
		// =================================================
		// ================ Constructor
		// =================================================		
	
		public function Craft($mc:MovieClip, $xml:XML, $useWeakReference:Boolean=false){
			super($mc, $xml, $useWeakReference);
			
			//here are all the StandardInOuts
			_bg 		= new StandardInOut(mc.bg_mc);
			_title 		= new StandardInOut(mc.title_mc);
			_services	= new StandardInOut(mc.services_mc);
			_services.mc.gallery_mc.visible = false;
			setupButtons();
			setupResize();
		}//end constructor
		
	}//end class
}//end package