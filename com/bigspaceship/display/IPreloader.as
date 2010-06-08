package com.bigspaceship.display
{
	import flash.display.MovieClip;
	
	public interface IPreloader
	{
		function animateIn($forceAnim:Boolean=false):void;
		function updateProgress($bytesLoaded:Number, $bytesTotal:Number, $itemsLoaded:Number, $itemsTotal:Number):void;
		function setComplete():void;
		function reset():void;
		function cancel():void;
		function addEventListener(type:String, listener:Function, useCapture:Boolean  = false, priority:int  = 0, useWeakReference:Boolean  = false):void;
		function removeEventListener(type:String, listener:Function, useCapture:Boolean  = false):void;
		function get mc():MovieClip;
	}
}