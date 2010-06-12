package com.strattonimaging.site.display.components
{
	import com.bigspaceship.display.StandardInOut;
	import com.bigspaceship.loading.BigLoader;
	import com.bigspaceship.utils.Out;
	
	import flash.display.MovieClip;

	public class Gallery extends StandardInOut
	{
		private var _xml		:XMLList;
		private var _bl			:BigLoader;
		
		public function Gallery($mc:MovieClip, $imgList:XMLList, $bigLoader:BigLoader)
		{
			super($mc);
			_xml 	= $imgList;
			_bl		= $bigLoader;
			
			_init();
						
		}//end constructor
		
		private function _init():void{
			Out.status(this, "init:: label = "+_xml.label.toString());
			mc.tf.txt.text = _xml.label.toString();
		}//end function
	}//end class
}//end package