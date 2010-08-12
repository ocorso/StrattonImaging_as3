package com.strattonimaging.site.display.components.ftp
{
	import flash.events.IEventDispatcher;
	
	public interface IFtpScreen extends IEventDispatcher{
		
		function animateIn($forceAnim:Boolean=false):void;
		function animateOut($forceAnim:Boolean=false):void;
		
	}//end interface
	
}//end package