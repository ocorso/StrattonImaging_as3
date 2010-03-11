/**
 * Out by Big Spaceship. 2006
 *
 * To contact Big Spaceship, email info@bigspaceship.com or write to us at 45 Main Street #716, Brooklyn, NY, 11201.
 * Visit http://labs.bigspaceship.com for documentation, updates and more free code.
 *
 *
 * Copyright (c) 2006-2009 Big Spaceship, LLC
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
package com.bigspaceship.utils
{
	import flash.utils.getQualifiedClassName;
	import flash.events.EventDispatcher;
	import flash.display.Stage;

	import com.bigspaceship.events.OutEvent;
	
	import com.carlcalderon.arthropod.Debug;
	
	/**
	 * Out
	 *
	 * @copyright 		2006 Big Spaceship, LLC
	 * @author			
	 * @version			1.0
	 * @langversion		ActionScript 3.0 			
	 * @playerversion 	Flash 9.0.0
	 *
	 */
	public class Out extends EventDispatcher{
		
		public  static const INFO      : Number = 0;
		public  static const STATUS    : Number = 1;
		public  static const DEBUG     : Number = 2;
		public  static const WARNING   : Number = 3;
		public  static const ERROR     : Number = 4;
		public  static const FATAL     : Number = 5;
		
		private static var __levels    : Array  = new Array();
		private static var __silenced  : Object = new Object();
		private static var __instance  : Out;	
		
		private static var __useArthropod		: Boolean;
		
		public function Out() {}
		
	
		public static function enableLevel($level:Number):void {
			__levels[$level] = __output;
		}
		
		public static function disableLevel($level:Number):void {
			__levels[$level] = __foo;
		}
		
		public static function enableAllLevels($useArthropod:Boolean = false):void {
			__useArthropod = $useArthropod;
			if(!$useArthropod) Debug.allowLog = false;
			
			enableLevel(INFO   );
			enableLevel(STATUS );
			enableLevel(DEBUG  );
			enableLevel(WARNING);
			enableLevel(ERROR  );
			enableLevel(FATAL  );
		}
		
		public static function disableAllLevels():void {
			__useArthropod = false;
			Debug.allowLog = false;
			
			disableLevel(INFO   );
			disableLevel(STATUS );
			disableLevel(DEBUG  );
			disableLevel(WARNING);
			disableLevel(ERROR  );
			disableLevel(FATAL  );
		}
		
		public static function isSilenced($o:*):Boolean {
			var s:String = __getClassName($o);
			
			return __silenced[s];
		}
		
		public static function silence($o:*):void {
			var s:String = __getClassName($o);
			
			__silenced[s] = true;
		}
		
		public static function unsilence($o:*):void {
			var s:String = __getClassName($o);
			
			__silenced[s] = false;
		}
		
		public static function info($origin:*, $str:String):void {
			if(isSilenced($origin)) return;
			
			if(__levels.hasOwnProperty(INFO))__levels[INFO]("INFO", $origin, $str, OutEvent.INFO);
		}
		
		public static function status($origin:*, $str:String):void {
			if(isSilenced($origin)) return;
			
			if(__levels.hasOwnProperty(STATUS))__levels[STATUS]("STATUS", $origin, $str, OutEvent.STATUS);
		}
		
		public static function debug($origin:*, $str:String):void {
			if(isSilenced($origin)) return;
			
			if(__levels.hasOwnProperty(DEBUG))__levels[DEBUG]("DEBUG", $origin, $str, OutEvent.DEBUG);
		}
		
		public static function warning($origin:*, $str:String):void {
			if(isSilenced($origin)) return;
			
			if(__levels.hasOwnProperty(WARNING))__levels[WARNING]("WARNING", $origin, $str, OutEvent.WARNING);
		}
		
		public static function error($origin:*, $str:String):void {
			if(isSilenced($origin)) return;
			
			if(__levels.hasOwnProperty(ERROR))__levels[ERROR]("ERROR", $origin, $str, OutEvent.ERROR);
		}
		
		public static function fatal($origin:*, $str:String):void {
			if(isSilenced($origin)) return;
			
			if(__levels.hasOwnProperty(FATAL))__levels[FATAL]("FATAL", $origin, $str, OutEvent.FATAL);
		}
		
		
		// Arthropod specific =========================================
		public static function clear():void {
			if(__useArthropod) Debug.clear();
		}
		public static function array($arr:Array):void {
			if(__useArthropod) Debug.array($arr);
		}
		public static function bitmap($bmd:*, $label:String = null):Boolean {
			if(__useArthropod){ return Debug.bitmap($bmd, $label) }
			return false;
		}
		public static function snapshot($stage:Stage, $label:String = null):Boolean {
			if(__useArthropod) { return Debug.snapshot($stage, $label) }
			return false;
		}
		//public static function object($obj:*):Boolean {
		//	if(__useArthropod) { return Debug.object($obj) }
		//	return false;
		//}
		
		// ========================================= Arthropod specific
		
		public static function traceObject($origin:*, $str:String, $obj:*):void{
			if(isSilenced($origin)) return;
			
			__output("OBJECT", $origin, $str, OutEvent.ALL);
			for(var p:* in $obj) __output("", null, p + " : " + $obj[p], OutEvent.ALL);
		}
		
		public static function addEventListener($type:String, $func:Function):void{
			__getInstance().addEventListener($type, $func);
		}
		
		public static function removeEventListener($type:String, $func:Function):void {
			__getInstance().removeEventListener($type, $func);
		}
		
		private static function __getInstance():Out{
			return (__instance ? __instance : (__instance = new Out()));
		}
		
		public static function createInstance():void
		{
			var i:*;
			var ii:*;
			var reSilence:Object = {};			
			var reDisable:Array = [];
			
			for(i in __silenced) { reSilence[i] = __silenced; }
			for(i in __levels) { if(__levels[i] && __levels[i] == __foo) reDisable.push(i); }			
			enableAllLevels();
			for(ii in reSilence) { silence(ii); }
			for(ii=0;ii<reDisable.length;ii++) { disableLevel(reDisable[ii]); }
		}
		
		private static function __foo($level:String,$origin:*,$str:String,$type:String, $color:uint = 0):void {}
		
		private static function __output($level:String, $origin:*, $str:String, $type:String, $color:uint = 0xFEFEFE):void {
			var l:String = $level;
			var s:String = $origin ? __getClassName($origin) : "";
			var i:Out    = __getInstance();
			
			while(l.length < 8) l += " ";
			
			var output:String = l + ":::	" + s + "	:: " + $str;
			
			if(__useArthropod)
			{
				switch($level)
				{
					case "ERROR" :
						Debug.error(output);
					break;
					case "WARNING" :
						Debug.warning(output);
					break;
					case "FATAL" :
						Debug.log(output, Debug.RED);
					break;
					case "DEBUG" :
						Debug.log(output, Debug.PINK);
					break;
					case "STATUS" :
						Debug.log(output, Debug.GREEN);
					break;
					case "INFO" :
						Debug.log(output);
					break;
					case "" :
					case "OBJECT" :
						Debug.log(output, 0xBCF100);
					break;
				}
				
			}
			
			trace(output);
			
			i.dispatchEvent(new OutEvent(OutEvent.ALL, 	output));
			i.dispatchEvent(new OutEvent($type,           	output));
		}
		
		
		
		private static function __getClassName($o:*):String {
			var c:String = flash.utils.getQualifiedClassName($o);
			var s:String = (c == "String" ? $o : c.split("::")[1] || c);
			
			return s;
		}
		
	}
}