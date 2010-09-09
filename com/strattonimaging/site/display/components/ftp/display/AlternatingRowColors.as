package com.strattonimaging.site.display.components.ftp.display{

    import fl.controls.listClasses.CellRenderer;
    import fl.controls.listClasses.ICellRenderer;

    /**
     * This class sets the upSkin style based on the current item's index in a list.
     * Make sure the class is marked "public" and in the case of our custom cell renderer, 
     * extends the CellRenderer class and implements the ICellRenderer interface.
     */
    public class AlternatingRowColors extends CellRenderer implements ICellRenderer {

        /**
         * Constructor.
         */
        public function AlternatingRowColors():void {
            super();
        }

        /**
         * This method returns the style definition object from the CellRenderer class.
         */
        public static function getStyleDefinition():Object {
            return CellRenderer.getStyleDefinition();
        }

        /** 
         * This method overrides the inherited drawBackground() method and sets the renderer's
         * upSkin style based on the row's current index. For example, if the row index is an
         * odd number, the upSkin style is set to the CellRenderer_upSkinDarkGray linkage in the 
         * library. If the row index is an even number, the upSkin style is set to the 
         * CellRenderer_upSkinGray linkage in the library.
         */
        override protected function drawBackground():void {
            if (_listData.index % 2 == 0) {
                setStyle("upSkin", CellRenderer_upSkinGray);
            } else {
                setStyle("upSkin", CellRenderer_upSkinDarkGray);
            }
            super.drawBackground();
        }
    }
}
