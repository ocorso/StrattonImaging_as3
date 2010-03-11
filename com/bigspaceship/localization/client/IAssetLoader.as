package com.bigspaceship.localization.client
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	internal interface IAssetLoader extends IEventDispatcher
	{
		
		function get bytesLoaded():uint;
		function get bytesTotal():uint;
		
		function get loadEventDispatcher():IEventDispatcher;
		
		function load( $url:String ):void;
		
	}
}