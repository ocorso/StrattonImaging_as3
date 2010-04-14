/**
 * StandardButton by Big Spaceship. 2008
 *
 * To contact Big Spaceship, email info@bigspaceship.com or write to us at 45 Main Street #716, Brooklyn, NY, 11201.
 * Visit http://labs.bigspaceship.com for documentation, updates and more free code.
 *
 *
 * Copyright (c) 2008 Big Spaceship, LLC
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

package com.bigspaceship.display
{
	import com.bigspaceship.events.AnimationEvent;
	
	import flash.display.DisplayObject;
	import flash.display.FrameLabel;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	 * Dispatched when button is clicked.
	 *
	 * @eventType flash.events.Event
	 **/
	[Event(name="click", type="flash.events.MouseEvent")]
	
	/**
	 * Dispatched when user rolls over button.
	 * 
	 * @eventType flash.events.Event
	 **/
	[Event(name="roll_over", type="flash.events.MouseEvent")]
	
	/**
	 * Dispatched when user rolls out button.
	 *
	 * @eventType flash.events.Event
	 **/
	[Event(name="roll_out", type="flash.events.MouseEvent")]
	
	/* list of dispatching Events not finished yet */
	

	/**
	 * The <code>StandardButton</code> Class
	 * 
	 * @copyright 		2009 Big Spaceship, LLC
	 * @author			Jamie Kosoy, Daniel Scheibel
	 * @version			1.0 
	 * @langversion		ActionScript 3.0 			
	 * @playerversion 	Flash 9.0.0
	 *
	 */
	public class StandardButton extends Standard{
		
		public var rollOutIsRollOverInversed:Boolean = false;
		
		protected var _active:Boolean = true;
		protected var _btn:DisplayObject;
		
		protected var _selectAnimStartLabel:String = 'SELECT_START';
		protected var _deselectAnimStartLabel:String = 'DESELECT_START';
		
		public function get btn():DisplayObject{
			return _btn;
		}
		
		public function get active():Boolean{
			return _active;
		}
		public function set active($val:Boolean):void{
			if($val && !_active){
				addBtnEventListeners();
			}else if (!$val && _active){
				removeBtnEventListeners();
			} 
		}
	
		public function StandardButton($mc:MovieClip, $btn:DisplayObject = null, $useWeakReference:Boolean = false){
			super($mc, $useWeakReference);
			if($btn){
				_btn = $btn;
			}else if (_mc.btn){
				_btn = _mc.btn;
			}else{
				_btn = _mc;
			}
			
			//ds: add Listeners
			addBtnEventListeners();
			var labels:Array = _mc.currentLabels;
			for (var i:uint = 0; i < labels.length; i++) {
			    var label:FrameLabel = labels[i];
			   
			    switch(label.name){
			    	case 'ROLL_OVER':
			    		_mc.addEventListener(AnimationEvent.ROLL_OVER_START, _onTimelineEvent_handler, false, 0, _useWeakReference);
						_mc.addEventListener(AnimationEvent.ROLL_OVER, _onTimelineEvent_handler, false, 0, _useWeakReference);
			    		break;
			    	case 'ROLL_OUT':
			    		_mc.addEventListener(AnimationEvent.ROLL_OUT_START, _onTimelineEvent_handler, false, 0, _useWeakReference);
						_mc.addEventListener(AnimationEvent.ROLL_OUT, _onTimelineEvent_handler, false, 0, _useWeakReference);
			    		break;
			    	case 'CLICK':
			    		_mc.addEventListener(AnimationEvent.CLICK_START, _onTimelineEvent_handler, false, 0, _useWeakReference);
						_mc.addEventListener(AnimationEvent.CLICK, _onTimelineEvent_handler, false, 0, _useWeakReference);
			    		break;
			    	case 'MOUSE_UP':
			    		_mc.addEventListener(AnimationEvent.MOUSE_UP_START, _onTimelineEvent_handler, false, 0, _useWeakReference);
						_mc.addEventListener(AnimationEvent.MOUSE_UP, _onTimelineEvent_handler, false, 0, _useWeakReference);
			    		break;
			    	case 'MOUSE_DOWN':
			    		_mc.addEventListener(AnimationEvent.MOUSE_DOWN_START, _onTimelineEvent_handler, false, 0, _useWeakReference);
						_mc.addEventListener(AnimationEvent.MOUSE_DOWN, _onTimelineEvent_handler, false, 0, _useWeakReference);
			    		break;
			    }
			}
			
			_btn.addEventListener(MouseEvent.ROLL_OVER, dispatchEvent, false, 0, _useWeakReference);
			_btn.addEventListener(MouseEvent.ROLL_OUT, dispatchEvent, false, 0, _useWeakReference);
			_btn.addEventListener(MouseEvent.MOUSE_UP, dispatchEvent, false, 0, _useWeakReference);
			_btn.addEventListener(MouseEvent.MOUSE_DOWN, dispatchEvent, false, 0, _useWeakReference);
			_btn.addEventListener(MouseEvent.CLICK, dispatchEvent, false, 0, _useWeakReference);
			
			//ds: add Timeline/AnimationEvent Listeners
			_mc.addEventListener(AnimationEvent.IN, _onTimelineEvent_handler, false, 0, _useWeakReference);
			_mc.addEventListener(AnimationEvent.IDLE, _onTimelineEvent_handler, false, 0, _useWeakReference);
			
			_mc.addEventListener(Event.REMOVED_FROM_STAGE, _onRemovedFromStage, false, 0, _useWeakReference);
		}
		
		public function deselect():void{
			if(!active){
				_mc.gotoAndPlay(_deselectAnimStartLabel);	
			}
			_btn.visible = true;
			active = true;
		}
		public function select():void{
			if(active){
				_mc.gotoAndPlay(_selectAnimStartLabel);
			}
			_btn.visible = false;
			active = false;
		}
		
		override public function destroy():void{
			
			_btn.removeEventListener(MouseEvent.ROLL_OVER, _onMouseRollOver_handler);
			_btn.removeEventListener(MouseEvent.ROLL_OVER, dispatchEvent);
			_btn.removeEventListener(MouseEvent.ROLL_OUT, _onMouseRollOut_handler);
			_btn.removeEventListener(MouseEvent.ROLL_OUT, dispatchEvent);
			_btn.removeEventListener(MouseEvent.CLICK, _onMouseClick_handler);
			_btn.removeEventListener(MouseEvent.CLICK, dispatchEvent);
			_btn.removeEventListener(MouseEvent.MOUSE_UP, _onMouseUp_handler);
			_btn.removeEventListener(MouseEvent.MOUSE_UP, dispatchEvent);
			_btn.removeEventListener(MouseEvent.MOUSE_DOWN, _onMouseDown_handler);
			_btn.removeEventListener(MouseEvent.MOUSE_DOWN, dispatchEvent);
			_btn = null;
			
			_mc.removeEventListener(AnimationEvent.IN, _onTimelineEvent_handler);
			_mc.removeEventListener(AnimationEvent.IDLE, _onTimelineEvent_handler);
			_mc.removeEventListener(AnimationEvent.ROLL_OUT_START, _onTimelineEvent_handler);
			_mc.removeEventListener(AnimationEvent.ROLL_OUT, _onTimelineEvent_handler);
			_mc.removeEventListener(AnimationEvent.ROLL_OVER_START, _onTimelineEvent_handler);
			_mc.removeEventListener(AnimationEvent.ROLL_OVER, _onTimelineEvent_handler);
			_mc.removeEventListener(AnimationEvent.CLICK_START, _onTimelineEvent_handler);
			_mc.removeEventListener(AnimationEvent.CLICK, _onTimelineEvent_handler);
			_mc.removeEventListener(AnimationEvent.MOUSE_DOWN_START, _onTimelineEvent_handler);
			_mc.removeEventListener(AnimationEvent.MOUSE_DOWN, _onTimelineEvent_handler);
			_mc.removeEventListener(AnimationEvent.MOUSE_UP_START, _onTimelineEvent_handler);
			_mc.removeEventListener(AnimationEvent.MOUSE_UP, _onTimelineEvent_handler);
			
			_mc.removeEventListener(Event.REMOVED_FROM_STAGE, _onRemovedFromStage);
			super.destroy();
		}
		
		protected function addBtnEventListeners():void{
			var labels:Array = _mc.currentLabels;
			for (var i:uint = 0; i < labels.length; i++) {
			    var label:FrameLabel = labels[i];
			   
			    switch(label.name){
			    	case 'ROLL_OVER':
			    		_btn.addEventListener(MouseEvent.ROLL_OVER, _onMouseRollOver_handler, false, 0, _useWeakReference);
			    		break;
			    	case 'ROLL_OUT':
			    		_btn.addEventListener(MouseEvent.ROLL_OUT, _onMouseRollOut_handler);
			    		break;
			    	case 'CLICK':
			    		_btn.addEventListener(MouseEvent.CLICK, _onMouseClick_handler, false, 0, _useWeakReference);
			    		break;
			    	case 'MOUSE_UP':
			    		_btn.addEventListener(MouseEvent.MOUSE_UP, _onMouseUp_handler, false, 0, _useWeakReference);
			    		break;
			    	case 'MOUSE_DOWN':
			    		_btn.addEventListener(MouseEvent.MOUSE_DOWN, _onMouseDown_handler, false, 0, _useWeakReference);
			    		break;
			    }
			}
			// sk: active? at this point, we are
			_active = true;
		}
		
		protected function removeBtnEventListeners():void{
			_btn.removeEventListener(MouseEvent.ROLL_OVER, _onMouseRollOver_handler);
			_btn.removeEventListener(MouseEvent.ROLL_OUT, _onMouseRollOut_handler);
			_btn.removeEventListener(MouseEvent.CLICK, _onMouseClick_handler);
			_btn.removeEventListener(MouseEvent.MOUSE_UP, _onMouseUp_handler);
			_btn.removeEventListener(MouseEvent.MOUSE_DOWN, _onMouseDown_handler);
			// sk: active? at this point, we are not
			_active = false;
		}
		
		
		protected function _onTimelineEvent_handler($evt:AnimationEvent) : void{
			_curState = $evt.type;
			switch ($evt.type) {
				case AnimationEvent.IN:
				case AnimationEvent.IDLE:
					_mc.stop();
					break;
					
				case AnimationEvent.ROLL_OVER_START:
					dispatchEvent(new AnimationEvent(AnimationEvent.ROLL_OVER_START));
					break;
				case AnimationEvent.ROLL_OVER:
					_mc.stop();
					dispatchEvent(new AnimationEvent(AnimationEvent.ROLL_OVER));
					break;
					
				case AnimationEvent.ROLL_OUT_START:
					dispatchEvent(new AnimationEvent(AnimationEvent.ROLL_OUT_START));
					break;
				case AnimationEvent.ROLL_OUT:
					_mc.stop();
					_mc.gotoAndStop("IDLE");
					dispatchEvent(new AnimationEvent(AnimationEvent.ROLL_OUT));
					break;
					
				case AnimationEvent.CLICK_START:
					dispatchEvent(new AnimationEvent(AnimationEvent.CLICK_START));
					break;
				case AnimationEvent.CLICK:
					_mc.stop();
					dispatchEvent(new AnimationEvent(AnimationEvent.CLICK));
					break;
				
				case AnimationEvent.MOUSE_DOWN_START:
					dispatchEvent(new AnimationEvent(AnimationEvent.MOUSE_DOWN_START));
					break;
				case AnimationEvent.MOUSE_DOWN:
					_mc.stop();
					dispatchEvent(new AnimationEvent(AnimationEvent.MOUSE_DOWN));
					break;
				case AnimationEvent.MOUSE_UP_START:
					dispatchEvent(new AnimationEvent(AnimationEvent.MOUSE_UP_START));
					break;
				case AnimationEvent.MOUSE_UP:
					_mc.stop();
					dispatchEvent(new AnimationEvent(AnimationEvent.MOUSE_UP));
					break;
			}
		}
		
		//ds: MouseEvent Handler:
		
		private function _onMouseRollOver_handler($evt:MouseEvent):void{
			_mc.gotoAndPlay('ROLL_OVER_START');
		}
		
		private function _onMouseRollOut_handler($evt:MouseEvent):void{
			//trace('ROLLOUT');
			if(_curState == AnimationState.ROLL_OVER_START || _curState == AnimationState.ROLL_OVER){
				_mc.gotoAndPlay('ROLL_OUT_START');
			}
		}
		
		protected function _onMouseClick_handler($evt:MouseEvent):void{
			//trace('StandardBtn: CLICK');
			_mc.gotoAndPlay('CLICK_START');
		}
		
		private function _onMouseUp_handler($evt:MouseEvent):void{
			//trace('StandardBtn: CLICK');
			_mc.gotoAndPlay('MOUSE_UP_START');
		}
		private function _onMouseDown_handler($evt:MouseEvent):void{
			//trace('StandardBtn: CLICK');
			_mc.gotoAndPlay('MOUSE_DOWN_START');
		}
		
		private function _onRemovedFromStage($evt:Event):void{
			destroy();
		}
		
	}
}