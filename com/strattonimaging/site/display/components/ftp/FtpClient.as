package com.strattonimaging.site.display.components.ftp
{
	import com.bigspaceship.display.AnimationState;
	import com.bigspaceship.display.StandardButton;
	import com.bigspaceship.display.StandardInOut;
	import com.bigspaceship.utils.Out;
	import com.strattonimaging.site.display.screens.Screen;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	import net.ored.util.Resize;

	public class FtpClient extends Screen
	{
		private var ftpBtn		:StandardButton;
		private var ftp			:StandardInOut;
		
		//private var dataGrid	:Comx
		public function FtpClient($mc:MovieClip, $xml:XML, $useWeakReference:Boolean=false)
		{
			//TODO: implement function
			super($mc, $xml, $useWeakReference);
			
			ftpBtn 	= new StandardButton(_mc.ftpClient.ftp_btn_mc);
			ftp 	= new StandardInOut(_mc.ftpClient);
			ftpBtn.addEventListener(MouseEvent.CLICK, _toggleFtp); 	
			_setupResize();
			
			
		}//end constructor
		
		private function _setupResize():void{
			Resize.add(
				"@ftp",
				_mc,
				[Resize.BOTTOM, Resize.CENTER_X, Resize.CUSTOM],
				{
					 custom:				function($target, $params, $stage):void{
						if ($stage.stageHeight > 643){
							_mc.y = $stage.stageHeight-643;
						}else _mc.y = 0;
						 
					}
				}
			);//end btns center
		
		}//end function
		private function _toggleFtp($evt:MouseEvent):void{
			Out.status(this, "_toggleFtp: "+ftp.state);
			if (ftp.state == AnimationState.IN) ftp.animateOut();
			else	ftp.animateIn();
			
		}//end function 
	}//end class
}//end package