package com.strattonimaging.site.display.components.ftp
{
	import com.adobe.serialization.json.JSONDecoder;
	import com.adobe.serialization.json.JSONEncoder;
	import com.bigspaceship.utils.Out;
	import com.dynamicflash.util.Base64;
	import com.greensock.TweenLite;
	import com.strattonimaging.site.display.components.ftp.screens.IFtpScreen;
	import com.strattonimaging.site.display.components.ftp.screens.TransferDisplay;
	import com.strattonimaging.site.events.FtpEvent;
	import com.strattonimaging.site.model.Constants;
	import com.strattonimaging.site.model.SiteModel;
	import com.strattonimaging.site.model.vo.FTPUser;
	
	import fl.data.DataProvider;
	
	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.HTTPStatusEvent;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;

	public class FtpUtil extends EventDispatcher
	{
		private var _m:SiteModel;
		private var _p:TransferDisplay;
        private var _transferer:IFtpScreen;
        
        private var _np:Boolean = true;
        
// =================================================
// ================ Callable
// =================================================
  		public function getDirectory($e:Event = null):void{
			if (_m.ftpUser.auth){
				
	 			var l:URLLoader		= new URLLoader();
				var req:URLRequest 	= new URLRequest(_m.baseUrl+ Constants.REFRESH_ROUTE);
				req.method = URLRequestMethod.POST;
				var urlVar:URLVariables = new URLVariables();
				var o:Object = new Object();
				o[Constants.POST_VAR_PATH] = _m.currentDirectory;
			
				Out.debug(this, "we about to getDirectory: "+req.url);
				var toJSON:JSONEncoder = new JSONEncoder(o);
				var json:String = toJSON.getString();
				urlVar.d = Base64.encode(json);
				req.data = urlVar;
				l.addEventListener(Event.COMPLETE, _getDirectoryHandler);
				l.load(req);
			}//end if
			
		}//end get directory      
		
		public function manageProgress($transferer:IFtpScreen, $progress:TransferDisplay):void{
			Out.status(this, "manageProgress");
			_transferer = $transferer;
			_p = $progress;
			_p.addEventListener(FtpEvent.TRANSFER_CANCEL, _handleCancel);
			_transferer.addEventListener(ProgressEvent.PROGRESS, _onTransferProgress);
			_transferer.addEventListener(DataEvent.UPLOAD_COMPLETE_DATA, _onTransferComplete);
			_transferer.addEventListener(IOErrorEvent.IO_ERROR, _frIOErrorHandler);
			_transferer.addEventListener(SecurityErrorEvent.SECURITY_ERROR, _securityErrorHandler);
			
			_transferer.startTransfer();
			
		}//end function 
		
		public function clearFtpUser():void{
			Out.status(this, "clearFtpUser");
			var o:Object = {s:Constants.LOGIN_FAILURE};
			_m.ftpUser = new FTPUser(o);
		}//end function
// =================================================
// ================ Workers
// =================================================
        
// =================================================
// ================ Handlers
// =================================================
       	private function _getDirectoryHandler($evt:Event):void{
			Out.status(this, "got directory!");
			Out.debug(this, "info: "+$evt.target.data);
			
			var json:JSONDecoder = new JSONDecoder($evt.target.data, true);
			var dp:DataProvider = new DataProvider(json.getValue());
			dispatchEvent(new FtpEvent(FtpEvent.REFRESH, dp));
		}//end function
		 
    	private function _onTransferProgress($pe:ProgressEvent):void{
			Out.status(this, "_onTransferProgress");
			if (_np) _np = false;
            Out.info(this, "bytesLoaded=" + $pe.bytesLoaded + " bytesTotal=" + $pe.bytesTotal);
            
			var w:int = Math.ceil(($pe.bytesLoaded/$pe.bytesTotal)*Constants.PROGRESS_WIDTH);
    		_p.updateProgress(w);
    	}
    	private function _onTransferComplete($de:DataEvent):void{
			Out.status(this, "_onTransferComplete, never had progress? "+_np );
            Out.debug(this, "data response: " + $de);
            var s:IFtpScreen = IFtpScreen($de.target);
    		s.removeEventListener(ProgressEvent.PROGRESS, _onTransferProgress);
    		s.removeEventListener(DataEvent.UPLOAD_COMPLETE_DATA, _onTransferComplete);
    		s.removeEventListener(IOErrorEvent.IO_ERROR, _frIOErrorHandler);
    		s.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, _securityErrorHandler);
    		_p.removeEventListener(FtpEvent.TRANSFER_CANCEL, _handleCancel);
    		var e:FtpEvent = new FtpEvent(FtpEvent.TRANSFER_COMPLETE, {ns:Constants.GET}); 
    		if (_np){
				Out.warning(this, "never got a progress event");    			
    			TweenLite.to(_p.bar, .5, {width:300, onComplete:dispatchEvent, onCompleteParams:[e]});
    		} 
    		else dispatchEvent(e);
    	}
    	private function _handleCancel($e:FtpEvent):void{
    		Out.error(this, ", _handleCancel");
    		
            var s:IFtpScreen = _transferer;
    		s.removeEventListener(ProgressEvent.PROGRESS, _onTransferProgress);
    		s.removeEventListener(DataEvent.UPLOAD_COMPLETE_DATA, _onTransferComplete);
    		s.removeEventListener(IOErrorEvent.IO_ERROR, _frIOErrorHandler);
    		s.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, _securityErrorHandler);
    		_p.removeEventListener(FtpEvent.TRANSFER_CANCEL, _handleCancel);
    		_transferer.cancelTransfer();
    	}
    	private function _frCompleteHandler($e:Event):void{
        	Out.status(this, "_frCompleteHandler");
        	
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

        private function _securityErrorHandler($se:SecurityErrorEvent):void {
            Out.status(this, "securityErrorHandler: " + $se);
        }
// =================================================
// ================ Constructor
// =================================================

		public function FtpUtil($target:IEventDispatcher=null)
		{
			super($target);
			_m = SiteModel.getInstance();
		}//end constructor
			
	}//end class
}//end package