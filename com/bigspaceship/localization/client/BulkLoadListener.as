package com.bigspaceship.localization.client
{
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	
	
	/**
	 * 
	 * @author Benjamin Bojko
	 */	
	internal class BulkLoadListener extends EventDispatcher
	{
		
		private var _assetLoaders:Array;	// of IAssetLoader
		private var _numLoadersStarted:int;
		private var _numLoadersCompleted:int;
		
		private var _bytesTotal:uint;
		
		
		//==================================================
		// CONSTRUCTOR
		/**
		 * 
		 */		
		public function BulkLoadListener(){
			reset();
		}
		
		
		//==================================================
		// PUBLIC
		/**
		 * Adds an object implementing the IAssetLoader interface.
		 * 
		 * The IAssetLoader's loadEventDispatcher must be an
		 * EventDispatcher that dispatches the following events:
		 * 
		 * Event.OPEN
		 * Event.COMPLETE
		 * ProgressEvent.PROGRESS
		 * IOErrorEvent.IO_ERROR
		 * 
		 * These events are dispatched by LoaderInfo or URLLoader
		 * instances for example.
		 * 
		 * @param $mgr	An object implementing the IAssetLoader interface.
		 */			
		public function add( $loader:IAssetLoader ):void {
			_assetLoaders.push( $loader );
			$loader.loadEventDispatcher.addEventListener( Event.OPEN, _loaderOpen );
			$loader.loadEventDispatcher.addEventListener( Event.COMPLETE, _loaderComplete );
			$loader.loadEventDispatcher.addEventListener( ProgressEvent.PROGRESS, _loaderProgress );
			$loader.loadEventDispatcher.addEventListener( IOErrorEvent.IO_ERROR, _loaderError );
			$loader.loadEventDispatcher.addEventListener( Event.UNLOAD, _loaderUnload );
		}
		
		/**
		 * Removes all IAssetLoader and their listeners and
		 * resets all values to zero.
		 */		
		public function reset():void {
			
			if( _assetLoaders ){
				for( var i:int=0; i<_assetLoaders.length; i++ ){
					var loader:IAssetLoader = _assetLoaders[i] as IAssetLoader;
					loader.loadEventDispatcher.removeEventListener( Event.OPEN, _loaderOpen );
					loader.loadEventDispatcher.removeEventListener( Event.COMPLETE, _loaderComplete );
					loader.loadEventDispatcher.removeEventListener( ProgressEvent.PROGRESS, _loaderProgress );
					loader.loadEventDispatcher.removeEventListener( IOErrorEvent.IO_ERROR, _loaderError );
					loader.loadEventDispatcher.removeEventListener( Event.UNLOAD, _loaderUnload );
				}
			}
			
			_assetLoaders = new Array();
			_numLoadersStarted = 0;
			_numLoadersCompleted = 0;
			_bytesTotal = 0;
		}
		
		override public function toString():String {
			return "[ BulkLoadListener ]";
		}
		
		
		//==================================================
		// PUBLIC - ACCESSORS
		/**
		 * 
		 * @return Float from 0...1
		 */		
		public function get progress():Number {
			return bytesLoaded / bytesTotal;
		}
		
		public function get bytesLoaded():uint	{
			// return 0 until all loaders have started loading
			if( _numLoadersStarted < _assetLoaders.length ){
				return 0;
			}
			
			// calculate total bytes loaded
			var bytesLoaded:Number = 0;
			
			for( var i:int=0; i<_assetLoaders.length; i++ ){
				bytesLoaded	+= IAssetLoader( _assetLoaders[i] ).bytesLoaded;
			}
			
			return bytesLoaded;
		}
		
		public function get bytesTotal():uint	{
			_bytesTotal = 0;
			for( var i:int=0; i<_assetLoaders.length; i++ ){
				if(IAssetLoader( _assetLoaders[i] ).bytesTotal == 0){
					return 0;
				}else{
					_bytesTotal	+= IAssetLoader( _assetLoaders[i] ).bytesTotal;
				}
			}
			return _bytesTotal;
		}
		
		
		//==================================================
		// PROTECTED
		protected function _log( $msg:Object ):void {
			LocalizationManager.getInstance().log( this + "\t\t" + $msg );
		}
		
		
		//==================================================
		// PRIVATE - EVENT HANDLERS	
		private function _loaderOpen( $e:Event ):void {
			_numLoadersStarted++;
			
			_bytesTotal += $e.target.bytesTotal;
			
			// dispatch init if all loaders have started
			if(_numLoadersStarted >= _assetLoaders.length){
				dispatchEvent( new Event( Event.OPEN ) );
			}
		}
		
		private function _loaderProgress( $e:ProgressEvent ):void {
			dispatchEvent( new ProgressEvent(ProgressEvent.PROGRESS, false, false, bytesLoaded, bytesTotal ));
		}
		
		private function _loaderComplete( $e:Event ):void {
			_numLoadersCompleted++;
			
			// dispatch complete if all loaders are done
			if(_numLoadersCompleted >= _assetLoaders.length){
				dispatchEvent( new Event( Event.COMPLETE ) );
			}
		}
		
		private function _loaderError( $e:IOErrorEvent ):void {
			dispatchEvent( $e );
		}
		
		private function _loaderUnload( $e:Event ):void {
			// well good for you, you're unloaded, i don't care. not yet
		}
		

	}
}
















