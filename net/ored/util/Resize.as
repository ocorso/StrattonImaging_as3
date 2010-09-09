package net.ored.util
{
	import com.bigspaceship.utils.Out;
	
	import flash.display.Stage;
	import flash.events.Event;
	
	/**
	 * Resize
	 *
	 * @copyright        2009 Big Spaceship, LLC
	 * @author           Matt Kenefick
	 * @version          1.0
	 * @langversion      ActionScript 3.0
	 * @playerversion    Flash 9.0.41
	 * 
	 * @Todo
	 *    - Add ability to override a width property
	 *      with a custom set one. This is helpful for
	 *      objects that should be centered at X, but 
	 *      change size.
	 */
	
	
	public class Resize{
		
		public static var STAGE          : Stage;
		
		private static var _objects     : Array     =   [];
		
		public static var CENTER_X      : String    =   'center_x';
		public static var CENTER_Y      : String    =   'center_y';
		public static var CENTER_XY     : String    =   'center_xy';
		public static var CENTER        : String    =   'center_xy';
		public static var FULLSCREEN    : String    =   'scale_fullscreen';
		public static var FULLSCREEN_X  : String    =   'scale_fullscreen_x';
		public static var FULLSCREEN_Y  : String    =   'scale_fullscreen_y';
		public static var CORNER_TL     : String    =   'corner_tl';
		public static var CORNER_TR     : String    =   'corner_tr';
		public static var CORNER_BL     : String    =   'corner_bl';
		public static var CORNER_BR     : String    =   'corner_br';
		public static var BOTTOM        : String    =   'align_bottom';
		public static var TOP           : String    =   'align_top';
		public static var LEFT          : String    =   'align_left';
		public static var RIGHT         : String    =   'align_right';
		public static var CUSTOM        : String    =   'custom';
		
		public static var SETTINGS      : Object    =   {
			minWidth:   0,
			minHeight:  0,
			enabled:    true
		};
		
		public static function remove($id:String):void{
			_objects[$id]   =   null;
		};
		
		public static function setStage($stage:Stage):void{
			STAGE   =   $stage;
		};
		
		public static function add($id:String, $element:*, $type:Array, $params:* = null):void{
			var obj:Object;
			
			obj =   {
				id:         $id,
				element:    $element,
				type:       $type,
				params:     $params,
				extraParamsHandled: false
			};
			
			_objects[$id]   =   obj;
			
			// resize stage
			Resize.onResize();
		}
		
		public static function onResize($e:Event=null):void{
			var ii:*;
			
			// settings to cancel resize
			if( !Resize.SETTINGS.enabled )
				return;
			
			// do resize
			// _objects is the list of all objects waiting to be resized
			for( var i:Object in _objects ){
				
				if( _objects[i] != null ){
					
					try{
						if( typeof(_objects[i].type) != "string"){
							
							// multiple resizers
							for( ii in _objects[i].type ){
								
								/**
								 *  This `isLast` is required because the handled optional
								 *  params must only be applied on the last
								 *  iteration of Resizing. If you have a FULLSCREEN X and
								 *  FULLSCREEN Y... with `height` and `width` properties
								 *  in handler, the `height` will be overwritten by the
								 *  FULLSCREEN Y.
								 **/
								var isLast:int  =   ii == _objects[i].type.length-1 ? 1 : 0;
								
								// calls a private function below with params
								Resize['_'+_objects[i].type[ii]](
									_objects[i],
									_objects[i].element,
									_objects[i].params,
									isLast
								);
							}
						}else{
							// single resizer
							Resize['_'+_objects[i].type](_objects[i], _objects[i].element, _objects[i].params, 1);
						}
						
						
						// reset extra params so they can be called again
						_objects[i].extraParamsHandled = false;
						
						Out.debug( Resize,
							"Running Resize: " + _objects[i].type +
							" on " + _objects[i].element.name.toString()
						);
					}catch($e:Error){
						Out.debug( Resize,
							"Resize error on " + _objects[i].element.name.toString()
						);
					}
				}
			}
			
		}
		
		/****************************************************
		 * Resizer Settings Checks
		 * *************************************************/
		private static function _checkX():Boolean{
			if( Resize.STAGE.stageWidth < Resize.SETTINGS.minWidth )
				return false;
			return true;
		}
		private static function _checkY():Boolean{
			if( Resize.STAGE.stageHeight < Resize.SETTINGS.minHeight )
				return false;
			return true;
		}
		
		
		/*****************************************************
		 * Resizer Functions
		 * *************************************************/
		private static function _handleParams($object:*, $element:*, $params:Object):void{
			if( $object.extraParamsHandled )
				return;
			
			for( var i:String in $params ){
				if( typeof($params[i]) == 'function')
					return;
				$element[i] += $params[i];
			}
			
			$object.extraParamsHandled = true;
		}
		
		// workers
		private static function _center_x($object:Object, $element:*, $params:Object, $useHandler:int = 1):void{
			if( !_checkX() ) return;
			$element.x      =   (Resize.STAGE.stageWidth / 2) - ($element.width/2);
			if($useHandler)
				_handleParams($object, $element, $params);
		}
		
		private static function _center_y($object:Object, $element:*, $params:Object, $useHandler:int = 1):void{
			if( !_checkY() ) return;
			$element.y      =   (Resize.STAGE.stageHeight / 2) - ($element.height/2);
			if($useHandler)
				_handleParams($object, $element, $params);
		}
		
		private static function _align_left($object:Object, $element:*, $params:Object, $useHandler:int = 1):void{
			if( !_checkX() ) return;
			$element.x      =   0;
			if($useHandler)
				_handleParams($object, $element, $params);
		}
		
		private static function _align_right($object:Object, $element:*, $params:Object, $useHandler:int = 1):void{
			if( !_checkX() ) return;
			$element.x      =   Resize.STAGE.stageWidth - $element.width;
			if($useHandler)
				_handleParams($object, $element, $params);
		}
		
		private static function _align_top($object:Object, $element:*, $params:Object, $useHandler:int = 1):void{
			if( !_checkY() ) return;
			$element.y      =   0;
			if($useHandler)
				_handleParams($object, $element, $params);
		}
		
		private static function _align_bottom($object:Object, $element:*, $params:Object, $useHandler:int = 1):void{
			if( !_checkY() ) return;
			$element.y      =   Resize.STAGE.stageHeight - $element.height;
			if($useHandler)
				_handleParams($object, $element, $params);
		}
		
		private static function _scale_full_width($object:Object, $element:*, $params:Object, $useHandler:int = 1):void{
			if( !_checkX() ) return;
			$element.width  =   Resize.STAGE.stageWidth;
			if($useHandler)
				_handleParams($object, $element, $params);
		}
		
		private static function _scale_full_height($object:Object, $element:*, $params:Object, $useHandler:int = 1):void{
			if( !_checkY() ) return;
			$element.height =   Resize.STAGE.stageHeight;
			if($useHandler)
				_handleParams($object, $element, $params);
		}
		
		private static function _custom($object:Object, $element:*, $params:Object, $useHandler:int = 1):void{
			$params.custom($element, $params, Resize.STAGE);
			if($useHandler)
				_handleParams($object, $element, $params);
		}
		
		
		// Callable
		protected static function _center_xy($object:Object, $element:*, $params:Object, $useHandler:int = 1):void{
			Resize._center_x($object, $element, $params, $useHandler);
			Resize._center_y($object, $element, $params, $useHandler);
		}
		
		protected static function _corner_tl($object:Object, $element:*, $params:Object, $useHandler:int = 1):void{
			Resize._align_left($object, $element, $params, $useHandler);
			Resize._align_top($object, $element, $params, $useHandler);
		}
		
		protected static function _corner_tr($object:Object, $element:*, $params:Object, $useHandler:int = 1):void{
			Resize._align_right($object, $element, $params, $useHandler);
			Resize._align_top($object, $element, $params, $useHandler);
		}
		
		protected static function _corner_bl($object:Object, $element:*, $params:Object, $useHandler:int = 1):void{
			Resize._align_left($object, $element, $params, $useHandler);
			Resize._align_bottom($object, $element, $params, $useHandler);
		}
		
		protected static function _corner_br($object:Object, $element:*, $params:Object, $useHandler:int = 1):void{
			Resize._align_right($object, $element, $params, $useHandler);
			Resize._align_bottom($object, $element, $params, $useHandler);
		}
		
		protected static function _scale_fullscreen($object:Object, $element:*, $params:Object, $useHandler:int = 1):void{
			Resize._scale_full_width($object, $element, $params, $useHandler);
			Resize._scale_full_height($object, $element, $params, $useHandler);
		}
		
		protected static function _scale_fullscreen_x($object:Object, $element:*, $params:Object, $useHandler:int = 1):void{
			Resize._scale_full_width($object, $element, $params, $useHandler);
		}
		
		protected static function _scale_fullscreen_y($object:Object, $element:*, $params:Object, $useHandler:int = 1):void{
			Resize._scale_full_height($object, $element, $params, $useHandler);
		}
		
	}
}