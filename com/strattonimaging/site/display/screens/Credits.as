package com.strattonimaging.site.display.screens
{
	import com.bigspaceship.display.StandardInOut;
	import com.bigspaceship.events.AnimationEvent;
	import com.bigspaceship.utils.Out;
	import com.bigspaceship.utils.SimpleSequencer;
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
		//standard in outs
		private var _bg						:StandardInOut;						
		private var _clapper				:StandardInOut;						
		private var _videoItem				:StandardInOut;						
		
		//video stuff
		private const _VID_WIDTH			:uint = 576;
		private const _VID_HEIGHT			:uint = 273;
		private const _VID_NAME				:String = "credits.f4v";
		private const _VIDEO_READY			:String = "videoReady";

		private var _vid					:Video;
		private var _netStream				:NetStream;
		private var _netCon					:NetConnection;
		private var _vidSpecs				:Object;
		
		private var _bVidPlaying			:Boolean;

        
// =================================================
// ================ Callable
// =================================================
        
// =================================================
// ================ Workers
// =================================================
		private function _init():void{
			Out.status(this, "init");
			
			_bg 		= new StandardInOut(mc.bg_mc);
			_clapper 	= new StandardInOut(mc.c_mc);
			_videoItem	= new StandardInOut(mc.v_mc);
			
			
			setupButtons();
			setupResize();
			_initVideo();
		}//end function
		
	
		/**
		 * The following several functions are related to setting up the video 
		 * 
		 */			
		private function _connectVidStream():void{
			_netStream = new NetStream(_netCon);
			_videoItem.addEventListener(AnimationEvent.OUT, _pauseNetStream);
			_netStream.addEventListener(NetStatusEvent.NET_STATUS,_vidNetStatus,false,0,true);
			var metaData:Object = new Object();
			metaData.onMetaData = _onMetaData;
			_netStream.client = metaData;
			_videoItem.mc.video_mc.addChild(_vid);
			_vid.attachNetStream(_netStream);
		}
		
		
		private function _initVideo():void{
			_videoItem.mc.video_mc.logo.stop();
			Out.info(this, "Initializing streaming video");
			//remove the current video if there is one
			if(_vid) _vid = null;
			_vid = new Video(_VID_WIDTH,_VID_HEIGHT);
			
			if(_netCon) _netCon = null;
			_netCon = new NetConnection();
			_netCon.addEventListener(NetStatusEvent.NET_STATUS,_vidNetStatus,false,0,true);
			_netCon.connect(null);
		}
		private function _setupNewVid():void{
			
			_netStream.close();
			_netStream.bufferTime = 5;
			_bVidPlaying = true;
			Out.info(this,"THIS IS THE VID URL TO PLAY = " + _siteModel.getDirPath("vid") + _VID_NAME);
			
			//_siteModel.track(_vidNode().@id.toString() + '/start');
			
			_netStream.play(_siteModel.getDirPath("vid") + _VID_NAME);
			dispatchEvent(new Event(_VIDEO_READY));
		}//end function 
		

// =================================================
// ================ Handlers
// =================================================
		private function _onMetaData($info:Object):void{
			if(_vidSpecs) _vidSpecs = null;
			_vidSpecs = $info;

		}//end function
        
		private function _vidNetStatus($evt:NetStatusEvent):void{
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
						//_playPauseClick();

						//  track that the video is finished.
						//_siteModel.track(_vidNode().@id.toString() + '/complete');
					}
					break;
			}
		}//end function
		private function _pauseNetStream($evt:AnimationEvent):void{
			_netStream.pause();
		}//end function 
// =================================================
// ================ Animation
// =================================================
		//override protected function _onAnimateInStart():void{}
		override protected function _animateIn():void{
			Out.status(this, "animateIn():: here is loadlist: "+_loadList);
			
			mc.visible = true;
			_destroySequencer();
			_ss = new SimpleSequencer("in");
			_ss.addEventListener(Event.COMPLETE,_animateInSequencer_COMPLETE_handler,false,0,true);
			_ss.addStep(1,_bg,_bg.animateIn,AnimationEvent.IN);
			_ss.addStep(2,_clapper,_clapper.animateIn,AnimationEvent.IN);
			_ss.addStep(3,_videoItem,_videoItem.animateIn,AnimationEvent.IN);
			_ss.addStep(4,this,_setupNewVid,_VIDEO_READY);
			
			_ss.start();
			
		}//end function _animateIn
		
		override protected function _animateOut():void{
			Out.status(this, "_animateOut");
			_destroySequencer();
			_ss = new SimpleSequencer("out");
			_ss.addEventListener(Event.COMPLETE, _animateOutSequencer_COMPLETE_handler, false, 0, true);
			_ss.addStep(1, _videoItem.mc, _videoItem.animateOut, AnimationEvent.OUT);
			_ss.addStep(2, _clapper.mc, _clapper.animateOut, AnimationEvent.OUT);
			_ss.addStep(3, _bg.mc, _bg.animateOut, AnimationEvent.OUT);
			_ss.start();
			
		}//end function _animateOut
		//override protected function _onAnimateIn():void{}
		override protected function _onAnimateOut():void{}
        
        
// =================================================
// ================ Getters / Setters
// =================================================
        
// =================================================
// ================ Interfaced
// =================================================
		public function setupResize():void
		{
			Resize.add(
				"@CreditsGrad",
				_bg.mc.grad_mc.g,
				[Resize.FULLSCREEN_X, Resize.CUSTOM],
				{
				
					custom:				function($target, $params, $stage):void{
							if ($stage.stageHeight > Constants.STAGE_HEIGHT) _bg.mc.grad_mc.g.height = $stage.stageHeight - (Constants.BOTTOM_OFFSET - 135);
							else _bg.mc.grad_mc.g.height = Constants.BOTTOM_OFFSET;
					}//end custom function
				}//end 4th resize add parameter
			);//end @Grad
			
		}//end function
        		
		
		public function setupButtons():void
		{
		}//end function
		
// =================================================
// ================ Core Handler
// =================================================

// =================================================
// ================ Overrides
// =================================================
// =================================================
// ================ Constructor
// =================================================
		
		public function Credits($mc:MovieClip, $xml:XML, $useWeakReference:Boolean=false)
		{
			super($mc, $xml, $useWeakReference);
			_init();
		}//end constructor

	}//end class
}//end package