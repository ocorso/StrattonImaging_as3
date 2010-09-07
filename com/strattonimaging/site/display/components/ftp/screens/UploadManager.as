package com.strattonimaging.site.display.components.ftp.screens
{
	import com.bigspaceship.display.StandardButton;
	import com.bigspaceship.display.StandardInOut;
	import com.bigspaceship.utils.Out;
	import com.strattonimaging.site.events.FtpEvent;
	import com.strattonimaging.site.model.Constants;
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
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;

	public class UploadManager extends StandardInOut implements IFtpScreen
	{
		private var _m				:SiteModel;
        private var _fr				:FileReference;
        
		private var _browseBtn		:StandardButton;
		private var _uploadBtn		:StandardButton;
        
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
			_m = SiteModel.getInstance();
			mc.visible = false;
			
			_fr = new FileReference();
			_fr.addEventListener(Event.SELECT, _selectHandler);
			_fr.addEventListener(Event.COMPLETE, _frCompleteHandler);
			_fr.addEventListener(DataEvent.UPLOAD_COMPLETE_DATA, _frDataCompleteHandler);
			_fr.addEventListener(ProgressEvent.PROGRESS, _progressHandler);
			
			//upload manager
			_browseBtn = new StandardButton(mc.browseBtn);
			_browseBtn.addEventListener(MouseEvent.CLICK, browse);
			_uploadBtn = new StandardButton(mc.uploadBtn);
			
        }//end function 
        
        private function _upload($me:MouseEvent):void{
        	Out.status(this, "upload");
        	var vars:URLVariables = new URLVariables();
			vars.email 	= _m.ftpUser.email;
			vars.dir	= _m.currentDirectory;
			vars.name	= _fr.name;
			vars.size	= _fr.size;
			vars.type	= _fr.type;
			var req:URLRequest = new URLRequest(_m.baseUrl + Constants.UPLOAD_ROUTE);
			req.method = URLRequestMethod.POST;
			req.data = vars;
			dispatchEvent(new FtpEvent(FtpEvent.CHANGE_FTP_SCREEN, {ns:Constants.TRANSFER}));
        	_fr.upload(req, "ored_data", true);
        	
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

        private function _httpStatusHandler($e:HTTPStatusEvent):void {
            Out.status(this, "httpStatusHandler: " + $e);
        }

        private function _openHandler($e:Event):void {
            Out.status(this, "openHandler: " + $e);
        }

        private function _progressHandler($pe:ProgressEvent):void {
            var file:FileReference = FileReference($pe.target);
            Out.status(this, "progressHandler name=" + file.name + " bytesLoaded=" + $pe.bytesLoaded + " bytesTotal=" + $pe.bytesTotal);
        }

        private function _securityErrorHandler($se:SecurityErrorEvent):void {
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