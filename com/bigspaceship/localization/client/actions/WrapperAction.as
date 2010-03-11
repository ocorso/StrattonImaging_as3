package com.bigspaceship.localization.client.actions
{
	import com.bigspaceship.localization.client.LocalizationManager;
	import com.bigspaceship.localization.client.TextFieldWrapper;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	public class WrapperAction extends EventDispatcher
	{
		private var _id:String;
		private var _wrapper:TextFieldWrapper
		private var _executed:Boolean = false;
		
		public function get id():String						{	return _id;			}
		public function get wrapper():TextFieldWrapper		{	return _wrapper;	}
		public function get executed():Boolean				{	return _executed;	}
		public function set executed($b:Boolean):void		{	_executed = $b;		}
		
		
		//==================================================
		// PUBLIC
		/**
		 * The ID of the textfield wrapper
		 * @param $id
		 */		
		public function WrapperAction( $id:String )
		{
			if( $id==null || $id.length==0 ){
				_log( "ID must not be null or an empty String." );
			}
			_id = $id;
		}
		
		/**
		 * Applies the action to the TextFieldWrapper and dispatches Event.COMPLETE afterwards.
		 * @param $textfieldWrapper
		 * @event Event.COMPLETE
		 */		
		public final function applyTo( $textfieldWrapper:TextFieldWrapper ):void {
			_wrapper = $textfieldWrapper;
			_executed = true;
			_execute( $textfieldWrapper );
			dispatchEvent( new Event( Event.COMPLETE ) );
		}
		
		override public function toString():String {
			if(_id)	return "[ WrapperAction "+_id+" ]";
			else	return "[ WrapperAction ]";
		}
		
		
		//==================================================
		// PROTECTED
		/**
		 * Override this function to implement custom logic.
		 * @param $wrapper
		 */		
		protected function _execute( $wrapper:TextFieldWrapper ):void {
		}
		
		protected function _log( $msg:Object ):void {
			if( LocalizationManager.DEBUG ) trace( toString() + "\t" + $msg );
		}

	}
}