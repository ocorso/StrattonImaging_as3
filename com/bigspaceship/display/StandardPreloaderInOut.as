/**
 * StandardPreloaderInOut by Big Spaceship. 2010
 *
 * To contact Big Spaceship, email info@bigspaceship.com or write to us at 45 Main Street #716, Brooklyn, NY, 11201.
 * Visit http://labs.bigspaceship.com for documentation, updates and more free code.
 *
 *
 * Copyright (c) 2010 Big Spaceship, LLC
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
	import com.bigspaceship.events.AnimationEvent;
	import com.bigspaceship.utils.Out;
	
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.Event;
	
	import net.ored.util.Resize;
	
	/**
	 * The <code>StandardPreloaderInOut</code> Class
	 * 
	 * @copyright 		2010 Big Spaceship, LLC
	 * @author			Jamie Kosoy, Daniel Scheibel
	 * @version			1.0 
	 * @langversion		ActionScript 3.0 			
	 * @playerversion 	Flash 9.0.0
	 *
	 */
	public class StandardPreloaderInOut extends StandardInOut implements IPreloader{	
		
		public var animateOutOnSetComplete:Boolean = true;
		
		private var _targetFrame		:Number;
		private var _progress_mc 		:MovieClip;
		private var _pct_mc 			:MovieClip;
		
		public function StandardPreloaderInOut($mc:MovieClip):void {
			Out.status(this, "constructor");
			super($mc);
			Resize.add(	"@SitePreloader",
				_mc,
				[ Resize.CENTER_X, Resize.CUSTOM],
				{
						custom:			function($target:*, $params:*, $stage:Stage):void{
						$target.x	+=	$target.width/2;
						$target.y 	=	150;
						
					}
				}
			);
		}
		
		override protected function _onAnimateInStart() : void{
			Out.status(this, "_onAnimateInStart");
			if(_progress_mc) _progress_mc.gotoAndStop(1);
		}
		
		override protected function _onAnimateIn():void{
			dispatchEvent(new Event(Event.INIT));
			Out.status(this, "_onAnimateIn");
			
			_progress_mc = _mc.progress_mc;
			_pct_mc = _mc.pct_mc;
			_progress_mc.addEventListener(Event.ENTER_FRAME, _onProgressEnterFrame);
			_progress_mc.stop();
			
		}
		
		public function updateProgressPercent($percent:Number):void{
			if(_progress_mc){
				_targetFrame = Math.floor(_progress_mc.totalFrames * $percent);
				//Out.debug(this, "updateProgressPercent :: " +  _progress_mc.currentFrame + "/" +_progress_mc.totalFrames + " :: " + _targetFrame +' :: '+$percent);
			}else{
				Out.debug(this, "updateProgressPercent :: _progress_mc does NOT EXIST!");
			}
			
		}
		//so if progress_mc has 100 frames;
		
		public function updateProgress($bytesLoaded:Number, $bytesTotal:Number, $itemsLoaded:Number, $itemsTotal:Number):void{
			var framesPerItem:Number = Math.floor(_mc.progress_mc.totalFrames/($itemsTotal));
			var pct:Number = $bytesLoaded/$bytesTotal;
			_targetFrame = Math.floor(framesPerItem * pct) + (framesPerItem * $itemsLoaded);
		}	
			
		
		// loading is complete, so make sure the preloader progress clip plays away.
		public function setComplete():void{
			Out.warning(this, 'setComplete: state:'+_curState+', currentFrame'+_progress_mc.currentFrame);
			
			if((_curState == AnimationState.IN && _curState != AnimationState.OUT_START && (_curState != AnimationState.OUT && _curState != AnimationState.INIT) )){
				_progress_mc.removeEventListener(Event.ENTER_FRAME, _onProgressEnterFrame);
				if(_progress_mc.currentFrame == _progress_mc.totalFrames){
					dispatchEvent(new Event(Event.COMPLETE));
					if(animateOutOnSetComplete){
						animateOut();
					}
				}else{
					_progress_mc.addEventListener(Event.COMPLETE, _onProgressBarComplete);
					_targetFrame = 9999999999;
					_progress_mc.play();
				}
			}else if((_curState == AnimationState.OUT || _curState == AnimationState.INIT) && _dispatchCompleteOnUnchangedState){
				if(animateOutOnSetComplete){
					dispatchEvent(new AnimationEvent(AnimationEvent.OUT));
				}else{
					dispatchEvent(new Event(Event.COMPLETE));
				}
			}
			
		}
		private function _onProgressEnterFrame($evt:Event):void{
			if(_progress_mc)(_targetFrame > _progress_mc.currentFrame) ? _progress_mc.play() : _progress_mc.stop();
			
			var totalPct:Number = Math.round((_progress_mc.currentFrame/_progress_mc.totalFrames) * 100);

			// we'll try to tell the textfield to update progress. if it doesn't exist, we'll call Out.debug instead.
			try
			{
				_pct_mc.tf.text = totalPct.toString();	
			}
			catch($error:Error)
			{
				Out.debug(this,"% loaded: " + totalPct.toString());
			}
		
		}
		
		private function _onProgressBarComplete($evt:Event = null):void{
			_progress_mc.removeEventListener(Event.COMPLETE,_onProgressBarComplete);
			dispatchEvent(new Event(Event.COMPLETE));
			if(animateOutOnSetComplete){
				animateOut();
			}
		}
				// if we need to kill the preloader midload to restart it for whatever reason, here's how. reset() will bring the loader back in automatically.
		public function reset():void
		{
			_onProgressBarComplete();
			animateOutOnSetComplete = false;
		};
		
		// and cancel will convince the loader that loading is complete, even if it's not.
		public function cancel():void
		{
			_onProgressBarComplete();
		}

	}
}