/**
 * AnimationEvent by Big Spaceship. 2006-2010
 *
 * To contact Big Spaceship, email info@bigspaceship.com or write to us at 45 Main Street #716, Brooklyn, NY, 11201.
 * Visit http://labs.bigspaceship.com for documentation, updates and more free code.
 *
 *
 * Copyright (c) 2006-2010 Big Spaceship, LLC
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
	 * 
	 *  @copyright 		2010 Big Spaceship, LLC
	 *  @author			Jamie Kosoy, Daniel Scheibel
	 *  @version		1.0
	 *  @langversion	ActionScript 3.0
	 *  @playerversion	Flash 9.0.41
	 */
	public class AnimationEvent extends Event{
		
		public static const INIT				: String = "INIT";
		                                                    
		public static const IN_START			: String = "IN_START";
		public static const IN					: String = "IN";		
		public static const OUT_START			: String = "OUT_START";
		public static const OUT					: String = "OUT";
		                                                    
		public static const START				: String = "START";
		public static const UPDATE				: String = "UPDATE";
		public static const CANCEL				: String = "CANCEL";
		public static const COMPLETE			: String = "COMPLETE";
		                                                    
		public static const IDLE				: String = "IDLE";
		public static const ROLL_OVER  			: String = "ROLL_OVER";
		public static const ROLL_OVER_START		: String = "ROLL_OVER_START";
		public static const ROLL_OUT   			: String = "ROLL_OUT";
		public static const ROLL_OUT_START		: String = "ROLL_OUT_START";
		public static const CLICK				: String = "CLICK";
		public static const CLICK_START   		: String = "CLICK_START";
		public static const MOUSE_DOWN			: String = "MOUSE_DOWN";
		public static const MOUSE_DOWN_START	: String = "MOUSE_DOWN_START";
		public static const MOUSE_UP			: String = "MOUSE_UP";
		public static const MOUSE_UP_START		: String = "MOUSE_UP_START";
		
		public static const SELECT_START		: String = "selectStart";
		public static const SELECT				: String = "select";
		public static const DESELECT_START		: String = "deselectStart";
		public static const DESELECT			: String = "deselect";
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