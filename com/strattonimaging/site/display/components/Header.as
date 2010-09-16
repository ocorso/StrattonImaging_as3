package com.strattonimaging.site.display.components
{
	import com.asual.swfaddress.SWFAddress;
	import com.bigspaceship.display.StandardButton;
	import com.bigspaceship.events.AnimationEvent;
	import com.bigspaceship.utils.Out;
	import com.greensock.TweenMax;
	import com.strattonimaging.site.display.screens.Screen;
	import com.strattonimaging.site.model.Constants;
	
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.utils.Dictionary;
	
	import net.ored.util.Resize;
	
	public class Header extends Screen
	{
		
		private var _navIdsToItems		:Dictionary;
		private var _navItemsToIds		:Dictionary;
		
		private var _currentActive		:String;
		
		
		
		public function Header($mc:MovieClip, $xml:*, $useWeakReference:Boolean=false)
		{
			super($mc, $xml, $useWeakReference);
			
			_setupNav();
			_setupResize();
		}//end constructor
		
		private function _setupNav():void{
			
			_navIdsToItems = new Dictionary(true);
			_navItemsToIds = new Dictionary(true);
			
			//setup nav
			for(var i:int=0;i<_xml.menu.length();i++) {
				var id:String = _xml.menu[i].@id.toString();
				Out.info(this, "the id of this button is: "+ id); 
				//setup nav btns
				_navIdsToItems[id] = new StandardButton(_mc.tabs_mc[id + "_mc"], _mc.tabs_mc[id + "_mc"].btn);
				//store tint color value in btn
				switch (id){
					case Constants.LEARN : _addHoverTweens(_navIdsToItems[id], Constants.TINT_GREEN); break;
					case Constants.CRAFT : _addHoverTweens(_navIdsToItems[id], Constants.TINT_YELLOW); break;
					case Constants.CREDITS : _addHoverTweens(_navIdsToItems[id], Constants.TINT_RED); break;
					case Constants.CONNECT : _addHoverTweens(_navIdsToItems[id], Constants.TINT_BLUE); break;
				}//end switch
				if (id!="home")	{
					_navIdsToItems[id].mc.text_mc.inner.tf.text = id.toUpperCase();		
				}
				_navIdsToItems[id].addEventListener(MouseEvent.CLICK,_navOnClick,false,0,true);
				_navIdsToItems[id].addEventListener(MouseEvent.ROLL_OVER,_navOnRollOver,false,0,true);
				_navIdsToItems[id].addEventListener(MouseEvent.ROLL_OUT,_navOnRollOut,false,0,true);
				_navItemsToIds[_navIdsToItems[id]] = id;
			}//end for
		}//end function
		
		private function _addHoverTweens($sb:StandardButton, $tint:uint):void{
			$sb.id = String($tint);	
			$sb.addEventListener(AnimationEvent.ROLL_OVER_START, _tweenToTint);
			$sb.addEventListener(AnimationEvent.ROLL_OUT_START, _tweenToWhite);
		}//end function
		
		private function _tweenToTint($e:AnimationEvent):void{
			TweenMax.to($e.target.mc, 0.25, {colorTransform:{tint:$e.target.id, tintAmount:1, brightness:1}});
			
		}//end function
		private function _tweenToWhite($e:AnimationEvent):void{
			TweenMax.to($e.target.mc, 0.25, {colorTransform:{tint:0xFFFFFF, tintAmount:1, brightness:1}});
			
		}//end function
		
		private function oef(e:Event):void{
			Out.debug(this, "frame: "+ MovieClip(_navIdsToItems['craft'].mc).currentFrame);
		}
		
		private function _setupResize():void{
			Resize.add(
				"@headerBtns",
				_mc,
				[Resize.CENTER_X, Resize.CUSTOM],
				{
					custom:	function($target:*, $params:*, $stage:Stage):void{
						if ($stage.stageHeight > Constants.STAGE_HEIGHT){
							_mc.y = $stage.stageHeight-Constants.STAGE_HEIGHT;
						}else _mc.y = 0;
						
					}
				}
			);//end btns center
		
		}//end function
		private function _navOnRollOver($me:MouseEvent):void{
			Out.debug(this, "over: "+$me.localY);
		}
		private function _navOnRollOut($me:MouseEvent):void{
			Out.debug(this, "out: "+$me.localY);
		}
		
		private function _navOnClick($evt:MouseEvent):void {
			Out.debug(this, "just clicked: "+ $evt.target);
			var screenId:String = _navItemsToIds[$evt.target];
			SWFAddress.setValue(screenId);
		}
		
		public function setActiveScreen():void {
			
			Out.status(this, "setActiveScreen(): _currentActive = "+_currentActive);
			if(_currentActive != null) _navIdsToItems[_currentActive].deselect();
			_currentActive = _siteModel.currentScreen;
			_navIdsToItems[_currentActive].select();
			
		}//end function
		override protected function _onAnimateIn():void{
			Out.info(this, "HEEEEEEYYYYY_onAnimateIn()");
			
		}//end function
		
	}//end class
}//end package