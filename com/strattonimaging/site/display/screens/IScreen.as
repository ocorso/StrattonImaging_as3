package com.strattonimaging.site.display.screens
{
	import flash.events.Event;

	public interface IScreen
	{
		function get xml():XML;
		function beginCustomLoad():void;
		function setupResize():void;
		function setupButtons():void;
	}
}