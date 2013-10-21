package com.viburnum.components
{
    import com.viburnum.components.baseClasses.ContainerBase;
    import com.viburnum.components.baseClasses.MutiSelectableViewPageBase;
    
    public class ViewStack extends MutiSelectableViewPageBase
    {
        public function ViewStack()
        {
            super();
			
			myContentGroup = new Group();
        }
		
		override public function addViewPageAt(viewPage:ContainerBase, index:int):void
		{
			if(viewPage == null || containViewPage(viewPage)) return;
			var n:int = getViewPageCount();
			if(index < 0 || index > n) return;
			
			super.addViewPageAt(viewPage, index);
			
			viewPage.setVisible(false);
		}
		
		override public function removeViewPageAt(index:int):void
		{
			var n:int = getViewPageCount();
			if((n == 0 && index != 0) || (index < 0 || index > n -1)) return;
			var viewPage:ContainerBase = getViewPageAt(index);
			if(viewPage == null || !containViewPage(viewPage)) return;

			super.removeViewPageAt(index);
			
			viewPage.setVisible(true);
		}
		
		override protected function pageViewSelected(lastSelectedIndex:int, currentSelectedIndex:int):void
		{
			if(lastSelectedIndex == currentSelectedIndex) return;
			
			var lastSelectedPage:ContainerBase = getViewPageAt(lastSelectedIndex);
			if(lastSelectedPage != null) lastSelectedPage.setVisible(false);
			
			var currentSelectedPage:ContainerBase = getViewPageAt(currentSelectedIndex);
			if(currentSelectedPage != null) currentSelectedPage.setVisible(true);
		}
    }
}