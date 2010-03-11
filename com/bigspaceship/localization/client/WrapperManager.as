	package com.bigspaceship.localization.client
{
	import com.bigspaceship.localization.client.actions.WrapperAction;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	
	/**
	 * 
	 * @author Benjamin Bojko
	 */	
	internal class WrapperManager extends EventDispatcher
	{
		
		private var _registrationQueue:Array;	// of TextFieldWrapper
		private var _registeredWrappers:Array;	// of TextFieldWrapper
		
		private var _wrapperMap:Dictionary;		// key: wrapper,	value: TextFieldWrapper (all wrappers)
		private var _wrapperIdMap:Dictionary;	// key: wrapperId,	value: TextFieldWrapper (only with id set)
		private var _actionsMap:Dictionary;		// key: wrapperId,	value: Array of WrapperAction
		
		
		//==================================================
		/**
		 * 
		 */		
		public function WrapperManager(){
			_registrationQueue = new Array();
			_registeredWrappers = new Array();
			
			_wrapperMap = new Dictionary(true);
			_wrapperIdMap = new Dictionary(true);
			_actionsMap = new Dictionary(false);
		}
		
		
		//==================================================
		// PUBLIC
		/**
		 * Registers a wrapper to the manager. If the manager
		 * has already been initialized, the wrapper will  be
		 * initialized immediately. Otherwise it will be stored
		 * in a queue and initialized as soon as the manager is
		 * ready.
		 * 
		 * @param $wrapper
		 * @return True if the wrapper could be initialized, false
		 * if the manager has to wait to be initialized itself.
		 */		
		public function registerWrapper( $wrapper:TextFieldWrapper ):Boolean {
			
			// only directly register wrapper when initialized
			if( !LocalizationManager.getInstance().initialized ) {
				// temporarily store wrappers
				_registrationQueue.push( $wrapper );
				return false;
				
			// directly initialize wrapper
			} else {
				_initWrapper( $wrapper );
				return true;
			}
		}
		
		
		/**
		 * Removes the wrapper from the registered wrappers 
		 * or registration queue arrays.
		 * @param $wrapper
		 * @return The removed wrapper. Null if the wrapper
		 * couldn't be found in either two of the arrays.
		 */		
		public function unregisterWrapper( $wrapper:TextFieldWrapper ):TextFieldWrapper {
			
			// check if wrapper has been registered
			if( isWrapperRegistered( $wrapper ) ){
				
				// delete from map
				delete _wrapperMap[ $wrapper ];
				
				// remove from id map if wrapper is contained
				if( _wrapperIdMap.hasOwnProperty( $wrapper.id ) ){
					delete _wrapperIdMap[$wrapper.id];
				}
				
				// look in registered wrappers
				for( var i:int=0; i<_registeredWrappers.length; i++ ){
					if( _registeredWrappers[i] == $wrapper ){
						return _registeredWrappers.splice( i, 1 );
					}
				}
				// look in registration queue
				for( var j:int=0; j<_registrationQueue.length; j++ ){
					if( _registrationQueue[j] == $wrapper ){
						return _registrationQueue.splice( j, 1 );
					}
				}
			}
			// wrapper not registered at all
			return null;
		}
		
		
		/**
		 * Checks if the wrapper is already registered to this class.
		 * @param $wrapper
		 * @return 
		 */		
		public function isWrapperRegistered( $wrapper:TextFieldWrapper ):Boolean {
			return _wrapperMap.hasOwnProperty( $wrapper );
		}
		
		
		/**
		 * Add an action that will be applied to the text field wrapper
		 * with the action id as soon as a wrapper registers with that id.
		 * 
		 * @param $action
		 * 
		 * @return True if the action could be executed immediately because a
		 * text field was already registered to that id, false if no text field
		 * was registered to that id yet and the action could not be executed.
		 */		
		public function addAction( $action:WrapperAction ):Boolean {
			
			// wrapper with id already initialized - apply action instantly
			if( _wrapperIdMap.hasOwnProperty( $action.id ) ){
				var wrapper:TextFieldWrapper = _wrapperIdMap[ $action.id ] as TextFieldWrapper;
				$action.applyTo( wrapper );
				return true;
				
				
			// wrapper with id not initialized yet - add action to queue
			} else {
				
				// create actions array for id if necessary
				if( !_actionsMap.hasOwnProperty( $action.id ) ){
					_actionsMap[ $action.id ] = new Array();
				}
				
				// add action to array
				var actionsArray:Array = _actionsMap[ $action.id ];
				actionsArray.push( $action );
				
				return false;
			}
		}
		
		
		/**
		 * Removes the action from the actions array for the action's id.
		 * If the same action instance is contained in the array several
		 * times, all of the references to this instance will be removed.
		 * @param $action
		 * @return True if the action was found, false if it was not.
		 */	
		public function removeAction( $action:WrapperAction ):Boolean {
			var actionFound:Boolean = false;
			
			// check if actions for $action.id exist
			if( _actionsMap.hasOwnProperty( $action.id ) ){
				
				var actionsArray:Array = _actionsMap[ $action.id ];
				
				// look for action in actionsArray
				for( var i:int=actionsArray.length-1; i>=0; i-- ){
					
					// remove action if it was found (could be in array several times)
					if( actionsArray[i] == $action ){
						actionsArray.splice( i, 1 );
						actionFound = true;
					}
				}
			}
			
			return actionFound;
		}
		
		
		/**
		 * Initializes all the textfields in the queue and
		 * empties the queue.
		 */
		public function init():void {
			
			var i:int;
			
			// reset all actions
			for each( var actionsArray:Array in _actionsMap ){
				for( i=0; i<actionsArray.length; i++ ){
					actionsArray[i].executed = false;
				}
			}
			
			// initialize wrappers
			for( i=_registrationQueue.length-1; i>=0; i-- ){
				_initWrapper( _registrationQueue.pop() );
			}
			
			dispatchEvent( new Event( Event.INIT ) );
		}
		
		
		/**
		 * Moves all registered wrappers back to the list
		 * of unregistered wrappers and sets all actions'
		 * executed flags to false.
		 */		
		public function reset():void {
			var i:int;
			
			// reset all actions
			for each( var actionsArray:Array in _actionsMap ){
				for( i=0; i<actionsArray.length; i++ ){
					actionsArray[i].executed = false;
				}
			}
			
			// reset wrappers
			for( i=_registeredWrappers.length-1; i>=0; i-- ){
				_registrationQueue.push( _registeredWrappers.pop() );
			}
		}
		
		override public function toString():String {
			return "[ WrapperQueue ]";
		}
		
		
		//==================================================
		// PROTECTED
		/**
		 * Controls the output of this class.
		 * @param $msg
		 */		
		protected function _log( $msg:Object ):void {
			LocalizationManager.getInstance().log( this + "\t\t" + $msg );
		}
		
		
		//==================================================
		// PRIVATE - HELPERS
		/**
		 * Applies text and style to a wrapper and stores it
		 * to all relevant containers.
		 * 
		 * @param $wrapper
		 */		
		private function _initWrapper( $wrapper:TextFieldWrapper ):void {
			var lm:LocalizationManager = LocalizationManager.getInstance();
			
			
			// read and set the text
			var text:String;
			
			// use locale id text if it it's defined
			if( $wrapper.localeId ){
				text = lm.languageManager.getText( $wrapper.localeId );
				if( text ){
					$wrapper.text = text;
				}
				
			// use wrapper text if it's defined
			} else {
				text = $wrapper.text;
			}
			
			
			// apply the style
			if(  $wrapper.styleId && lm.styleManager.hasStyle( $wrapper.styleId ) ){
				lm.styleManager.applyStyle( $wrapper, $wrapper.styleId, text );
			}
			
			
			// add to registered wrappers and wrapper map
			_registeredWrappers.push( $wrapper );
			_wrapperMap[ $wrapper ] = $wrapper;
			
			
			// if wrapper has id, add to wrapper id map and see if any actions exist for it.
			if( $wrapper.id ){
				
				// check for duplicates
				if( _wrapperIdMap.hasOwnProperty( $wrapper.id ) && _wrapperIdMap[$wrapper.id] != $wrapper ){
					//_log("More than one wrappers with id: \""+$wrapper.id+"\". Overwriting old one.");
				}
				
				// add to map
				_wrapperIdMap[ $wrapper.id ] = $wrapper;
				
				// see if actions exist for this id
				if( _actionsMap.hasOwnProperty( $wrapper.id ) ){
					
					var actionsArray:Array = _actionsMap[ $wrapper.id ] as Array;
					
					// apply actions
					for( var i:int=0; i<actionsArray.length; i++ ){
						var action:WrapperAction = actionsArray[i];
						if( !action.executed || action.wrapper!=$wrapper ) {
							action.applyTo( $wrapper );
							//_log( action + " applied to " + $wrapper );
						}
					}
				}
			}
			
			// dispatches Event.INIT from wrapper
			$wrapper.postInit();
			
		}
		
		
	}
	
	
}




