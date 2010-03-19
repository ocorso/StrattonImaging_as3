package com.strattonimaging.site.events
{
	import flash.events.Event;
	
	public class ScreenEvent extends Event
	{
		public static const REQUEST_LOAD		:String = "screenRequestLoad";
		public static const REQUEST_LOAD_CANCEL	:String = "screenRequestLoadCancel";
		
		public function ScreenEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}