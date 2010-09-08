package com.strattonimaging.site.display.components.ftp.screens
{
	import com.bigspaceship.display.StandardButton;
	import com.bigspaceship.display.StandardInOut;
	import com.bigspaceship.utils.Out;
	import com.greensock.TweenLite;
	import com.greensock.plugins.AutoAlphaPlugin;
	import com.greensock.plugins.TweenPlugin;
	import com.greensock.plugins.VisiblePlugin;
	import com.strattonimaging.site.events.FtpEvent;
	import com.strattonimaging.site.model.Constants;
	import com.strattonimaging.site.model.SiteModel;
	
	import fl.controls.DataGrid;
	import fl.data.DataProvider;
	
	import flash.display.MovieClip;
	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.net.FileReference;
	import flash.net.URLRequest;
	
	public class DownloadManager extends StandardInOut implements IFtpScreen
	{
		private var _m					:SiteModel;
        private var _dg					:DataGrid;
        private var _fr					:FileReference;
        
		private var _refreshBtn			:StandardButton;
		private var _downloadBtn		:StandardButton;
		
	// =================================================
	// ================ Callable
	// =================================================
	    public function refresh($dp:DataProvider):void{
	    	_dg.dataProvider = $dp;
	    	
	    }    
	// =================================================
	// ================ Workers
	// =================================================
		private function _init():void{
			_m = SiteModel.getInstance();
			mc.visible = false;
			
			_createFileReference();	
			_createDataGrid();
			
			//init buttons
			_refreshBtn 	= new StandardButton(mc.refreshBtn); 
			_refreshBtn.addEventListener(MouseEvent.CLICK, _refreshClickHandler);
			_downloadBtn 	= new StandardButton(mc.downloadBtn);
			_downloadBtn.addEventListener(MouseEvent.CLICK, _downloadClickHandler); 
		}//end function _init
		
		private function _createFileReference():void{
        
			_fr = new FileReference();
			_fr.addEventListener(Event.COMPLETE, dispatchEvent);
			_fr.addEventListener(DataEvent.UPLOAD_COMPLETE_DATA, dispatchEvent);
			_fr.addEventListener(ProgressEvent.PROGRESS, dispatchEvent);
			_fr.addEventListener(Event.CANCEL, _frCancelHandler);
        }//end function 
        
		private function _createDataGrid():void{
			
			TweenPlugin.activate([AutoAlphaPlugin, VisiblePlugin]);
			
			//table structure
			_dg = new DataGrid();
			_dg.addColumn("Name");
			_dg.addColumn("Type");
			_dg.addColumn("Size");
			_dg.addColumn("Date");
			
			//display config	
			_dg.width 	= 690;
			_dg.height 	= 390;
			_dg.x 		= 160;
			_dg.alpha	= 0;
			
			//datagrid events
			_dg.addEventListener(Event.CHANGE, _selectHandler);
			
			mc.addChild(_dg);
		}//end function

        private function get _downloadReq():URLRequest{
        	
        	return new URLRequest(_m.fileToDownload);
        }
	// =================================================
	// ================ Handlers
	// =================================================
		private function _refreshClickHandler($me:MouseEvent):void{
			Out.status(this, "_refreshClickHandler");
			dispatchEvent(new FtpEvent(FtpEvent.DO_REFRESH));
		}
		private function _downloadClickHandler($me:MouseEvent):void{
			Out.status(this, "_downloadClickHandler");
			dispatchEvent(new FtpEvent(FtpEvent.CHANGE_FTP_SCREEN, {ns:Constants.TRANSFER}));
		}//end function
		private function _selectHandler($e:Event):void{
			Out.status(this, "_selectHandler: "+$e.target.selectedItem.Name);			
			_m.currentFilename = $e.target.selectedItem.Name;
		}
		private function _frCancelHandler($e:Event):void{
			Out.status(this, "_frCancelHandler");
			dispatchEvent(new FtpEvent(FtpEvent.CHANGE_FTP_SCREEN, {ns:Constants.DASH}));
		}//end function
		
	// =================================================
	// ================ Animation
	// =================================================
	        
	// =================================================
	// ================ Getters / Setters
	// =================================================
	        
	// =================================================
	// ================ Interfaced
	// =================================================
		public function startTransfer():void{
			Out.status(this, "startTransfer from "+_downloadReq.url);

        	_fr.download(_downloadReq, _m.currentFilename);
		
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
	    override protected function _onAnimateIn():void{
	    	//no idea why the following line was in here...
	    	//_m.currentFtpScreen = this;
	    	//dispatchEvent(new FtpEvent(FtpEvent.DO_REFRESH));
	    }
	    override protected function _onAnimateInStart():void{	TweenLite.to(_dg, .5, {autoAlpha:1}); }    
	    override protected function _onAnimateOutStart():void{	TweenLite.to(_dg, .5, {autoAlpha:0}); }    
	// =================================================
	// ================ Constructor
	// =================================================

		public function DownloadManager($mc:MovieClip, $useWeakReference:Boolean=false)
		{
			
			super($mc, $useWeakReference);
			_init();
			
		}//end constructor

	}//end class
}//end package