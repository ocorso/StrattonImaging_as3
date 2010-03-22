package com.strattonimaging.site.display.components
{
	import com.asual.swfaddress.SWFAddress;
	import com.bigspaceship.display.StandardButton;
	import com.bigspaceship.utils.Out;
	import com.strattonimaging.site.display.screens.Screen;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	
	public class Header extends Screen
	{
		
		private var _navIdsToItems		:Dictionary;
		private var _navItemsToIds		:Dictionary;
		
		private var _currentActive		:String;
		
		public function Header($mc:MovieClip, $xml:*, $useWeakReference:Boolean=false)
		{
			super($mc, $xml, $useWeakReference);
			_navIdsToItems = new Dictionary(true);
			_navItemsToIds = new Dictionary(true);
			
			//setup nav
			for(var i:int=0;i<_xml.menu.length();i++) {
				var id:String = _xml.menu[i].@id.toString();
				
				if (id == "home")	_navIdsToItems[id] = new StandardButton(_mc[id + "_mc"]);					
				else _navIdsToItems[id] = new StandardButton(_mc.tabs_mc[id + "_mc"]);					
				_navIdsToItems[id].addEventListener(MouseEvent.CLICK,_navOnClick,false,0,true);
				//_navIdsToItems[id].addEventListener(MouseEvent.ROLL_OVER,_navOnRoll,false,0,true);
				_navItemsToIds[_navIdsToItems[id]] = id;
			}//end for
		}//end constructor
		private function _navOnClick($evt:MouseEvent):void {
			Out.debug(this, "just clicked: "+ $evt.target);
			var screenId:String = _navItemsToIds[$evt.target];
			SWFAddress.setValue(screenId);
		}
		
		public function setActiveScreen():void {
			Out.status(this, "setActiveScreen(): _currentActive = "+_currentActive);
			if(_currentActive != null) _navIdsToItems[_currentActive].deselect();
			//else _currentActive = _siteModel.currentScreen;
			//if current screen is products or video then set active to current screen OR set set active to features
			//_currentActive = (_siteModel.currentScreen == "products" || _siteModel.currentScreen == "videos") ? _siteModel.currentScreen : "features";
			
			//_navIdsToItems[_currentActive].select();
		}//end function
		
	}//end class
}//end package