package com.strattonimaging.site.display.components
{	
	import com.bigspaceship.display.IPreloader;
	import com.bigspaceship.events.AnimationEvent;
	import com.bigspaceship.utils.Out;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	
	import net.ored.util.Resize;
	
	// the filename will be PreloaderClip.as. class name and file name have to match
	public class SectionLoader extends MovieClip implements IPreloader
	{	
		// this variables can only be accessed from PreloaderClip. if you tried to access them outside that scope you'd get an error.
		private var _targetFrame		:Number;
		
		private var _isIn				:Boolean;
		private var _isLoadComplete		:Boolean;
		private var _fa					:Boolean = false;
		
		public var pct_mc 				:MovieClip;
		public var progress_mc 			:MovieClip;
		
		// the constructor.
		// when a PreloaderClip begins to exist (either by appearing on the timeline or by calling new PreloaderClip() in code) this function is automatically called.
		public function SectionLoader():void {
			super();
			Out.status(this, "Section Loader constructor");
			Resize.add(	"@Preloader",
				this,
				[ Resize.CENTER_X, Resize.CUSTOM],
				{
						custom:			function($target, $params, $stage):void{
						$target.x	+=	$target.width/2;
						$target.y 	=	150;
						
					}
				}
			);
		}
		
		// call animateIn to kick off the timeline IN animation.
		public function animateIn($forceAnim:Boolean=false):void
		{
			//Out.debug(this,"animateIn");
			gotoAndPlay("IN_START");
			addEventListener(AnimationEvent.IN, _onPreloaderIn,false,0,true);
		};
		
		// our first "event hook." the preloader timeline resolves to a frame where a line of code like this appears:
		//		dispatchEvent(new AnimationEvent(AnimationEvent.IN));
		// in the constructor we listened for when that happened, and mapped it to this function. as a result, this function will automatically happen when we hit that frame.
		private function _onPreloaderIn($evt:Event):void
		{
			Out.info(this, "onPreloaderIn");
			
			progress_mc.addEventListener(Event.COMPLETE,_onProgressBarComplete,false,0,true);
			progress_mc.addEventListener(Event.ENTER_FRAME,_onProgressEnterFrame,false,0,true);
			
			progress_mc.stop();
			
			dispatchEvent(new Event(Event.INIT));
		};
				
		// we can call this whenever we want. we tell it how many items we're loading, which item we're at and the current status of those.
		// a simple loader that would shoot from 0 - 100% would call updateProgress(1,1,1,1);
		public function updateProgress($bytesLoaded:Number, $bytesTotal:Number, $itemsLoaded:Number, $itemsTotal:Number):void
		{
			var framesPerItem:Number = Math.floor(progress_mc.totalFrames/($itemsTotal+1));
			var pct:Number = $bytesLoaded/$bytesTotal;
			_targetFrame = Math.floor(framesPerItem * pct) + (framesPerItem * $itemsLoaded);

			//Out.debug(this, "updatePreloader :: " + $bytesLoaded + "/" + $bytesTotal + " :: " + $itemsLoaded + "/" + $itemsTotal + " :: " + this.progress_mc.currentFrame + "/" + this.progress_mc.totalFrames + " :: " + _targetFrame);
		};
		
		// loading is complete, so make sure the preloader progress clip plays away.
		public function setComplete():void
		{
			progress_mc.play();
			_targetFrame = 9999999999;
		}
		
		public function get mc():MovieClip{
			return this;
		}
		
		// this is some extra fun. in case we wanted to show the user that we're 75% loaded.
		private function _onProgressEnterFrame($evt:Event):void
		{
			(_targetFrame > progress_mc.currentFrame) ? progress_mc.play() : progress_mc.stop();
			
			var totalPct:Number = Math.round((progress_mc.currentFrame/progress_mc.totalFrames) * 100);

			// we'll try to tell the textfield to update progress. if it doesn't exist, we'll call Out.debug instead.
			try
			{
				pct_mc.tf.text = totalPct.toString();	
			}
			catch($error:Error)
			{
				Out.debug(this,"% loaded: " + totalPct.toString());
			}
		};
		
		
		// we've reached the end of the progress bar timeline. preloading is successful and complete. let's animate out.
		private function _onProgressBarComplete($evt:Event = null):void
		{
			_isLoadComplete = true;
			progress_mc.removeEventListener(Event.ENTER_FRAME,_onProgressEnterFrame);
//			if(pct_mc.tf != null) pct_mc.tf.text = "";	
			_animateOut();
		};			

		// the timeline goes away.	
		private function _animateOut():void
		{
			gotoAndPlay("OUT_START");
			addEventListener(AnimationEvent.OUT, _onPreloaderOut,false,0,true);			
		};

		// and once we reach the AnimationEvent.OUT event hook, we dispatch an event saying the preloader is complete. whatever is listening now knows the preloader has disappeared.
		private function _onPreloaderOut($evt:Event):void
		{
			// kill listeners. this will prep the loader for the next use.
			// if i didn't do this, I might get _onPreloaderIn() twice when I reach the IN event hook. that'd mess everything up.
			removeEventListener(AnimationEvent.IN,_onPreloaderIn);
			removeEventListener(AnimationEvent.OUT,_onPreloaderOut);
			

			if(_isLoadComplete) dispatchEvent(new Event(Event.COMPLETE));
			//else animateIn();			
		};

		// if we need to kill the preloader midload to restart it for whatever reason, here's how. reset() will bring the loader back in automatically.
		public function reset():void
		{
			_onProgressBarComplete();
			_isLoadComplete = false;
		};
		
		// and cancel will convince the loader that loading is complete, even if it's not.
		public function cancel():void
		{
			_onProgressBarComplete();
		}
	}
}