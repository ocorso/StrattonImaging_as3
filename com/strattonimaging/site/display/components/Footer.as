package com.strattonimaging.site.display.components
{
	import com.bigspaceship.utils.Out;
	import com.strattonimaging.site.display.screens.Screen;
	
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import net.ored.util.Resize;
	
	public class Footer extends Screen
	{
		private var _copyright			:TextField;
		private var _ORed				:TextField;
		
		public function Footer($mc:MovieClip, $xml:XML, $useWeakReference:Boolean=false)
		{
			super($mc, $xml, $useWeakReference);
			_init();
			
		}//end constructor
		private function _init():void{
			
			_setupText();
			_mc.ored_mc.btn.addEventListener(MouseEvent.CLICK, _oredClickHander);
		}
		private function _setupText():void{
			
			 var format:TextFormat = new TextFormat();
            format.font = "Arial";
            format.color = 0xFFFFFF;
            format.size = 10;
            format.underline = false;


			
			_copyright = new TextField();
			_copyright.autoSize = TextFieldAutoSize.LEFT;
			
            _copyright.defaultTextFormat = format;
			_copyright.text = "© 2010 Stratton Imaging  |  All Rights Reserved  ";
			
			
			
//			_mc.addChild(_copyright);
			
		}//end function
		private function _oredClickHander($me:MouseEvent):void{
			navigateToURL(new URLRequest("http://www.ored.net"));
			
		}//end function
		override protected function _onAnimateInStart():void{
			Out.info(this, "HEY YO_onAnimateInStart()");
			
			Resize.add(
				"@footerCenter",
				_mc,
				[Resize.CENTER_X, Resize.CUSTOM],
				{
							
					custom:		function($target:*, $params:*, $stage:Stage):void{
						if ($stage.stageHeight > 643){
							_mc.y = $stage.stageHeight-643;
						}else _mc.y = 0;
					}//end custom resize function
				}//end 4th param
			);//end @footerCenter
		
			Resize.add(
				"@footerCopyright",
				_copyright,
				[Resize.BOTTOM],
				{
				}//end 4th param
			);//end @footerCenter
		}
		
		override protected function _onAnimateIn():void{
			
		}//end function
	}//end class
}//end package