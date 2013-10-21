package com.viburnum.components
{
	import com.viburnum.components.baseClasses.PanelBase;
	import com.viburnum.components.supportClasses.WindowTitleBar;
	
	public class Panel extends PanelBase
    {
        public function Panel()
        {
            super();

			myTitleBar = new WindowTitleBar();
        }
    }
}