/**
 * PreloaderClip by Big Spaceship. 2008
 *
 * To contact Big Spaceship, email info@bigspaceship.com or write to us at 45 Main Street #716, Brooklyn, NY, 11201.
 * Visit http://labs.bigspaceship.com for documentation, updates and more free code.
 *
 *
 * Copyright (c) 2008 Big Spaceship, LLC
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *
 **/


package com.bigspaceship.display
{	
	import flash.display.MovieClip;

	import flash.events.Event;
	import flash.events.ProgressEvent;
	
	import com.bigspaceship.utils.Out;	
	import com.bigspaceship.events.AnimationEvent;
	
	// the filename will be PreloaderClip.as. class name and file name have to match
	public class PreloaderClip extends MovieClip
	{	
		// this variables can only be accessed from PreloaderClip. if you tried to access them outside that scope you'd get an error.
		private var _targetFrame		:Number;
		
		private var _isIn				:Boolean;
		private var _isLoadComplete		:Boolean;
		
		public var pct_mc 				:MovieClip;
		public var progress_mc 			:MovieClip;
		
		// the constructor.
		// when a PreloaderClip begins to exist (either by appearing on the timeline or by calling new PreloaderClip() in code) this function is automatically called.
		public function PreloaderClip():void {};
		
		// call animateIn to kick off the timeline IN animation.
		public function animateIn():void
		{
			Out.debug(this,"animateIn");
			gotoAndPlay("IN_START");
			addEventListener(AnimationEvent.IN, _onPreloaderIn,false,0,true);
		};
		
		// our first "event hook." the preloader timeline resolves to a frame where a line of code like this appears:
		//		dispatchEvent(new AnimationEvent(AnimationEvent.IN));
		// in the constructor we listened for when that happened, and mapped it to this function. as a result, this function will automatically happen when we hit that frame.
		private function _onPreloaderIn($evt:Event):void
		{
			Out.debug(this, "onPreloaderIn");
			
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

		//	Out.debug(this, "updatePreloader :: " + $bytesLoaded + "/" + $bytesTotal + " :: " + $itemsLoaded + "/" + $itemsTotal + " :: " + preloader_mc.progress_mc.currentFrame + "/" + preloader_mc.progress_mc.totalFrames + " :: " + targetFrame);
		};
		
		// loading is complete, so make sure the preloader progress clip plays away.
		public function setComplete():void
		{
			progress_mc.play();
			_targetFrame = 9999999999;
		};
		
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
//				Out.debug(this,"% loaded: " + totalPct.toString());
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
			else animateIn();			
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
		};
	};
}