package com.bigspaceship.localization.client.vo
{
	public class WrapperActionVO
	{
		
		public var id:String;
		public var keys:Array;
		public var values:Array;
		public var localeId:String;
		public var styleId:String;
		
		
		/**
		 * 
		 * @param $id
		 * @param $keys
		 * @param $values
		 * @param $localeId
		 * @param $styleId
		 * 
		 */
		public function WrapperActionVO(
			$id:String,
			$keys:Array=null, $values:Array=null,
			$localeId:String=null, $styleId:String=null
		){
			this.id = $id;
			this.keys = $keys;
			this.values = $values;
			this.localeId = $localeId;
			this.styleId = $styleId;
		}

	}
}