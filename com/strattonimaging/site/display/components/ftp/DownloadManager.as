package com.strattonimaging.site.display.components.ftp
{
	import com.bigspaceship.display.StandardInOut;
	import com.strattonimaging.site.model.SiteModel;
	
	import fl.controls.DataGrid;
	import fl.data.DataProvider;
	
	import flash.display.MovieClip;
	
	public class DownloadManager extends StandardInOut implements IFtpScreen
	{
		private var _model				:SiteModel;
        private var _dg					:DataGrid;
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
			_dg = new DataGrid();
			_dg.addColumn("Name");
			_dg.addColumn("Type");
			_dg.addColumn("Size");
			_dg.addColumn("Date");

			_dg.width 	= 690;
			_dg.height 	= 390;
			_dg.x 		= 160;
			mc.addChild(_dg);
		}
	// =================================================
	// ================ Handlers
	// =================================================
	        
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
	// =================================================
	// ================ Constructor
	// =================================================

		public function DownloadManager($mc:MovieClip, $useWeakReference:Boolean=false)
		{
			
			super($mc, $useWeakReference);
			_model = SiteModel.getInstance();
			_init();
			
		}//end constructor

	}//end class
}//end package