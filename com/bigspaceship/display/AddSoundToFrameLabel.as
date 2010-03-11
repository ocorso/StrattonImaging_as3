package com.bigspaceship.display
{
	import com.bigspaceship.audio.AudioManager;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;

	public class AddSoundToFrameLabel extends EventDispatcher
	{
		
		private var _stndrd:IStandard;
		private var _eventToSoundId_obj:Object;
		
		public function AddSoundToFrameLabel($standardDisplayObject:IStandard, $eventToSoundId:Object)
		{
			_stndrd = $standardDisplayObject;
			_eventToSoundId_obj = $eventToSoundId;
			for (var keyEvent:String in _eventToSoundId_obj) { 
				trace("keyEvent."+keyEvent+" = "+_eventToSoundId_obj[keyEvent]); 
				$standardDisplayObject.addEventListener(keyEvent, _onTimelineEvent_handler);
			} 
		}
		
		private function _onTimelineEvent_handler($evt:Event):void 
		{
			trace('play Sound');
			if(_eventToSoundId_obj.hasOwnProperty($evt.type)){
				if(_eventToSoundId_obj[$evt.type] is Array){
					AudioManager.getInstance().playEffectSound.apply(null, _eventToSoundId_obj[$evt.type]);
				}else{
					AudioManager.getInstance().playEffectSound(_eventToSoundId_obj[$evt.type]);
				}
				
			}
		}
	}
}