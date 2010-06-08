package com.strattonimaging.site.display.screens
{
	import com.bigspaceship.utils.Out;
	import com.strattonimaging.site.Constants;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.NetStatusEvent;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	
	import net.ored.util.Resize;

	public class Credits extends Screen implements IScreen
	{
		private const _VID_WIDTH			:uint = 576;
		private const _VID_HEIGHT			:uint = 273;
		private const _VID_NAME				:String = "credits.f4v";
		private const _VIDEO_READY			:String = "videoReady";

		private var _vid					:Video;
		private var _netStream				:NetStream;
		private var _netCon					:NetConnection;
		private var _vidSpecs				:Object;
		
		private var _bVidPlaying			:Boolean;
		
		public function Credits($mc:MovieClip, $xml:XML, $useWeakReference:Boolean=false)
		{
			super($mc, $xml, $useWeakReference);
			setupButtons();
			
		}//end constructor
		
		
		override public function beginCustomLoad():void
		{
			super.beginCustomLoad();
		}//end function
		
		public function setupResize():void
		{
			Resize.add(
				"@CreditsGrad",
				_mc.grad_mc.g,
				[Resize.FULLSCREEN_X, Resize.CUSTOM],
				{
				
					custom:				function($target, $params, $stage):void{
						
						//Out.debug(this, "grad w: "+_mc.grad_mc.width+" grad h: "+_mc.grad_mc.height+ " grad alpha: "+_mc.grad_mc.alpha);
							if ($stage.stageHeight > Constants.STAGE_HEIGHT) _mc.grad_mc.g.height = $stage.stageHeight - (Constants.BOTTOM_OFFSET - 135);
							else _mc.grad_mc.g.height = Constants.BOTTOM_OFFSET;
					}//end custom function
				}//end 4th resize add parameter
			);//end @CreditsGrad
			
		}//end function
		/***********************************************************/
		//standard overrides
		/***********************************************************/
		override protected function _onAnimateInStart():void{
			setupResize();
		}
		override protected function _onAnimateIn():void{
			setupVideo();
		}
		override protected function _onAnimateOut():void{
			_netStream.pause();
		}
		/**//*video loading functions*//*********************/
		private function _connectVidStream():void{
			_netStream = new NetStream(_netCon);
			_netStream.addEventListener(NetStatusEvent.NET_STATUS,_vidNetStatus,false,0,true);
			var metaData:Object = new Object();
			metaData.onMetaData = _onMetaData;
			_netStream.client = metaData;
			_mc.video_mc.addChild(_vid);
			_vid.attachNetStream(_netStream);
		}
		
		private function _onMetaData($info:Object):void{
			//_bScrubbing = false;
			if(_vidSpecs) _vidSpecs = null;
			_vidSpecs = $info;
			/* _videoHolder.mc.addEventListener(Event.ENTER_FRAME,_updateVid,false,0,true);
			
			//setup the scrubber
			_scrub.hitarea.addEventListener(MouseEvent.MOUSE_DOWN,_srubVid,false,0,true);
			_scrub.hitarea.addEventListener(MouseEvent.MOUSE_UP,_stopScrubVid,false,0,true);
			_scrub.hitarea.addEventListener(MouseEvent.ROLL_OUT,_stopScrubVid,false,0,true);
			_scrub.hitarea.buttonMode = true; */
		}
		
		private function _initVideo():void{
			Out.info(this, "Initializing streaming video");
			//remove the current video if there is one
			if(_vid){
				//_videoHolder.mc.vid_holder.removeChild(_vid);
				_vid = null;
			}
			_vid = new Video(_VID_WIDTH,_VID_HEIGHT);
			
			if(_netCon) _netCon = null;
			_netCon = new NetConnection();
			_netCon.addEventListener(NetStatusEvent.NET_STATUS,_vidNetStatus,false,0,true);
			_netCon.connect(null);
		}
		private function _vidNetStatus($evt:NetStatusEvent):void{
			switch ($evt.info.code) {
				case "NetConnection.Connect.Success":
					_connectVidStream();
					break;
				case "NetStream.Play.StreamNotFound":
					Out.info(this, "Unable to locate video");
					break;
				
				case "NetStream.Play.Stop":
					//trace(this, "THE VIDEO HAS STOPPED AND THE DURATION = " + (_vidSpecs.duration - _netStream.time));
					if(_vidSpecs.duration-_netStream.time <= 1){
						_netStream.seek(0);
						//_playPauseClick();

						//  track that the video is finished.
						//_siteModel.track(_vidNode().@id.toString() + '/complete');
					}
					break;
			}
		}
		private function _setupNewVid():void{
			_netStream.close();
			
			
			_netStream.bufferTime = 5;
			_bVidPlaying = true;
			Out.info(this,"THIS IS THE VID URL TO PLAY = " + _siteModel.getDirPath("vid") + _VID_NAME);
			
			//_siteModel.track(_vidNode().@id.toString() + '/start');
			
			_netStream.play(_siteModel.getDirPath("vid") + _VID_NAME);
			dispatchEvent(new Event(_VIDEO_READY));
		}
		private function setupVideo():void{
			
			_initVideo();
			_setupNewVid();
			
		}//end function
		
		
		public function setupButtons():void
		{
		}//end function
		
	}//end class
}//end package