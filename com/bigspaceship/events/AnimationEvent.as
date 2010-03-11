/**
 * AnimationEvent by Big Spaceship. 2006
 *
 * To contact Big Spaceship, email info@bigspaceship.com or write to us at 45 Main Street #716, Brooklyn, NY, 11201.
 * Visit http://labs.bigspaceship.com for documentation, updates and more free code.
 *
 *
 * Copyright (c) 2006 Big Spaceship, LLC
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
 
package com.bigspaceship.events{
	
	import flash.events.Event;
	
	
	/**
	 *  The <code>AnimationEvent</code> Class describes all Events dispatched during an Animation
	 *
	 *  @param			$type: (String) Which event to dispatch.
	 *  @param			$data: (Object) Information to pass.
	 *  @param			$bubbles: (Boolean) Indicates whether an event is a bubbling event.
	 *  @param			$cancelable: (Boolean) Indicates whether the behavior associated with the event can be prevented.
	 *  @copyright 		2009 Big Spaceship, LLC
	 *  @author			Jamie Kosoy, Daniel Scheibel
	 *  @version		1.0
	 *  @langversion	ActionScript 3.0
	 *  @playerversion	Flash 9.0.41
	 *
	 */
	public class AnimationEvent extends Event{
		
		public static const INIT				: String = "animateInit";
		
		public static const IN_START			: String = "animateInStart";
		public static const IN					: String = "animateIn";
		public static const OUT_START			: String = "animateOutStart";
		public static const OUT					: String = "animateOut";
		
		public static const START				: String = "animateBegin";
		public static const UPDATE				: String = "animateUpdate";
		public static const CANCEL				: String = "animateCancel";
		public static const COMPLETE			: String = "animateComplete";
		
		public static const IDLE				: String = "animateIdle";
		public static const ROLL_OVER  			: String = "animateRollOver";
		public static const ROLL_OVER_START 	: String = "animateRollOverStart";
		public static const ROLL_OUT   			: String = "animateRollOut";
		public static const ROLL_OUT_START  	: String = "animateRollOutStart";
		public static const CLICK				: String = "animateClick";
		public static const CLICK_START   		: String = "animateClickStart";
		public static const MOUSE_DOWN			: String = "animateMouseDown";
		public static const MOUSE_DOWN_START	: String = "animateMouseDownStart";
		public static const MOUSE_UP			: String = "animateMouseUp";
		public static const MOUSE_UP_START		: String = "animateMouseUpStart";
		
		
		private var _data : Object;
		
		public function get data():Object{
			return _data;
		}
		
		public function AnimationEvent($type:String, $data:Object = null, $bubbles:Boolean = false, $cancelable:Boolean = false){
			super($type, $bubbles, $cancelable);
			_data = $data;
		}

		public override function clone():Event{
			return new AnimationEvent(type, _data);
		}
	}
}