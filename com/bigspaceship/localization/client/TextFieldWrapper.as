package com.bigspaceship.localization.client
{
	
	import com.bigspaceship.localization.client.actions.*;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.utils.getQualifiedClassName;
	
	/**
	 * The TextFieldWrapper class is a MovieClip containing
	 * a TextField and is used as an interface between that
	 * TextField and the LocalizationManager. 
	 * 
	 * @author Benjamin Bojko
	 */	
	public class TextFieldWrapper extends MovieClip {
		
		private static var __numInstances:uint = 0;
		
		protected var _textField:TextField;
		
		private var _text:String;
		
		private var _id:String;
		private var _localeId:String;
		private var _styleId:String;
		
		private var _waitForTimelineInit:Boolean = false;
		
		private var _originalTFPos:Point;
		private var _actions:Object;
		
		//==================================================
		/**
		 * Creates a new TextFieldWrapper instance. If any of the values
		 * are defined in the constructor and $waitForTimelineInit left
		 * as false, init() will be called instantly.
		 * 
		 * If the TextFieldWrapper is linked to a library symbol it will
		 * scan its children and use the first TextField instance in the
		 * display list as main TextField.
		 * 
		 * If no TextField is in the display list yet, a new instance is
		 * automatically created in the constructor.
		 * 
		 * @param $id					If left to null a default id "wrapperXX" will be assigned.
		 * @param $localeId				The locale ID that will be used from the language XMLs.
		 * @param $styleId				The style ID that will be used from the language stylesheets.
		 * @param $autoSize				true/false (default is false)
		 * @param $waitForTimelineInit	true/false (default is false)
		 */			
		public function TextFieldWrapper( $id:String=null, $localeId:String=null, $styleId:String=null, $autoSize:*=null, $waitForTimelineInit:Boolean=false ) {
			// checks if a text field is already on the timeline or if one has to be created
			_textField = _getTextField();
			
			// locally store the initial text
			_text = _textField.htmlText;
			
			// save the original textfield position to allow more flexible offsetX/Y
			_originalTFPos = new Point( _textField.x, _textField.y );
			
			// always generate default id
			_id = ($id && $id.length>0) ? $id :  "wrapper"+__numInstances++;
			
			_waitForTimelineInit = $waitForTimelineInit;
			
			// automatically initialize if any values are set and waitForTimelineInit is false
			if( !$waitForTimelineInit && (_localeId || _styleId || $autoSize) ){
				init( $id, $localeId, $styleId, $autoSize );
			}
		}
		
		
		/**
		 * Applies the text and the style to this instance's text field.
		 *  
		 * @param $id			If left to null a default id "wrapperXX" will be assigned.
		 * @param $localeId		The locale ID that will be used from the language XMLs.
		 * @param $styleId		The style ID that will be used from the language stylesheets.
		 * @param $autoSize		true/false (default is false)
		 */		
		public function init( $id:String=null, $localeId:String=null, $styleId:String=null, $autoSize:*=null ):void {
			if( $id )			_id			= $id;
			if( $localeId )		_localeId	= $localeId;
			if( $styleId )		_styleId	= $styleId;
			if( $autoSize )		autoSize	= new Boolean( $autoSize );
			
			LocalizationManager.getInstance().wrapperQueue.unregisterWrapper( this );
			LocalizationManager.getInstance().wrapperQueue.registerWrapper( this );
		}
		
		
		override public function toString():String {
			if(_id)	return "[ TextFieldWrapper "+_id+" ]";
			else	return "[ TextFieldWrapper ]";
		}
		
		
		//==================================================
		// PUBLIC - ACCESSORS
		/**
		 * The text field that is wrapped by this instance.
		 */		
		public function get textField():TextField		{	return _textField;									}
		
		/**
		 * Default is false. If set to true, init() will not be
		 * called automatically after id, localeId, styleId or
		 * autoSize is set.
		 * 
		 * This could save performance in cases where init would be
		 * called several times.
		 * 
		 * This value is set to false automatically when the
		 * protected method _initFromTimeline() is called.
		 */		
		public function get waitForTimelineInit():Boolean			{	return _waitForTimelineInit;			}
		public function set waitForTimelineInit($b:Boolean):void	{	_waitForTimelineInit=$b;				}
		
		/**
		 * The id property helps the LocalizationManager identify
		 * text field wrappers when they are initialized.
		 * 
		 * This is useful if you want to register an action to a
		 * text field wrapper that has not yet been created.
		 * 
		 * Let's say for example, that a textfield wrapper on stage
		 * should dynamically be assigned a localeId. You could add
		 * a new action which does that and waits for the text field
		 * wrapper with that id to be initialized.
		 */		
		public function get id():String					{	return _id;											}
		public function set id($id:String):void			{	_id=$id; if(!_waitForTimelineInit) init();			}
		
		/**
		 * The locale id defines which text node from the language XML
		 * is assigned to this text field wrapper. This property doesn't
		 * have to be necessarily be set, since the text can be set manually.
		 */		
		public function get localeId():String			{	return _localeId;									}
		public function set localeId($id:String):void	{	_localeId=$id; if(!_waitForTimelineInit) init();	}
		
		/**
		 * The style id defines which default style is applied to the
		 * text field from the current language's stylesheet.
		 * 
		 * Inline styles can still be used with span tags.
		 */		
		public function get styleId():String			{	return _styleId;									}
		public function set styleId($id:String):void	{	_styleId=$id; if(!_waitForTimelineInit) init();		}
		
		/**
		 * Sets the text of the text field. This should only be
		 * used if there is no locale Id defined.
		 * 
		 * TODO: This currently only works if the style id is set AFTER setting the text, because
		 * the html-text needs to be wrapped with the style tags.
		 */
		public function get text():String				{	return _text;									}
		public function set text($s:String):void		{	_textField.htmlText = _text = $s; if(!_waitForTimelineInit) init();	}
		
		/**
		 * If set to true, the text field's autoSize property will be
		 * automatically set to either left, center or right, depending
		 * on its style's text-align property.
		 * 
		 * This is especially useful to avoid situations where the
		 * autoSize property could otherwise conflict with the style's
		 * text-align. 
		 */		
		public function get autoSize():Boolean			{
			var action:SetAutoSizeAction = _getActionForType( SetAutoSizeAction ) as SetAutoSizeAction;
			return (action) ? (action.autoSize) : (_textField.autoSize != TextFieldAutoSize.NONE);
		}
		public function set autoSize($b:Boolean):void	{
			if( $b != autoSize ){
				_setActionForType( new SetAutoSizeAction( _id, $b ) );
				if(!_waitForTimelineInit) init();
			}
		}
		
		
		//==================================================
		// INTERNAL - ACCESSORS
		internal function get offsetX():Number			{	return _textField.x-_originalTFPos.x;	}
		internal function set offsetX($x:Number):void	{	_textField.x = _originalTFPos.x + $x;	}
		
		internal function get offsetY():Number			{	return _textField.y-_originalTFPos.y;	}
		internal function set offsetY($y:Number):void	{	_textField.y = _originalTFPos.y + $y;	}
		
		
		//==================================================
		// INTERNAL
		/**
		 * Called from LocalizationManager after init() is called and dispatches an init event.
		 */		
		internal function postInit():void {
			dispatchEvent( new Event( Event.INIT ) );
		}
		
		//==================================================
		// PROTECTED
		/**
		 * Use this method to initialize values from the timeline.
		 * 
		 * @param $id			If left to null a default id "wrapperXX" will be assigned.
		 * @param $localeId		The locale ID that will be used from the language XMLs.
		 * @param $styleId		The style ID that will be used from the language stylesheets.
		 * @param $autoSize		true/false (default is false)
		 */		
		protected function _initFromTimeline( $id:String=null, $localeId:String=null, $styleId:String=null, $autoSize:*=null ):void {
			_waitForTimelineInit = false;
			init( $id, $localeId, $styleId, $autoSize );
		}
		
		protected function _log( $msg:Object ):void {
			LocalizationManager.getInstance().log( $msg );
		}
		
		
		//==================================================
		// PRIVATE
		/**
		 * Checks if this instance already contains a text field and
		 * creates on if it doesn't.
		 * 
		 * @return 
		 */		
		private function _getTextField():TextField {
			// first child is TextField
			if( numChildren>0 && getChildAt(0) is TextField ){
				return getChildAt( 0 ) as TextField;
				
			// contains more than one child or first child is no text field
			} else {
				
				// try to find textfield among children
				for( var i:int=0; i<numChildren; i++ ){
					if( getChildAt(i) is TextField ){
						//_log("This instance contains more than one child but one of them is a TextField which will be used as main textfield.");
						return getChildAt(i) as TextField;
					}
				}
				
				// none of the children is text field
				//_log("This instance contains children but none of them is a TextField. Creating a default TextField.");
				var defaultTf:TextField = new TextField();
				defaultTf.autoSize = TextFieldAutoSize.LEFT;
				
				return addChild( defaultTf ) as TextField;
					
			}
			
		}
		
		/**
		 * Makes sure that this instance always only has one type of each action.
		 * Old actions of this type will be removed from the wrapper queue if they
		 * were already executed and replaced by the new action.
		 */		
		private function _setActionForType( $action:WrapperAction ):void {
			
			if( !_actions ) _actions = new Object();
			
			var className:String = getQualifiedClassName( $action );
			
			// remove old action
			if( _actions[ className ] ){
				var oldAction:WrapperAction = _actions[ className ];
				if( oldAction.executed ) LocalizationManager.getInstance().wrapperQueue.removeAction( oldAction );
			}
			
			// add new action
			_actions[ className ] = $action;
			LocalizationManager.getInstance().wrapperQueue.addAction( $action );
		}
		
		
		/**
		 * Returns the unique action for a class type.
		 */		
		private function _getActionForType( $class:Class ):WrapperAction {
			if( !_actions ) _actions = new Object();
			return _actions[ getQualifiedClassName( $class ) ];
		}
		
	}
	
}




