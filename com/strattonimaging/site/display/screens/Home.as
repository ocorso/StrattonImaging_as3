package com.strattonimaging.site.display.screens
{
	import flash.display.MovieClip;
	import flash.events.Event;
	
	
	public class Home extends Screen
	{
		public function Home($mc:MovieClip, $xml:XML, $useWeakReference:Boolean=false)
		{
			super($mc, $xml, $useWeakReference);
		}
		
		override protected function _loadComplete($evt:Event):void
		{
			dispatchEvent($evt);
		}

		public override function onURLChange():void{
			super.onURLChange();
		}//end function
	}
}