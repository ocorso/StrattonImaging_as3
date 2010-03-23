package com.strattonimaging.site.display.screens
{
	import com.bigspaceship.utils.Out;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	
	public class Learn extends Screen
	{
		public function Learn($mc:MovieClip, $xml:XML, $useWeakReference:Boolean=false)
		{
			super($mc, $xml, $useWeakReference);
		}//end constructor
		
		override protected function _loadComplete($evt:Event):void
		{
			dispatchEvent($evt);
		}
		
		public override function onURLChange():void{
			super.onURLChange();
			Out.status(this, "we'd do something within the same screen here");
		}//end function
		
		override protected function _onAnimateIn():void{
			Out.status(this, "onAnimateIn(): but i can't see it");
		}//end function
	}//end class
}//end package