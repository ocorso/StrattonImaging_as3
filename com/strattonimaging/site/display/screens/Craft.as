package com.strattonimaging.site.display.screens
{
	import com.bigspaceship.display.StandardButton;
	import com.bigspaceship.utils.Out;
	import com.strattonimaging.site.Constants;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	
	import net.ored.util.Resize;
	
	public class Craft extends Screen implements IScreen{
		
		private var _serviceIdsToItems			:Dictionary;
		private var _serviceItemsToIds			:Dictionary;

		public function Craft($mc:MovieClip, $xml:XML, $useWeakReference:Boolean=false){
			super($mc, $xml, $useWeakReference);
		}
		
		override protected function _onAnimateInStart():void{
			Out.status(this, "in_start():: here is loadlist: "+_loadList);
			
			setupButtons();
			setupResize();
			
	
			
		}//end function onAnimateInStart
		public function setupButtons():void{
			//var sb:StandardButton = new StandardButton(_mc.s1);
			_serviceIdsToItems = new Dictionary(true);
			_serviceItemsToIds = new Dictionary(true);
			
			//setup nav
			for(var i:int=0;i<_loadList.length();i++) {
				var id:String = _loadList[i].@id.toString();
				Out.info(this, "the id of this button is: "+ id);
				//setup nav btns
				_serviceIdsToItems[id] = new StandardButton(_mc["s"+i], _mc["s"+i].btn);					
				_serviceIdsToItems[id].mc.tf.txt.text = _loadList[i];
				_serviceIdsToItems[id].addEventListener(MouseEvent.CLICK,_serviceOnClick,false,0,true);
				//_serviceIdsToItems[id].addEventListener(MouseEvent.ROLL_OVER,_navOnRollOver,false,0,true);
				//_serviceIdsToItems[id].addEventListener(MouseEvent.ROLL_OUT,_navOnRollOut,false,0,true);
				_serviceItemsToIds[_serviceIdsToItems[id]] = id;
			}//end for			
		}//end function
		
		public function setupResize():void{
			
			Resize.add(
				"@Grad",
				_mc.grad_mc.g,
				[Resize.FULLSCREEN_X, Resize.CUSTOM],
				{
				
					custom:				function($target, $params, $stage):void{
						
						Out.debug(this, "grad w: "+_mc.grad_mc.width+" grad h: "+_mc.grad_mc.height+ " grad alpha: "+_mc.grad_mc.alpha);
							if ($stage.stageHeight > 643) _mc.grad_mc.g.height = $stage.stageHeight - (Constants.BOTTOM_OFFSET - 135);
							else _mc.grad_mc.g.height = 389;
					}//end custom function
				}//end 4th resize add parameter
			);//end @Grad
			
		}//end function
		
		
		override public function get xml():XML{
			return _xml;
		}
		
		override public function beginCustomLoad():void{
			super.beginCustomLoad();
			
		}//end function 
		private function _serviceOnClick($me:MouseEvent):void{
			Out.status(this, "_serviceOnClick(): show picture");
		}//end function 
	}//end class
}//end package