package com.bigspaceship.display
{
	import flash.display.MovieClip;
	import flash.events.IEventDispatcher;

	public interface IStandard extends IEventDispatcher
	{
		function get mc():MovieClip;
		//function get timelineWatcher():TimelineWatcher;
		function destroy():void;
	}
}