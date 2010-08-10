package com.strattonimaging.site.events
{
	import flash.events.Event;

	public class FtpEvent extends Event
	{
		public static const LOGIN						:String = "login";
		public static const LOGIN_FAILED				:String = "loginFailed";
		public static const CHANGE_FTP_SCREEN			:String = "changeFtpScreen";
		public static const REFRESH						:String = "refresh";
		public static const GET_FILE					:String = "getFile";
		public static const PUT_FILE					:String = "putFile";
		
		private var _info		: Object;
		public function get info():Object{
			return _info;
		}
		public function get data():Object{
			return _info;
		}
		
		public function FtpEvent($type:String, $info:Object = null, $bubbles:Boolean=false, $cancelable:Boolean=false)
		{
			super($type, $bubbles, $cancelable);
			_info = $info;
		}
		
	}
}