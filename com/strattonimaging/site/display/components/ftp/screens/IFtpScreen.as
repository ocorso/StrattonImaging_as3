package com.strattonimaging.site.display.components.ftp.screens
{
	import flash.events.IEventDispatcher;
	
	public interface IFtpScreen extends IEventDispatcher{
		
		function animateIn($forceAnim:Boolean=false):void;
		function animateOut($forceAnim:Boolean=false):void;
		function startTransfer():void;
		function cancelTransfer():void;
		function get name():String;
	}//end interface
	
}//end package