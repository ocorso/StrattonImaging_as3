package com.strattonimaging.site.display.components.ftp
{
	import fl.controls.listClasses.CellRenderer;

	public class FilenameCellRenderer extends CellRenderer
	{
		public var icon:String = "foo";
		
		public function FilenameCellRenderer()
		{
			super();
			var originalStyles:Object = CellRenderer.getStyleDefinition();
	        setStyle("upSkin",BlueBackground);
	        setStyle("downSkin",GreenBackground);
	        setStyle("overSkin",OrangeBackground);
	        setStyle("selectedUpSkin",originalStyles.selectedUpSkin);
	        setStyle("selectedDownSkin",originalStyles.selectedDownSkin);
	        setStyle("selectedOverSkin",originalStyles.selectedOverSkin);
		}
		
	}
}