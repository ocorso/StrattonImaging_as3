package net.ored.util
{
	import com.bigspaceship.utils.Out;
	
	public class ObjectToString
	{
		/**
		 * This is a utility function that traces an object to arthropod's array  
		 * @param $obj
		 * 
		 */		
		public static function o($obj:Object):void{
			var a:Array = new Array();
			
			for (var e:String in $obj){
				var s:String = e + " : "+$obj[e];
				a.push(s);
			}
			Out.info(new ObjectToString(), a);
		}
	}
}