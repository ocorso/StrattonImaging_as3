package com.strattonimaging.site.display.screens.credits
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	
	public interface ICredit
	{
		function animateIn($forceAnim:Boolean = false):void;
		function animateOut($forceAnim:Boolean = false):void;
		function destroy():void;
		function configure($asset:DisplayObject = null):void;
		function get isAnimating():Boolean;
		function get id ():String;
		function set id ($val:String):void;
		function get mc():MovieClip;
		function get type():String;
		function set type($type:String):void;
		function set isNextAnimation($isNext:Boolean):void;
		function resetDirection():void;
	}
}