package com.strattonimaging.site.display.screens.credits
{
	import com.bigspaceship.events.AnimationEvent;
	import com.bigspaceship.utils.Out;
	import com.strattonimaging.site.model.Constants;
	import com.strattonimaging.site.model.SiteModel;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.NetStatusEvent;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;

	public class VideoCredit extends Credit implements ICredit
	{
		private var _siteModel				:SiteModel;

		private var _vid					:Video;
		private var _vc						:Credit;//this is the only credit with a video on it
		private var _netStream				:NetStream;
		private var _netCon					:NetConnection;
		private var _vidSpecs				:Object;
		
		private var _bVidPlaying			:Boolean;

        
// =================================================
// ================ Callable
// =================================================
		public function initVideo():void{
			Out.info(this, "Initializing streaming video");
			
			//remove the current video if there is one
			if(_vid) _vid = null;
			
			_vid = new Video(Constants.VID_WIDTH, Constants.VID_HEIGHT);
			
			if(_netCon) _netCon = null;
			_netCon = new NetConnection();
			_netCon.addEventListener(NetStatusEvent.NET_STATUS,_vidNetStatus,false,0,true);
			_netCon.connect(null);
		}
		
		override public function configure($asset:DisplayObject = null):void{
			
			_netStream.close();
			_netStream.bufferTime = 5;
			_bVidPlaying = true;
			Out.info(this,"THIS IS THE VID URL TO PLAY = " + _siteModel.getDirPath("vid") + Constants.VID_NAME);
			
			//_siteModel.track(_vidNode().@id.toString() + '/start');
			
			mc.item_mc.i.logo.stop();
			_netStream.play(_siteModel.getDirPath("vid") + Constants.VID_NAME);
			dispatchEvent(new Event(Constants.VIDEO_READY));
		}//end function 
        
// =================================================
// ================ Workers
// =================================================
		/**
		 * The following several functions are related to setting up the video 
		 * 
		 */			
		private function _connectVidStream():void{
			_netStream = new NetStream(_netCon);
			
			addEventListener(AnimationEvent.OUT_START, _playPauseClick);
			
			_netStream.addEventListener(NetStatusEvent.NET_STATUS,_vidNetStatus,false,0,true);
			var metaData:Object = new Object();
			metaData.onMetaData = _onMetaData;
			_netStream.client = metaData;
			
			mc.item_mc.i.addChild(_vid);
			_vid.attachNetStream(_netStream);
		}
		
		private function _playPauseClick($evt:Event=null):void{
			Out.status(this, "playPauseClick");
			
			if(_bVidPlaying){
				_netStream.pause();
				_bVidPlaying = false;
			}
			else{
				_netStream.seek(0);
				_netStream.resume();
				_bVidPlaying = true;
			}
		}
        
// =================================================
// ================ Handlers
// =================================================

		private function _onMetaData($info:Object):void{
			if(_vidSpecs) _vidSpecs = null;
			_vidSpecs = $info;

		}//end function
        
		private function _vidNetStatus($evt:NetStatusEvent):void{
			if ($evt.info.code != "NetStream.Buffer.Empty" || $evt.info.code != "NetStream.Buffer.Full")
				Out.info(this, $evt.info.code);
				
			switch ($evt.info.code) {
				case "NetConnection.Connect.Success":
					_connectVidStream();
					break;
				case "NetStream.Play.StreamNotFound":
					Out.info(this, "Unable to locate video");
					break;
				
				case "NetStream.Play.Stop":
					if(_vidSpecs.duration-_netStream.time <= 1){
						_netStream.seek(0);
						_playPauseClick();

						//  track that the video is finished.
						//_siteModel.track(_vidNode().@id.toString() + '/complete');
					}
					break;
			}
		}//end function
		private function _pauseNetStream($evt:AnimationEvent):void{
			_netStream.pause();
		}//end function 
		private function _playNetStream($evt:AnimationEvent):void{
			//_netStream.seek(0);
			//_netStream.resume();
			_netStream.play(_siteModel.getDirPath("vid") + Constants.VID_NAME);			
		
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
        
// =================================================
// ================ Core Handler
// =================================================
        
// =================================================
// ================ Overrides
// =================================================
		override protected function _onAnimateIn():void{
			Out.status(this, "onAnimateIn");
			addEventListener(AnimationEvent.OUT_START, _pauseNetStream);
			removeEventListener(AnimationEvent.IN, _playNetStream);
			
		}
		override protected function _onAnimateOut():void{
			removeEventListener(AnimationEvent.OUT_START, _pauseNetStream);
			addEventListener(AnimationEvent.IN, _playNetStream);
		}
// =================================================
// ================ Constructor
// =================================================
		
		public function VideoCredit($mc:MovieClip, $useWeakReference:Boolean=false)
		{
			Out.status(this, "constructor");
			super($mc, $useWeakReference);
			_siteModel = SiteModel.getInstance();
			initVideo();
		}
			

	}//end class
}//end package