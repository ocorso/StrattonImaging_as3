package net.ored.util
{
	import com.bigspaceship.utils.Out;
	
	/**
	 *this function traces out the flashvars passed into the swf 
	 * 
	 */	
	public class PrintFlashvars
	{
		public static function o($flashvars:Object):void{
			var o:Object = new Object();
			Out.info(o, "     Here are the flashvars:");
			Out.debug(o, "--------------------------------");
			for (var element:String in $flashvars){
				Out.info(o, element+" : "+$flashvars[element]);	
			}
			Out.debug(o, "---------------------------------");
		}//end function
	}
}