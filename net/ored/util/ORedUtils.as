package net.ored.util
{
	import com.bigspaceship.loading.BigLoader;
	import com.bigspaceship.utils.Out;
	import com.bigspaceship.utils.out.adapters.ArthropodAdapter;

	public class ORedUtils
	{
		public static function turnOutOn():void{
			Out.enableAllLevels();
			Out.registerDebugger(new ArthropodAdapter(true));
			Out.clear();
			Out.silence(Resize);
			Out.silence(BigLoader);	
		}//end function
		
		/**
		 * This is a utility function that traces an object to arthropod's array  
		 * @param $obj
		 * 
		 */		
		public static function objectToString($obj:Object):void{
			var a:Array = new Array();
			
			for (var e:String in $obj){
				var s:String = e + " : "+$obj[e];
				a.push(s);
			}
			Out.info(new Object(), a);
		}//end function
		
		/**
		 * This is a utility function that traces out an object
		 * specifically meant for the flashvars of a swf  
		 * @param $obj
		 * 
		 */		
		public static function printFlashVars($flashvars:Object):void{
			var o:Object = new Object();
			Out.info(o, "     Here are the flashvars:");
			Out.debug(o, "--------------------------------");
			for (var element:String in $flashvars){
				Out.info(o, element+" : "+$flashvars[element]);	
			}
			Out.debug(o, "---------------------------------");
		}//end function
	}//end class
}//end package