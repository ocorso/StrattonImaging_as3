package com.strattonimaging.site.model.vo
{
	import com.strattonimaging.site.Constants;
	
	public class FTPUser
	{
		private var _name		:String;
		private var _iPath		:String;
		private var _email		:String;
		private var _auth		:Boolean;
		
		public function get name():String{return _name;}
		public function get iPath():String{return _iPath;}
		public function get email():String{return _email;}
		public function get auth():Boolean{return _auth;}
		
		public function destroy():void{
			_name = null;
			_iPath = null;
			_email = null;
			_auth = false;
		}
		public function FTPUser($o:Object)
		{
			_name =  $o[Constants.POST_VAR_NAME] || "";
			_iPath = $o[Constants.POST_VAR_PATH] || "";
			_email = $o[Constants.POST_VAR_EMAIL]|| "";
			_auth = ($o[Constants.POST_VAR_SUCCESS] == Constants.LOGIN_ANSWER) ? true : false;
		}

	}
}