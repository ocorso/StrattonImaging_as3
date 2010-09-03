package com.strattonimaging.site.display.components.ftp
{
	import com.bigspaceship.display.StandardInOut;
	import com.bigspaceship.utils.Out;
	import com.strattonimaging.site.model.SiteModel;
	
	import flash.display.MovieClip;
	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.FileReference;
	import flash.net.URLRequest;

	public class UploadManager extends StandardInOut implements IFtpScreen
	{
		private var _model			:SiteModel;
        private var _fr				:FileReference;
        
        
        private var _isFileSelected	:Boolean = false;
        
// =================================================
// ================ Callable
// =================================================
        public function browse($me:MouseEvent):void{
        	Out.status(this, "browse()");
        	_fr.browse();
        }
// =================================================
// ================ Workers
// =================================================
        private function _init():void{
			_model = SiteModel.getInstance();
			mc.visible = false;
			
			_fr = new FileReference();
			_fr.addEventListener(Event.SELECT, _selectHandler);
			_fr.addEventListener(Event.COMPLETE, _frCompleteHandler);
			_fr.addEventListener(DataEvent.UPLOAD_COMPLETE_DATA, _frDataCompleteHandler);
			
        }//end function 
        
        private function _upload($me:MouseEvent):void{
        	Out.status(this, "upload");
        	var url:String = _model.getBaseURL() + SiteModel.UPLOAD_ROUTE;
        	Out.debug(this, "url = "+ url);
        	var req:URLRequest = new URLRequest(url);
        	_fr.upload(req);
        	
        }//end function
// =================================================
// ================ Handlers
// =================================================
        private function _selectHandler($e:Event):void{
        	_isFileSelected = true;
        	mc.text_mc.tf.text = _fr.name;
        	mc.addEventListener(MouseEvent.CLICK, _upload);
        	
        }//end function
        private function _frCompleteHandler($e:Event):void{
        	Out.status(this, "_frCompleteHandler");
        	
        }
        private function _frDataCompleteHandler($de:DataEvent):void{
        	Out.info(this, "       _frDataCompleteHandler");
            Out.debug(this, "uploadCompleteData: " + $de);
        	Out.debug(this, $de.data);
        }
        private function _frIOErrorHandler($ioe:IOErrorEvent):void{
            Out.status(this, "ioErrorHandler: " + $ioe);
        	Out.error(this, "_frIOErrorHandler():: "+$ioe.text);
        	
        }

        private function httpStatusHandler($e:HTTPStatusEvent):void {
            Out.status(this, "httpStatusHandler: " + $e);
        }

        private function openHandler($e:Event):void {
            Out.status(this, "openHandler: " + $e);
        }

        private function progressHandler($pe:ProgressEvent):void {
            var file:FileReference = FileReference($pe.target);
            Out.status(this, "progressHandler name=" + file.name + " bytesLoaded=" + $pe.bytesLoaded + " bytesTotal=" + $pe.bytesTotal);
        }

        private function securityErrorHandler($se:SecurityErrorEvent):void {
            Out.status(this, "securityErrorHandler: " + $se);
        }

// =================================================
// ================ Animation
// =================================================
        
// =================================================
// ================ Getters / Setters
// =================================================
        
// =================================================
// ================ Interfaced
// =================================================
        
// =================================================
// ================ Core Handler
// =================================================
        
// =================================================
// ================ Overrides
// =================================================
        
// =================================================
// ================ Constructor
// =================================================

		public function UploadManager($mc:MovieClip, $useWeakReference:Boolean=false)
		{
			super($mc, $useWeakReference);
			_init();

		}//end constructor
		
	}//end class
}//end package