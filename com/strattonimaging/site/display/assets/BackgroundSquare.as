package com.strattonimaging.site.display.assets
{
	import com.bigspaceship.display.Standard;
	import com.strattonimaging.site.Constants;
	
	import flash.display.MovieClip;
	import flash.events.Event;

	public class BackgroundSquare extends Standard
	{
		public function BackgroundSquare($mc:MovieClip, $useWeakReference:Boolean=false)
		{
			super($mc, $useWeakReference);
			_mc.addEventListener(Event.ADDED_TO_STAGE,_addedToStage_handler);
		}
		
		private function _addedToStage_handler($evt:Event):void {
			_mc.stage.addEventListener(Event.RESIZE,_stageResize_handler);
			_stageResized();
		}
		
		private function _stageResize_handler($evt:Event):void { _stageResized(); }
		
		private function _stageResized():void {
			_mc.width = Math.max(Constants.STAGE_WIDTH,_mc.stage.stageWidth);
			_mc.height = Math.max(Constants.STAGE_HEIGHT,_mc.stage.stageHeight);
		}
	}
}