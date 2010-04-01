package com.strattonimaging.site.display.components
{
	import com.bigspaceship.events.AnimationEvent;
	import com.bigspaceship.utils.Lib;
	import com.bigspaceship.utils.Out;
	import com.strattonimaging.site.Constants;
	import com.strattonimaging.site.display.screens.Screen;
	
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	import net.ored.util.Resize;
	
	public class Footer extends Screen
	{
		
		private var _bgTile		:BitmapData;
		private var _bgSprite	:Sprite;
		
		public function Footer($mc:MovieClip, $xml:XML, $useWeakReference:Boolean=false)
		{
			super($mc, $xml, $useWeakReference);
			_init();
			
		}//end constructor
		private function _init():void{
			_bgTile = Lib.createBitmapData("bgTile", _mc);
			Out.status(this, "here is our background tile: "+_bgTile);
			_bgSprite = new Sprite();
			_mc.addChildAt(_bgSprite, 0);			
			
		}
		override protected function _onAnimateInStart():void{
			Out.info(this, "HEY YO_onAnimateInStart()");
			
			Resize.add(
				"@footerCenter",
				_mc,
				[Resize.CENTER_X, Resize.CUSTOM],
				{
							
					custom:				function($target, $params, $stage):void{
						Out.debug(this, "here is the y val of the movie clip: "+_mc.y);
						if ($stage.stageHeight > 643){
							_mc.y = $stage.stageHeight-643;
						}
						_bgSprite.graphics.beginBitmapFill(_bgTile, null, false);
						_bgSprite.graphics.drawRect(0, 0, $stage.stageWidth, $stage.stageHeight);
						_bgSprite.graphics.endFill();

					}
				}
			);//end @footerCenter
			Resize.add(
				"@footerBg",
				_bgSprite,
				[Resize.CUSTOM],
				{
					
					custom:				function($target, $params, $stage):void{
						Out.debug(this, "here is the y val of the movie clip: "+_bgSprite.y);
						if ($stage.stageHeight > 643){
							_mc.y = $stage.stageHeight-643;
						}
						_bgSprite.graphics.beginBitmapFill(_bgTile, null, false);
						_bgSprite.graphics.drawRect(0, 0, $stage.stageWidth, $stage.stageHeight);
						_bgSprite.graphics.endFill();
						
					}
				}
			);//end @footerCenter
		}
		override protected function _onAnimateIn():void{
			Out.info(this, "HEEEEEEYYYYY_onAnimateIn()");

		}//end function
	}//end class
}//end package