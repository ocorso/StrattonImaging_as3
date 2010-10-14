package net.ored.util
{
	import com.bigspaceship.loading.BigLoader;
	import com.bigspaceship.utils.Out;
	import com.bigspaceship.utils.out.adapters.ArthropodAdapter;
	
	import flash.display.Sprite;

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
		
		/**
		 * This is a function that returns a sprite that is a rectangle 
		 * filled with either red or cyan (#00FFFF)
		 *  
		 * @param $w - width of the rectangle
		 * @param $h - height of the rectange
		 * 
		 * @return - the newly created sprite
		 * 
		 */		
		public static function gimmeRect($w:Number, $h:Number):Sprite{
			var r:Sprite = new Sprite();
			r.graphics.beginFill(0x00FFFF,1);
			r.graphics.drawRect(0,0,$w,$h);
			r.graphics.endFill();
			return r;
		}
	}//end class
}//end package