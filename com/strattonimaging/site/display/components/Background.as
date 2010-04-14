package com.strattonimaging.site.display.components
{
	import com.bigspaceship.display.StandardInOut;
	import com.bigspaceship.utils.Lib;
	import com.bigspaceship.utils.Out;
	import com.greensock.TweenLite;
	import com.strattonimaging.site.Constants;
	
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	import net.ored.util.Resize;
	
	public class Background extends StandardInOut
	{
		private var _bgTile		:BitmapData;
		private var _bgSprite	:Sprite;
		private static const tileOffset:int = 389;
		public function Background($mc:MovieClip, $useWeakReference:Boolean=false)
		{
			super($mc, $useWeakReference);
			Out.info(this, "we just created a background");
			_init();
			 
		}//end constructor
		
		private function _init():void{
			_mc.alpha = 0;
			_bgTile = Lib.createBitmapData("bgTile", _mc);
			_bgSprite = new Sprite();
			_mc.addChild(_bgSprite);			
			TweenLite.to(_mc, 1, {alpha:1});
		}//end function
		
		override protected function _onAnimateInStart():void{
			Resize.add(
			"@bgTile",
			_bgSprite,
			[Resize.CUSTOM],
			{
			
				custom:				function($target, $params, $stage):void{
						_bgSprite.graphics.beginBitmapFill(_bgTile, null, false);
						_bgSprite.graphics.drawRect(0, 0, $stage.stageWidth, 254);
						_bgSprite.graphics.endFill();
						
						if ($stage.stageHeight > 643){
							_bgSprite.y = Constants.BOTTOM_OFFSET+($stage.stageHeight-643);
						} else _bgSprite.y = Constants.BOTTOM_OFFSET;
				}//end custom function
			}//end 4th resize add parameter
			);//end @footerBg
			
			Resize.add(
				"@background",
				_mc.grad_mc.shape_mc,
				[Resize.CORNER_TL, Resize.FULLSCREEN],
				{
				}
				
			);//end @background resize
			
		}//end function onAnimateInStart
		override protected function _onAnimateIn():void{
			
		}//end function
	}//end class
}//end package