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
	import com.strattonimaging.site.model.SiteModel;
	
	import fl.controls.DataGrid;
	import fl.data.DataProvider;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	public class DownloadManager extends StandardInOut implements IFtpScreen
	{
		private var _model				:SiteModel;
        private var _dg					:DataGrid;
        
		private var _refreshBtn			:StandardButton;
		
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
			_model = SiteModel.getInstance();
			mc.visible = false;
			
			_createDataGrid();
			_refreshBtn = new StandardButton(mc.refreshBtn); 
			_refreshBtn.addEventListener(MouseEvent.CLICK, _refreshClickHandler);
		}
		private function _createDataGrid():void{
			
			TweenPlugin.activate([AutoAlphaPlugin, VisiblePlugin]);
			_dg = new DataGrid();
			_dg.addColumn("Name");
			_dg.addColumn("Type");
			_dg.addColumn("Size");
			_dg.addColumn("Date");
	
			_dg.width 	= 690;
			_dg.height 	= 390;
			_dg.x 		= 160;
			_dg.alpha	= 0;
			mc.addChild(_dg);
		}//end function
	// =================================================
	// ================ Handlers
	// =================================================
		private function _refreshClickHandler($me:MouseEvent):void{
			Out.status(this, "_refreshClickHandler");
			dispatchEvent(new FtpEvent(FtpEvent.DO_REFRESH));
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
	    override protected function _onAnimateIn():void{
	    	_model.currentFtpScreen = this;
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