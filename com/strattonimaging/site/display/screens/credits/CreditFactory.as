package com.strattonimaging.site.display.screens.credits
{
	import com.bigspaceship.utils.Lib;
	import com.strattonimaging.site.model.Constants;
	
	import flash.display.MovieClip;
	/**
	 * This class is a nice little helper that takes an image and a string and creates a new credit
	 * it also manages the animation of the 2
	 *  
	 * @author ocorso
	 * 
	 */
	public class CreditFactory 
	{

		
		public static function createCredit($type:String, $name:String, $mc:*):ICredit{
			var credit:ICredit;
			
			switch ($type){
				case Constants.TYPE_IMG :
					credit = new Credit(Lib.createAsset("com.strattonimaging.site.display.screens.credits.CreditClip",$mc) as MovieClip);
					credit.type = Constants.TYPE_IMG;
					credit.mc.text_mc.textInner.tf.text = $name;
					//todo: add Image!
					//credit.mc.addChild($asset);
					break;
				case Constants.TYPE_VID :
					credit = new VideoCredit(Lib.createAsset("com.strattonimaging.site.display.screens.credits.CreditClip",$mc) as MovieClip);
					credit.type = Constants.TYPE_VID;
					credit.mc.text_mc.textInner.tf.text = $name;
					VideoCredit(credit).initVideo();
					break;
			}//end switch

			return credit;
		}//end function
				
	}//end class
}//end package