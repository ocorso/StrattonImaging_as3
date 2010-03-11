/**
* ModelEvent by Big Spaceship. June 17, 2009
*
* Copyright (c) 2009 Big Spaceship, LLC
* To contact Big Spaceship, email info@bigspaceship.com or write to us at 45 Main Street #716, Brooklyn, NY, 11201.
* 
**/
package com.bigspaceship.events {	
	
	import flash.events.Event;
	
	/**
	 *  The <code>ModelEvent</code> Class describes all Events dispatched from Model
	 *
	 *  @param			$type: (String) Which event to dispatch.
	 *  @param			$data: (Object) Information to pass.
	 *  @param			$bubbles: (Boolean) Indicates whether an event is a bubbling event.
	 *  @param			$cancelable: (Boolean) Indicates whether the behavior associated with the event can be prevented.
	 *  @copyright 		2009 Big Spaceship, LLC
	 *  @author			Daniel Scheibel
	 *  @version		1.0
	 *  @langversion	ActionScript 3.0
	 *  @playerversion	Flash 9.0.0
	 */
	public class ModelEvent extends Event{
		
		private var _data:Object;
		
		public static const LOAD_PROCESS:String = "loadProcess";
		public static const SCREEN_NEXT:String = "nextScreen";
		public static const SCREEN_CUR:String = "currentScreen";
		public static const SCREEN_LAST:String = "previousScreen";
		
		public static const SITE_TITLE:String = "siteTitle";
		
		
		public function get data():Object{
			return this._data;
		}
		
		//-----------------------------------------------------------------------------
		// Constructor functions:
		//-----------------------------------------------------------------------------
		public function ModelEvent($type:String, $data:Object = null, $bubbles:Boolean = false, $cancelable:Boolean = false):void{
			super($type, $bubbles, $cancelable);
			this._data = $data;
		}
		
	}
}