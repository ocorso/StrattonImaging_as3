/**
 * SiteLoader by Big Spaceship. 2008
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
	import com.bigspaceship.utils.Out;
	
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	
	import net.ored.util.Resize;
		
	
	public class SiteLoader extends MovieClip
	{
		private static var __instance			:SiteLoader;
		public var preloader_mc 				:PreloaderClip;
		
		private var _initialWidth				:Number;
		private var _initialHeight				:Number;
		public static function getInstance():SiteLoader { return __instance; };
		
		public function SiteLoader()
		{
			Out.enableAllLevels(true);
			//Out.disableAllLevels();
			
			__instance = this;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			preloader_mc.animateIn();
			preloader_mc.addEventListener(Event.INIT,_startLoad,false,0,true);
			preloader_mc.addEventListener(Event.COMPLETE,_onPreloaderOut,false,0,true);
			
			_initialWidth = 980;
			_initialHeight = 742;
			
			Resize.setStage(this.stage);
			stage.addEventListener(Event.RESIZE, Resize.onResize,false,0,true);
			Resize.onResize();
		}

		protected function _startLoad($evt:Event):void
		{
			var l:Loader = new Loader();
			l.contentLoaderInfo.addEventListener(Event.COMPLETE,_onLoadComplete,false,0,true);
			l.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS,_onLoadProgress,false,0,true);
			
			var baseSWFPath:String = stage.loaderInfo.parameters.baseUrl || "./";
			
			l.load(new URLRequest(baseSWFPath + "Main.swf"));
		};
		protected function _onLoadProgress($evt:ProgressEvent):void { preloader_mc.updateProgress($evt.bytesLoaded,$evt.bytesTotal,0,10); };
		protected function _onLoadComplete($evt:Event):void { addChild($evt.target.content); };		
		protected function _onPreloaderOut($evt:Event):void {
			__instance = null;
		};
	};
}