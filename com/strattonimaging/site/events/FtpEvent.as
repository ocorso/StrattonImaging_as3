package com.strattonimaging.site.events
{
	import flash.events.Event;

	public class FtpEvent extends Event
	{
		public static const LOGIN			:String = "login";
		public static const LOGIN_FAILED	:String = "loginFailed";
		public static const CHANGE			:String = "change";
		public static const REFRESH			:String = "refresh";
		public static const GET_FILE		:String = "getFile";
		public static const PUT_FILE		:String = "putFile";
		
		
		public function FtpEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
	}
}