package com.strattonimaging.site.events
{
	import flash.events.Event;

	public class FtpEvent extends Event
	{
		public static const LOGIN						:String = "login";
		public static const LOGIN_FAILED				:String = "loginFailed";
		public static const CHANGE_FTP_SCREEN			:String = "changeFtpScreen";
		public static const DO_REFRESH					:String = "requestRefresh";
		public static const REFRESH						:String = "refresh";
		public static const TRANSFER_START				:String = "transferStart";
		public static const TRANSFER_COMPLETE			:String = "transferComplete";
		
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