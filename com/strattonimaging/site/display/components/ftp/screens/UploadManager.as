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
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.net.FileReference;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;

	public class UploadManager extends StandardInOut implements IFtpScreen
	{
		private var _n				:String = Constants.PUT;
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
			
			_createFileReference();
			
			//upload manager
			_browseBtn = new StandardButton(mc.browseBtn);
			_browseBtn.addEventListener(MouseEvent.CLICK, browse);
			_uploadBtn = new StandardButton(mc.uploadBtn);
			
        }//end function 
        
        private function _createFileReference():void{
        	
			_fr = new FileReference();
			_fr.addEventListener(Event.SELECT, _selectHandler);
			_fr.addEventListener(Event.COMPLETE, dispatchEvent);
			_fr.addEventListener(DataEvent.UPLOAD_COMPLETE_DATA, dispatchEvent);
			_fr.addEventListener(ProgressEvent.PROGRESS, dispatchEvent);
			
        }//end function 
        
        private function _upload($me:MouseEvent):void{
        	Out.status(this, "upload");

			dispatchEvent(new FtpEvent(FtpEvent.CHANGE_FTP_SCREEN, {ns:Constants.TRANSFER}));
        	
        }//end function
        
        private function _createPostVars():URLVariables{
        	var vars:URLVariables = new URLVariables();
			vars.email 	= _m.ftpUser.email;
			vars.dir	= _m.currentDirectory;
			vars.name	= _fr.name;
			vars.size	= _fr.size;
			vars.type	= _fr.type;
        	return vars;
        }
        
        private function _destroyFileReference():void{
        	
        }
// =================================================
// ================ Handlers
// =================================================
        private function _selectHandler($e:Event):void{
        	_isFileSelected = true;
        	mc.text_mc.tf.text = _fr.name;
        	mc.addEventListener(MouseEvent.CLICK, _upload);
        	
        }//end function

// =================================================
// ================ Animation
// =================================================
        
// =================================================
// ================ Getters / Setters
// =================================================
        public function get name ():String{ return _n;}        
// =================================================
// ================ Interfaced
// =================================================
        public function startTransfer():void{
        	Out.status(this, "starting upload");
			var req:URLRequest 	= new URLRequest(_m.baseUrl + Constants.UPLOAD_ROUTE);
			req.method 			= URLRequestMethod.POST;
			req.data 			= _createPostVars();
        	_fr.upload(req, Constants.O_RED_DATA, true);
        	
        }//end function
        
        public function cancelTransfer():void{
			Out.status(this, "cancelTransfer");
        	_fr.cancel();
        	var e:FtpEvent = new FtpEvent(FtpEvent.CHANGE_FTP_SCREEN, {ns:Constants.DASH}); 
    		dispatchEvent(e);
    		
        }
// =================================================
// ================ Core Handler
// =================================================
        
// =================================================
// ================ Overrides
// =================================================
   		override protected function _onAnimateInStart():void{	
   			mc.text_mc.tf.text = ""; 
   		}    
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