package com.strattonimaging.site.display.screens
{
	import com.bigspaceship.display.StandardInOut;
	import com.bigspaceship.loading.BigLoader;
	import com.bigspaceship.utils.Out;
	import com.bigspaceship.utils.SimpleSequencer;
	import com.strattonimaging.site.model.Constants;
	import com.strattonimaging.site.model.SiteModel;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	
	public class Screen extends StandardInOut
	{
		protected var _xml					:XML;
		protected var _loadList				:XMLList;
		
		protected var _loader				:BigLoader;
		protected var _m					:SiteModel;
		protected var _ss					:SimpleSequencer;
		
		public function Screen($mc:MovieClip, $xml:XML, $useWeakReference:Boolean=false)
		{
			super($mc, $useWeakReference);
			_xml = $xml;
			_loader = new BigLoader();
			_m = SiteModel.getInstance();
		}//end constructor
		
		protected function _destroySequencer():void{
			if(_ss){
				_ss.removeEventListener(Event.COMPLETE,_animateInSequencer_COMPLETE_handler);
				_ss.removeEventListener(Event.COMPLETE,_animateOutSequencer_COMPLETE_handler);
				_ss = null;
			}
		}//end function _destroySequencer
		/*******************************************/
		//getter setters
		/*******************************************/
		public function get xml():XML { return _xml; }
		public function onURLChange():void {};
		public function getNodeByType($node:String, $att:String):XMLList{ return _xml.child($node).(@type == $att);}
		
		
		/***********************************************************/
		//loading functions
		/***********************************************************/
		public function beginCustomLoad():void {
			_loader = new BigLoader();
			_loadList = new XMLList(xml.loadables.loadable) || null;
			if(_loadList.length()>0){
				var n:uint;
				for(n=0; n < _loadList.length(); n++) {
					var path:String = _loadList[n].@path;
					
					//check to see if the url has a file type
					if(path.substr((path.length - 4), 1) == "."){
						var fileType:String = path.substr((path.length - 3), 3);
						if(fileType == "jpg") fileType=Constants.TYPE_IMG;
						path = _m.getDirPath(fileType) + path;
					}
					
					
					//check to see if the base url needs to be added
					if(_loadList[n].@needs_baseURL == "yes") path = _m.baseUrl + path;
					
					//if there is no "." for a file extension I am assuming it is a URL request
					if(path.substr((path.length - 4), 1) == ".") _loader.add(path, _loadList[n].@id);
					else{
						var urlreq:URLRequest = new URLRequest(path);
						_loader.add(urlreq, _loadList[n].@id);
					}//end else
				}//end for
			
				_loader.addEventListener(ProgressEvent.PROGRESS,dispatchEvent,false,0,true);
				_loader.addEventListener(Event.COMPLETE, _loadComplete,false,0,true);
				_loader.start();
			}//end if
			else{ dispatchEvent(new Event(Event.COMPLETE));}
			
		}//end function
		
		protected function _loadComplete($evt:Event):void{ 
			_loader.removeEventListener(Event.COMPLETE, _loadComplete);
			dispatchEvent($evt);
		}//end function
		override protected function _onAnimateOut():void{
			_mc.gotoAndStop("INIT");
		}//end function
		protected function _animateInSequencer_COMPLETE_handler($evt:Event = null):void{
			Out.status(this,"_realAnimateIn_handler()");
			_destroySequencer();
			super._onAnimateIn_handler();
		}
		protected function _animateOutSequencer_COMPLETE_handler($evt:Event = null):void{
			Out.status(this,"_realAnimateOut_handler()");
			_destroySequencer();
			super._onAnimateOut_handler();
		}     
	}//end class
}//end package