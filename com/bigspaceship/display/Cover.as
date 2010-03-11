/**
* Cover by Big Spaceship. June 17, 2009
*
* Copyright (c) 2009 Big Spaceship, LLC
* To contact Big Spaceship, email info@bigspaceship.com or write to us at 45 Main Street #716, Brooklyn, NY, 11201.
* 
**/
package com.bigspaceship.display
{
	import com.bigspaceship.events.AnimationEvent;
	
	import flash.display.MovieClip;
	import flash.events.EventDispatcher;
	
	/**
	 *  The <code>Cover</code> Class covers the site. e.g while Navigation / transitions are in progress.
	 *
	 *  @param			$mc: a MovieClip that is the view and contains all the display objects to be controlled by this Class
	 *  @copyright 		2009 Big Spaceship, LLC
	 *  @author			Daniel Scheibel
	 *  @version		1.0
	 *  @langversion	ActionScript 3.0
	 *  @playerversion	Flash 9.0.41
	 *
	 */
	
	public class Cover extends EventDispatcher{
		
		private var _mc:MovieClip;
		private var _stageSize:Boolean;
		 
		public function get mc():MovieClip{ 
			return _mc; 
		}
		
		public function Cover($mc:MovieClip=null){
			
			if($mc){
				_mc = $mc;
			}else{
				_mc = new MovieClip();
				_mc.graphics.beginFill(0xff0000);
				_mc.graphics.drawRect(0,0,100,100);
				_mc.graphics.endFill();
			}
			
			_mc.alpha = 0;
			_mc.visible = false;
		}
				
		public function animateIn():void{
			if(_mc.stage){
				_mc.width = _mc.stage.stageWidth;
				_mc.height = _mc.stage.stageHeight;
			}
			_mc.visible = true;
			dispatchEvent(new AnimationEvent(AnimationEvent.IN));
		}
		
		public function animateOut():void{
			_mc.visible = false;
			dispatchEvent(new AnimationEvent(AnimationEvent.OUT));
		}
	}
}